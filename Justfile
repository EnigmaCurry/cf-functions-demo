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

dev-podman: build-podman
    podman run --rm -it \
       -v {{current_dir}}:/app:Z \
       --userns=keep-id \
       -p 8787:8787 \
       {{container_image}} \
       just -E .env-dist dev-local

dev-local:
    PATH=${HOME}/.npm/bin:${PATH} \
    cargo watch --why -i build -i target -i .wrangler -- \
    wrangler dev --live-reload false

# deploy-podman: build
#     podman run --rm -it \
#        -v {{current_dir}}:/app:Z \
#        --userns=keep-id \
#        {{container_image}} \
#        just -E .env-dist deploy-local

deploy-local: build-local
    PATH=${HOME}/.npm/bin:${PATH} wrangler deploy

clean:
    rm node_modules npm target .wrangler -rf

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

build-local:
    PATH=${HOME}/.npm/bin:${PATH} wrangler build

wrangler_config:
    @if [[ ! -f wrangler.toml ]]; then \
      envsubst '${WORKER_NAME} ${DEPLOYMENT} ${WORKER_USE_DEFAULT_DOMAIN}' < .wrangler.template.toml > wrangler.toml; \
      echo "## Created initial wrangler.toml"; \
    fi

# Build deployment files locally
build: build-local
    
# Deploy local build to cloudflare
deploy: deploy-local

# Run local development server
dev: dev-local
