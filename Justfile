set export

current_dir := `pwd`
RUST_LOG := "info"
RUST_BACKTRACE := "1"

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
    
# Run dev server
dev: deps
    cargo watch -- npx wrangler dev --live-reload false
