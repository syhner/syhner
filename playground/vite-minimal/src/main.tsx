import React, { useState } from "react";
import ReactDOM from "react-dom/client";

function App() {
  const [count, setCount] = useState(0);

  return <button onClick={() => setCount(count + 1)}>count is {count}</button>;
}

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
