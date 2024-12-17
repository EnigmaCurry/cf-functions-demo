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

# Run dev server in Podman
dev: build
    podman run --rm -it \
       -v {{current_dir}}:/app:Z \
       -v /run/user/$(id -u)/bus:/run/user/$(id -u)/bus:Z \
       --userns=keep-id \
       -p 8787:8787 \
       {{container_image}} \
       just -E .env-dist dev-local

# Run local dev server
dev-local:
    PATH=${HOME}/.npm/bin:${PATH} \
    cargo watch --why -i build -i target -i .wrangler -- \
    wrangler dev --live-reload false

deploy: build
    @${NPM_ROOT}/bin/wrangler 

clean:
    rm node_modules npm target .wrangler -rf

# build worker with Podman
build:
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

# build worker with local wrangler tool
build-local:
    PATH=${HOME}/.npm/bin:${PATH} wrangler build
