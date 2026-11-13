# web-platform-lab

## 2.0.0

### Major Changes

- [#537](https://github.com/eins78/web-platform-lab/pull/537) [`6370108`](https://github.com/eins78/web-platform-lab/commit/6370108e392f9e553bb5126304c9258365422f44) Thanks [@eins78-agents](https://github.com/apps/eins78-agents)! - Renamed from hello-world-web to web-platform-lab

  - npm package `hello-world-web` is now `web-platform-lab` (run with `npx web-platform-lab`); the `hello-world-web`
    command stays as an alias for all of 2.x
  - workspace scope `@hello-world-web/*` is now `@web-platform-lab/*`; `@web-platform-lab/lit-ssr-demo` is published with
    the app
  - images: `ghcr.io/eins78/web-platform-lab` and `eins78/web-platform-lab` on Docker Hub (the old names keep getting
    updates during the transition)
  - default page title is `Web Platform Lab`; the `DEBUG` namespace is `web-platform-lab:*`
  - systemd units and config are renamed to `web-platform-lab*` (see the README for moving an existing install)

### Patch Changes

- Updated dependencies [[`6370108`](https://github.com/eins78/web-platform-lab/commit/6370108e392f9e553bb5126304c9258365422f44)]:
  - @web-platform-lab/lit-ssr-demo@2.0.0
