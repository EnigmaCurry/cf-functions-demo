set export
set dotenv-load := true

current_dir := `pwd`
RUST_LOG := "info"
RUST_BACKTRACE := "1"
NPM_ROOT := "npm"

# print help for Just targets
help:
    @just -l

# Install dependencies
deps:
    @if ! command -v npm > /dev/null; then \
      echo "Error: npm is not installed. Please install npm and try again." >&2; \
      exit 1; \
    fi
    @if ! command -v cargo-watch > /dev/null; then \
      echo; \
      echo; \
      echo "Installing dependencies:"; \
      cargo install cargo-watch; \
    fi
    @if ! command -v wrangler > /dev/null; then \
      mkdir -p "${NPM_ROOT}"; \
      npm config set prefix "${NPM_ROOT}"; \
      npm install -g wrangler; \
    fi
    
# Run dev server
dev: deps
    cargo watch --why -i build -i target -- "${NPM_ROOT}/bin/wrangler" dev --live-reload false

