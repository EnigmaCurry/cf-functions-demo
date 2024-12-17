# Cloudflare worker (workerd) Rust playground

## Setup development environment (native)

```
## On Fedora (41):
sudo dnf install -y @development-tools just rustup npm

## Setup Rust:
rustup-init -y
. "$HOME/.cargo/env"
echo "Rust installed."

## Clone repo:
REPO=EnigmaCurry/cf-functions-demo
git clone https://github.com/${REPO} ~/git/vendor/${REPO}
cd ~/git/vendor/${REPO}

## Create default environment file:
cp -n .env-dist .env

## Build deployment files (optional):
#just build

## Run dev server:
just dev
```

> Note: The `just dev` target uses
> [cargo-watch](https://github.com/watchexec/cargo-watch) to
> automatically re-run `wrangler dev` on any source file changes. This
> is in fact what `wrangler dev` is supposed to do on its own, but in
> my experience it did not work. Restarting the process via
> cargo-watch fixes the live reload feature.

Once the server has started successfully you will see this displayed:

```
⎔ Starting local server...
╭──────────────────────────────────────────────────────────────────────────────────────────────────╮
│  [b] open a browser, [d] open devtools, [l] turn off local mode, [c] clear console, [x] to exit  │
╰──────────────────────────────────────────────────────────────────────────────────────────────────╯
```

 * Press the `b` key to open your web browser to http://localhost:8787
 * Edit the message in the root route: [root.rs](src/routes/root.rs)
 * Save the file and the server should automatically rebuild and reload.
 * Manually refresh the page in your browser to see the change.

### Use Podman (optional)

As an alternative to a local development environment, you can create
one in a Podman container:

```
just dev-podman
```

Open your browser (manually) to http://localhost:8787

## Add a domain to your account

Register an Internet domain name and add it to your Cloudflare
account. Configure DNS.


