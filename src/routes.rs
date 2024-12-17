use axum::{routing::get, Router};

pub mod customers;
pub mod root;

pub fn router() -> Router {
    Router::new()
        .route("/", get(root::root))
        .route("/customers", get(customers::get_customers))
}
