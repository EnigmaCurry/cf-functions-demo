FROM fedora:41 AS tools
RUN dnf install -y @development-tools just rustup npm xdg-utils host-spawn && \
    dnf clean all
ARG BUILDER_UID=1000
ARG BUILDER_GID=1000
RUN groupadd -g ${BUILDER_GID} builder && \
    useradd -u ${BUILDER_UID} -g ${BUILDER_GID} -ms /bin/bash builder
USER builder
ENV USER=builder \
    HOME=/home/builder \
    CARGO_HOME=/home/builder/.cargo \
    RUSTUP_HOME=/home/builder/.rustup \
    PATH=/home/builder/.cargo/bin:$PATH
RUN rustup-init -y --no-modify-path && \
    curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall cargo-watch worker-build && \
    mkdir ${HOME}/.npm && \
    npm config set prefix ${HOME}/.npm && \ 
    npm install -g wrangler

FROM tools AS build
WORKDIR /app
COPY --chown=builder:builder . .
RUN just -E .env-dist build-local

# FROM fedora:41 AS runtime
# RUN dnf install -y npm && dnf clean all
# WORKDIR /app
# COPY --from=build /app/target/release/my_app /app/
# CMD ["/app/my_app"]
