---
"web-platform-lab": major
"@web-platform-lab/lit-ssr-demo": major
---

Renamed from hello-world-web to web-platform-lab

- npm package `hello-world-web` is now `web-platform-lab` (run with `npx web-platform-lab`); the `hello-world-web`
  command stays as an alias for all of 2.x
- workspace scope `@hello-world-web/*` is now `@web-platform-lab/*`; `@web-platform-lab/lit-ssr-demo` is published with
  the app
- images: `ghcr.io/eins78/web-platform-lab` and `eins78/web-platform-lab` on Docker Hub (the old names keep getting
  updates during the transition)
- default page title is `Web Platform Lab`; the `DEBUG` namespace is `web-platform-lab:*`
- systemd units and config are renamed to `web-platform-lab*` (see the README for moving an existing install)
