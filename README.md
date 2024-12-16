# Cloudflare worker (workerd) Rust playground

## Setup development environment

```
## On Fedora (41):
sudo dnf install -y @development-tools just rustup npm

rustup-init -y
. "$HOME/.cargo/env"
echo "Rust installed."

REPO=EnigmaCurry/cf-functions-demo
git clone https://github.com/${REPO} ~/git/vendor/${REPO}
cd ~/git/vendor/${REPO}

just dev
```

The dev loop uses
[cargo-watch](https://github.com/watchexec/cargo-watch) to
automatically re-run `npx wrangler dev` on any source file changes.
This is in fact what `npx wrangler dev` is supposed to do on its own,
but in my experience it did not work, but restarting the process via
cargo-watch does.
