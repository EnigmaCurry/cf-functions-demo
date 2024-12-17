set export

current_dir := `pwd`
RUST_LOG := "info"
RUST_BACKTRACE := "1"
container_image := `basename $(pwd)`

set dotenv-required := true

# print help for Just targets
help:
    @just -l

# Install local dependencies
deps:
    @if ! command -v npm > /dev/null; then \
      echo "Error: npm is not installed. Please install npm and try again." >&2; \
      exit 1; \
    fi
    @if ! command -v cargo-watch > /dev/null; then \
      cargo install cargo-watch; \
    fi
    @if ! command -v wrangler > /dev/null; then \
      mkdir -p "${HOME}/.npm"; \
      npm config set prefix "${HOME}/.npm"; \
      npm install -g wrangler; \
    fi
    @if ! command -v worker-build > /dev/null; then \
      cargo install worker-build; \
    fi

shell-podman arg="bash":
    podman run --rm -it \
       -v {{current_dir}}:/app:Z \
       --userns=keep-id \
       -p 8787:8787 \
       {{container_image}} \
       {{arg}}

dev-podman: build-podman config-podman
    just shell-podman "just dev-local"

dev-local: config
    PATH=${HOME}/.npm/bin:${PATH} \
    cargo watch --why -- \
    wrangler dev --live-reload false

deploy-podman: build-podman config-podman
    just shell-podman "just deploy-local"

deploy-local: build-local
    PATH=${HOME}/.npm/bin:${PATH} wrangler deploy
    @echo "Deployed"

create-database:
    @PATH=${HOME}/.npm/bin:${PATH}; \
    (wrangler d1 info ${WORKER_DATABASE_NAME} && \
    echo "Database already exists.") || \
    (wrangler d1 create ${WORKER_DATABASE_NAME} && \
    echo "Database created.")

clean:
    rm node_modules npm target .wrangler wrangler.toml -rf

build-podman:
    mkdir -p {{current_dir}}/build
    podman build \
      --build-arg BUILDER_UID=${UID} \
      --build-arg BUILDER_GID=${UID} \
      -t {{container_image}} {{current_dir}}
    @echo
    @container_id=$(podman create {{container_image}}) && \
      rm {{current_dir}}/build -rf && \
      podman cp ${container_id}:/app/build/ {{current_dir}}/build && \
      podman rm ${container_id}
    @echo "Build complete: {{current_dir}}/build"

build-local: config
    PATH=${HOME}/.npm/bin:${PATH} wrangler build

# Create .env file, Run: just -E .env-dist env
env:
    @if [[ ! -f .env ]]; then \
      cp .env-dist .env && \
      echo "Created new .env file." && \
      echo Edit .env to set extra config values by hand.; \
    else \
      echo ".env file already exists."; \
    fi

config:
    cd config && cargo run > {{current_dir}}/wrangler.toml
    @echo Recreated wrangler.toml from .env config.

config-podman:
    just shell-podman "just config"

# Build deployment files locally
build: build-local
    
# Deploy local build to cloudflare
deploy: deploy-local

# Run local development server
dev: dev-local
