# Cloudflare worker (workerd) Rust playground

## Setup development environment

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

The `just dev` target uses
[cargo-watch](https://github.com/watchexec/cargo-watch) to
automatically re-run `wrangler dev` on any source file changes. This
is in fact what `wrangler dev` is supposed to do on its own, but in my
experience it did not work. Restarting the process via cargo-watch
fixes the live reload feature.

## Add a domain to your account

Register an Internet domain name and add it to your Cloudflare
account. Configure DNS.


