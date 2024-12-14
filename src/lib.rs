use tower_service::Service;
use worker::*;

mod models;
mod routes;

#[event(fetch)]
async fn fetch(
    req: HttpRequest,
    _env: Env,
    _ctx: Context,
) -> Result<axum::http::Response<axum::body::Body>> {
    console_error_panic_hook::set_once();
    Ok(routes::router().call(req).await?)
}
