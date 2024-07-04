import { Hono } from "hono";
import { push } from "./replicache/push";
import { pull } from "./replicache/pull";
import { streamSSE } from "hono/streaming";
import { cors } from "hono/cors";

const app = new Hono()
  .use("*", (ctx, next) => {
    const wrapped = cors({
      origin: "http://localhost:5173",
    });
    return wrapped(ctx, next);
  })
  .basePath("/api")
  .get("/health", (c) => c.text("ok"))
  .post("/health", (c) => c.text("no"))
  .route("/replicache/pull", pull)
  .route("/replicache/push", push)
  .get("/replicache/poke", (c) => {
    return streamSSE(c, async (stream) => {
      // Write a process to be executed when aborted.
      stream.onAbort(() => {
        console.log("Aborted!");
      });
      // Write a Uint8Array.
      await stream.write(new Uint8Array([0x48, 0x65, 0x6c, 0x6c, 0x6f]));
      const t0 = Date.now();
      await stream.write("hi");
      console.log("Sent poke in", Date.now() - t0);
    });
  });

export default app;
