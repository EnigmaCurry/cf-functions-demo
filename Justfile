set export

current_dir := `pwd`
RUST_LOG := "info"
RUST_BACKTRACE := "1"

# print help for Just targets
help:
    @just -l

# Install dependencies
deps:
    @echo
    @echo "Installing dependencies:"
    @echo
    cargo install cargo-watch
    
# Run dev server
dev:
    cargo watch -- npx wrangler dev --live-reload false
