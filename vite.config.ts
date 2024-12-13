import postcssSimpleVars from "postcss-simple-vars";
import react from "@vitejs/plugin-react-swc";
import { defineConfig } from "vite";
import path from "node:path";

// @biome-ignore lint/suspicious/noExplicitAny: In config file we can ignore any type errors
// @ts-ignore
import { BREAKPOINTS } from "./src/css/ui-config";

export default defineConfig({
  server: {
    proxy: {},
  },
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "./src"),
    },
  },
  css: {
    postcss: {
      plugins: [
        postcssSimpleVars({
          variables: Object.fromEntries(Object.entries(BREAKPOINTS).map(([k, v]) => [k, `${v}px`])),
        }),
      ],
    },
  },
  plugins: [react()],
  publicDir: "public",
});
