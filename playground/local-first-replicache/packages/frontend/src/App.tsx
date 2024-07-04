import React, { useEffect, useRef, useState } from "react";
import ReactDOM from "react-dom/client";
import { Replicache, TEST_LICENSE_KEY, WriteTransaction } from "replicache";
import { useSubscribe } from "replicache-react";
import Pusher from "pusher-js";
import { nanoid } from "nanoid";
import { type Message } from "shared";

export default function App() {
  const licenseKey = import.meta.env.VITE_REPLICACHE_LICENSE_KEY || TEST_LICENSE_KEY;
  if (!licenseKey) {
    throw new Error("Missing VITE_REPLICACHE_LICENSE_KEY");
  }

  const [replicache, setReplicache] = useState<Replicache<any> | null>(null);

  useEffect(() => {
    console.log("updating replicache");
    const r = new Replicache({
      name: "chat-user-id",
      licenseKey,
      mutators: {
        async createMessage(tx: WriteTransaction, { id, from, content, order }: Message) {
          await tx.set(`message/${id}`, {
            from,
            content,
            order,
          });
        },
      },
      pushURL: "/api/replicache/push",
      pullURL: "/api/replicache/pull",
      logLevel: "debug",
    });
    setReplicache(r);

    // opening a connection to the server to begin receiving events from it
    const eventSource = new EventSource("/api/replicache/poke");

    // attaching a handler to receive message events
    eventSource.onmessage = (event) => {
      console.log(event.data);
    };

    return () => {
      eventSource.close();
      void r.close();
    };
  }, []);

  const messages = useSubscribe(
    replicache,
    async (tx) => {
      const list = await tx.scan<Omit<Message, "id">>({ prefix: "message/" }).entries().toArray();
      list.sort(([, { order: a }], [, { order: b }]) => a - b);
      return list;
    },
    { default: [] }
  );

  const usernameRef = useRef<HTMLInputElement>(null);
  const contentRef = useRef<HTMLInputElement>(null);

  const onSubmit = async (e: React.FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    let last: Omit<Message, "id"> | null = null;
    if (messages.length) {
      const lastMessageTuple = messages[messages.length - 1];
      last = lastMessageTuple[1];
    }
    const order = (last?.order ?? 0) + 1;
    const username = usernameRef.current?.value ?? "";
    const content = contentRef.current?.value ?? "";

    await replicache?.mutate.createMessage({
      id: nanoid(),
      from: username,
      content,
      order,
    });

    if (contentRef.current) {
      contentRef.current.value = "";
    }
  };

  return (
    <div>
      <form onSubmit={onSubmit}>
        <input ref={usernameRef} required /> says:
        <input ref={contentRef} required /> <input type="submit" />
      </form>
      {messages.map(([key, value]) => (
        <div key={key}>
          <b>{value.from}: </b>
          {value.content}
        </div>
      ))}
    </div>
  );
}
