# Cloudflare worker (workerd) Rust playground

## Setup development environment (native)

```
## On Fedora 41 (bash):
REPO=EnigmaCurry/cf-functions-demo

export PATH="$HOME/.cargo/bin:$PATH"
(set -e
sudo dnf install -y @development-tools just rustup npm

## Setup Rust:
rustup-init -y
echo "Rust installed."

## Clone repo:
git clone https://github.com/${REPO} ~/git/vendor/${REPO}
cd ~/git/vendor/${REPO}

## Create default environment file:
just -E .env-dist env

## Install dependencies
just deps

## Build deployment files (optional):
#just build
)

## Run dev server:
cd ~/git/vendor/${REPO}
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

### Use Podman instead (optional)

As an alternative to a local development environment, you can create
one in a Podman container:

```
## If .env file does not exist, you must create it:
cp -n .env-dist .env

## Run the dev server in podman:
just dev-podman
```

Open your browser (manually) to http://localhost:8787

## Configure database (optional)

Create a D1 (SQL) database:

```
just create-database
```

You must edit the `.env` file and add the database name and id. (TODO:
get the ID and put it in the .env file automatically. For now, you
have to login to the dashboard and copy the database id.)

```
### .env file excerpt:
## Worker database (d1):
## Both NAME and ID must be non-blank otherwise no database is configured.
WORKER_DATABASE_NAME=cf-functions-demo
WORKER_DATABASE_ID=xxxxxxxxx
```

### Database migrations

Create migration scripts to create and/or extend the schema of your
database over time.

> Note: I haven't been 100% successful with this. YMMV.

```
## Create an initial migration script named "ddl":
just migrations-create ddl
```

This will create the file: `./migrations/0002_ddl.sql` and you can
define your initial schema here. (`0001_example.sql` contains initial
playground example schemas that may be deleted if you wish.)

Apply all of the migration scripts in sequence:

```
just migrations-apply
```

## Deploy

```
just deploy
```

This should build and then open your web browser to ask to authorize
`wrangler` to deploy to your account on your behalf. If you don't want
to do it this way, you can edit `.env` and set `CLOUDFLARE_API_TOKEN`
with an API token you create in the dashboard.

You can set a custom domain name by editing the `.env` file.

### Deploy from Podman (optional)

If you set up a Podman environment, you may deploy from there instead:

```
just deploy-podman
```

You must set `CLOUDFLARE_API_TOKEN` in `.env` for this to work.
