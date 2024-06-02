import * as net from "net";
import fs from "fs";
import zlib from "zlib";

const directory = process.argv[3];
const CRLF = "\r\n";
const reasonPhrases = {
  200: "OK",
  201: "Created",
  404: "Not Found",
};

const server = net.createServer((socket) => {
  socket.on("data", (data) => {
    const request = data.toString();
    const [requestLineAndHeaders, requestBody] = request.split(`${CRLF}${CRLF}`);
    const [requestLine, ...requestHeaders] = requestLineAndHeaders.split(CRLF);
    const [requestMethod, requestPath, requestProtocol] = requestLine.split(" ");
    const requestHeadersMap = new Map<string, string>();
    requestHeaders.forEach((header) => {
      const [key, value] = header.split(": ");
      requestHeadersMap.set(key, value);
    });

    const responseHeaders = new Map<string, string | number>();
    let responseStatusCode: keyof typeof reasonPhrases;
    let responseBody: string | Buffer = "";
    let separateBody: boolean = false;

    if (requestPath === "/") {
      responseStatusCode = 200;
    } else if (
      requestPath.startsWith("/echo/") &&
      requestHeadersMap.get("Accept-Encoding")?.includes("gzip")
    ) {
      responseBody = zlib.gzipSync(requestPath.substring(6));
      responseHeaders.set("Content-Encoding", "gzip");
      responseHeaders.set("Content-Type", "text/plain");
      responseHeaders.set("Content-Length", responseBody.length);
      responseStatusCode = 200;
      separateBody = true;
    } else if (
      requestPath.startsWith("/echo/") &&
      !requestHeadersMap.get("Accept-Encoding")?.includes("gzip")
    ) {
      responseBody = requestPath.substring(6);
      responseHeaders.set("Content-Type", "text/plain");
      responseHeaders.set("Content-Length", responseBody.length);
      responseStatusCode = 200;
    } else if (requestPath.startsWith("/echo/")) {
      responseBody = requestPath.substring(6);
      responseHeaders.set("Content-Type", "text/plain");
      responseHeaders.set("Content-Length", responseBody.length);
      responseStatusCode = 200;
    } else if (requestPath === "/user-agent") {
      const userAgent = requestHeadersMap.get("User-Agent")!;
      responseBody = userAgent;
      responseHeaders.set("Content-Length", userAgent.length);
      responseHeaders.set("Content-Type", "text/plain");
      responseStatusCode = 200;
    } else if (requestMethod === "GET" && requestPath.startsWith("/files")) {
      responseHeaders.set("Content-Type", "application/octet-stream");
      try {
        const fileName = requestPath.substring(6);
        const fileContents = fs.readFileSync(directory + "/" + fileName);
        responseBody = fileContents.toString();
        responseHeaders.set("Content-Length", fileContents.length);
        responseStatusCode = 200;
      } catch (err) {
        responseStatusCode = 404;
      }
    } else if (requestMethod === "POST" && requestPath.startsWith("/files")) {
      const fileName = requestPath.substring(6);
      fs.writeFileSync(directory + "/" + fileName, requestBody);
      responseStatusCode = 201;
    } else {
      responseStatusCode = 404;
    }

    const responseHeadersAsString = Array.from(responseHeaders.entries())
      .map(([key, value]) => `${key}: ${value}`)
      .join(CRLF);

    let response = `${requestProtocol} ${responseStatusCode} ${reasonPhrases[responseStatusCode]}${CRLF}${responseHeadersAsString}${CRLF}${CRLF}`;
    if (!separateBody) response += responseBody;
    socket.write(response);
    if (separateBody) socket.write(responseBody);
    socket.end();
  });
});

server.listen(4221, "localhost", () => {
  console.log("Server is running on port 4221");
});

/*
  Status line
  HTTP/1.1  // HTTP version
  200       // Status code
  OK        // Optional reason phrase
  \r\n      // CRLF that marks the end of the status line

  Headers (CRLF separated)
  \r\n      // CRLF that marks the end of the headers

  Body
 */
