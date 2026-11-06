# Web Platform Lab

> Formerly *Hello World (Wide) Web*, npm package `hello-world-web`. In 2.x the `hello-world-web` command still works
> as an alias for `web-platform-lab`.

Small toy web server with a few features to test and debug several HTTP- and web-related festures. 
Usefull for testing Web features, infrastructure (Docker, Kubernetes, …), CI/CD workflows (builds, deployments, …), and other tools and services.

* relatively small footprint
* larger dev-dependencies (typescript, eslint, prettier, >100MB), usefull to compare build sizes of dev vs prod
* CSS styles as static assets, to verify proper routing and serving of assets.

Run, then open <http://localhost:8080> or `open http://localhost:$PORT`.

## Features

### Quick Setup
* **No configuration needed** - Works with sensible defaults
* **Small footprint** - Less than 2MB in production
* **Multiple deployment methods** - Run with npm, Docker, systemd, or cloud buildpacks
* **Direct execution** - Run with `npx web-platform-lab` without installation
* **Development container** - Pre-configured devcontainer for [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and GitHub Codespaces

### User Interface
* **Homepage** - Shows app title, description, configuration info and version
* **Basic CSS styling** - modern, CSS variables, dark mode

### HTTP APIs

| Endpoint | Method | Description |
| -------- | ------ | ----------- |
| `/api/config` | GET | Returns server configuration including version, startup time, and settings |
| `/api/time` | GET | Provides current server timestamp in ISO format |
| `/api/client` | GET/POST | Shows complete client request information (IP, headers, browser details) |
| `/api/client/:field` | GET/POST | Returns specific client information field |

All API endpoints support content negotiation (JSON, HTML, plain text) based on Accept headers.

Example:
```bash
$ curl -L lab.kiste.li/api/client/userAgent
curl/8.11.0
```

### Demos

Web platform features and capabilities demonstrated with small interactive examples.

#### Web Components Demo
* **Counter component** - Interactive counter demonstrating server-side rendering with client-side hydration using [lit SSR](https://lit.dev/docs/ssr/overview/)
* **Epoch counter** - Shows server render time with client-side hydration

### Health Monitoring
* **Health check endpoint** - Available at `/api/time?healthcheck`
* **Docker health checks** - Built-in support for Docker and Docker Compose
* **Monitoring script** - Standalone health check script for external monitoring

### Configuration
* **Environment variables** - Multiple configuration options available (see [Configuration](#configuration-1) section)
* **Port configuration** - Supports multiple configuration sources (.env, Docker, environment)
* **Base path support** - Deploy under subdirectories with BASE_PATH setting
* **Custom branding** - Configurable app title and description with HTML support

## Configuration

The application can be configured through environment variables. 

| Variable | Description | Default | Example |
| -------- | ----------- | ------- | ------- |
| `PORT` | HTTP port for the server | `9999` | `8080` |
| `BASE_PATH` | Base path for deployment under subdirectories | `/` | `/my-app/` |
| `APP_TITLE` | Application title shown on homepage | `Web Platform Lab` | `My <b>App</b>` |
| `APP_DESCRIPTION` | Application description (supports HTML) | `A simple web server for testing...` | `Welcome to my <b>awesome</b> server!` |
| `APP_NAME` | Application name (read-only) | `web-platform-lab` | - |
| `APP_URL` | Repository or project URL | `https://github.com/eins78/web-platform-lab` | - |
| `APP_VERSION` | Application version | `version` from `package.json` | - |

### Port Configuration Precedence

The PORT can be configured in multiple ways. This table shows the order of precedence (last wins):

| Config Source | Default Port |
| ------------- | ------------ |
| webserver (internal default) | `9999` |
| `.env` file | `4444` |
| `Dockerfile` | `7777` |
| `docker-compose.yaml` | `3333` |
| `PORT` environment variable | `8080` |

## Debugging

### Port Configuration Testing

All examples in this documentation assume that port `8080` will be configured, but this port is nowhere used as a default so any misconfiguration will be spotted. Different default ports are used for each configuration source to help identify which configuration was applied (see [Port Configuration Precedence](#port-configuration-precedence) above).

### Healthcheck

There is a healthcheck script that checks if the homepage is served with a non-error status.
Note that the query parameter `?healthcheck` is used, but not handled specifically by the server,
it just helps to identifiy the healthcheck requests in logs.

* `GET https://localhost:${PORT}/api/time?healthcheck`
* Node.js script: `bin/healthcheck.mjs`
* with `docker` and `docker-compose`, see

    ```sh
    ctr=web-platform-lab-webserver-1
    docker inspect $ctr | jq '.[0].State.Health'
    ```

## Cloud Deployment

### Google Cloud Run

The application is automatically deployed to Google Cloud Run when code is merged to the main branch.

**Live Demo**: https://test.lab.kiste.li

**Container Registries**:
- **Google Artifact Registry** - Primary registry for Cloud Run deployments (instant availability)
- **GitHub Container Registry (GHCR)** - Public registry (`ghcr.io/eins78/web-platform-lab`)
- **Docker Hub** - Public registry (`eins78/web-platform-lab`)

For detailed setup instructions, see:
- [Google Artifact Registry Setup](docs/google-artifact-registry-setup.md) - Fast Cloud Run deployments
- [Cloud Run Deployment Guide](docs/cloud-run-deployment.md) - Complete deployment documentation

## Running on different platforms

`web-platform-lab` can be run on a variety of platforms, using different runtimes and tools.

### Run with Node.js

Install [node.js](https://nodejs.org/en/download).
Needs Node.js v26 or later (native support of TypeScript).

#### Run from source with Node.js

Clone this repository and run the app:

```bash
export PORT=8080
npm ci --prod
npm start
```

### Run from source with Node.js using `npx`

Clone this repository and run the app:

```bash
export PORT=8080
pnpm run build
npx .
```

### Run from published package with Node.js using `npx`

```bash
export PORT=8080
npx web-platform-lab
```

### Run from latest code on github using `npx`

```bash
export PORT=8080
npx https://github.com/eins78/web-platform-lab
```

### Run with `docker`

Use a prebuilt image, or build one locally with Docker either directly or using buildpacks.

#### use a prebuilt image hosted on the Github Container registry

```bash
IMG=ghcr.io/eins78/web-platform-lab:main
docker pull $IMG
```

#### build locally and run

```bash
IMG=web-platform-lab
docker buildx build --load -t $IMG .
# or with a different base image:
docker buildx build --build-arg BASEIMAGE=node:slim --load -t $IMG .
```

#### build with `buildpacks`

Builds in a docker "builder" Docker container and outputs a "runner" Docker image.

* see [`buildpacks.io`](https://buildpacks.io)
* images published (manually) on dockerhub, so far only under the old name: <https://hub.docker.com/r/eins78/hello-world-web-buildpacks>

```bash
brew install buildpacks/tap/pack

app_version="$(node -p 'require("./package.json").version')"
IMG="eins78/web-platform-lab-buildpacks:${app_version}.0"
PACK_BUILDER="paketobuildpacks/builder:base"

pack build "$IMG" --builder "$PACK_BUILDER"
# to publish: docker push "$IMG"
```

#### run the image

```bash
export PORT=8080
export "APP_TITLE=Hello ${USER}@$(hostname -s)"!
docker run --rm -it -e APP_TITLE -e PORT -p $PORT:$PORT $IMG
```

### Run with `docker-compose`

```bash
export PORT=8080
cp .env-default .env
docker compose up --build
```

### Run with `systemd` and `Docker`

install systemd config and service:

```bash
curl -fsSL https://raw.githubusercontent.com/eins78/web-platform-lab/main/deploy/systemd/web-platform-lab.conf | sudo tee /etc/web-platform-lab.conf
curl -fsSL https://raw.githubusercontent.com/eins78/web-platform-lab/main/deploy/systemd/web-platform-lab-docker.service | sudo tee /etc/systemd/system/web-platform-lab.service
sudo systemctl daemon-reload
sudo systemctl enable web-platform-lab
sudo systemctl restart web-platform-lab
sudo systemctl status web-platform-lab
sudo journalctl -efu web-platform-lab 
```

### Run with `systemd` and `node.js`

Install [node.js](https://nodejs.org/en/download), see [nodesource/distributions](https://github.com/nodesource/distributions?tab=readme-ov-file#installation-instructions).
Debian/Ubuntu example:

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - && \
sudo apt-get install -y nodejs
```

install app code, config and systemd service:

```bash
sudo git clone https://github.com/eins78/web-platform-lab.git /opt/web-platform-lab
sudo cp /opt/web-platform-lab/deploy/systemd/web-platform-lab.conf /etc/web-platform-lab.conf
sudo cp /opt/web-platform-lab/deploy/systemd/web-platform-lab.service /etc/systemd/system/web-platform-lab.service
sudo mkdir -p /var/www/
sudo chown -R www-data /var/www /opt/web-platform-lab /etc/web-platform-lab.conf
sudo systemctl daemon-reload
sudo systemctl enable web-platform-lab
sudo systemctl restart web-platform-lab
sudo systemctl status web-platform-lab
sudo journalctl -efu web-platform-lab 
```

#### Moving an install from before the rename

Before 2.0.0 the unit was `hello-world-web.service`, with the config in `/etc/hello-world-web.conf` (and the code in
`/opt/hello-world-web` for the `node.js` variant). Remove the old unit and keep your config under the new name:

```bash
sudo systemctl disable --now hello-world-web
sudo rm /etc/systemd/system/hello-world-web.service
sudo mv /etc/hello-world-web.conf /etc/web-platform-lab.conf
# node.js variant only:
sudo mv /opt/hello-world-web /opt/web-platform-lab
```

Then install the new unit as above, skipping the line that writes the config file. If your config sets
`DEBUG="hello-world-web:*"`, change it to `DEBUG="web-platform-lab:*"`.

## Development

```bash
pnpm i
pnpm dev
```

### direnv

See <https://direnv.net/#basic-installation>.

```sh
brew install direnv || apt install direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc

direnv allow .
```

### Typescript in Javascript files

See <https://www.typescriptlang.org/docs/handbook/jsdoc-supported-types.html>.

### Running Typescript natively in Node.js

* <https://nodejs.org/en/learn/typescript/run-natively#running-typescript-natively>
* <https://nodejs.org/docs/latest/api/typescript.html#typescript-features>

### running tests

the following commands will run all tests like in CI (Github Actions), but locally:

```bash
pnpm run ci
```

To test GitHub Actions workflows locally using `act`, see [Testing Workflows Locally](docs/testing-github-workflows-locally.md).

### E2E (End-to-End) tests

* [Playwright](https://playwright.dev/) with [playwright-bdd](https://github.com/vitalets/playwright-bdd)
* BDD approach using Gherkin syntax
* See [packages/e2e-tests/README.md](packages/e2e-tests/README.md) for details
* [Gherkin writing guidelines](packages/e2e-tests/GHERKIN_RULES.md)

### renovate bot

The Renovate bot is configured to update dependencies and create PRs.
Non-Major updates are automatically merged after the CI checks pass.
When updating the renovate config (`renovate.json5`), the branch should be prefixed with `renovate/` so that the bot will validate the changes when a PR is created.

* Docs: <https://docs.renovatebot.com/configuration-options/>
* [Dependency Dashboard](https://github.com/eins78/web-platform-lab/issues/46)
