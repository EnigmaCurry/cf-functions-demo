set export
set dotenv-required := true

current_dir := `pwd`
RUST_LOG := "info"
RUST_BACKTRACE := "1"
NPM_ROOT := "{{HOME}}/.npm"
container_image := `basename $(pwd)`

# print help for Just targets
help:
    @just -l

# # Install dependencies
# deps:
#     @if ! command -v npm > /dev/null; then \
#       echo "Error: npm is not installed. Please install npm and try again." >&2; \
#       exit 1; \
#     fi
#     @if ! command -v cargo-watch > /dev/null; then \
#       cargo install cargo-watch; \
#     fi
#     @if ! command -v wrangler > /dev/null; then \
#       mkdir -p "${NPM_ROOT}"; \
#       npm config set prefix "${NPM_ROOT}"; \
#       npm install -g wrangler; \
#     fi
#     @if ! command -v worker-build > /dev/null; then \
#       cargo install worker-build; \
#     fi

# Run local dev server
dev:
    cargo watch --why -i build -i target -- wrangler dev --live-reload false

deploy: build
    @${NPM_ROOT}/bin/wrangler 

clean:
    rm node_modules npm target .wrangler -rf

# build worker with Podman
build:
    mkdir -p {{current_dir}}/build
    podman build -t {{container_image}} {{current_dir}}
    @echo
    @container_id=$(podman create {{container_image}}) && \
      rm {{current_dir}}/build -rf && \
      podman cp ${container_id}:/app/build/ {{current_dir}}/build && \
      podman rm ${container_id}
    @echo "Build complete: {{current_dir}}/build"

# build worker with local wrangler tool
build-local:
    PATH=${HOME}/.npm/bin:${PATH} wrangler build
