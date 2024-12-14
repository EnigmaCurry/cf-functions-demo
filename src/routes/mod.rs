use axum::{routing::get, Router};

pub mod root;

pub fn router() -> Router {
    Router::new().route("/", get(root::root))
}
