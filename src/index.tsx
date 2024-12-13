import { createRoot } from "react-dom/client";

import { App } from "./App";
import "./css/index.css";

createRoot(document.getElementById("root") as HTMLElement).render(<App />);
