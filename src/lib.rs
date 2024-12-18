use worker::*;
mod models;
mod routes;
use routes::example::{db_scalar_computation::example_scalar_computation, students::get_student};

#[event(fetch, respond_with_errors)]
pub async fn main(request: Request, env: Env, _ctx: Context) -> Result<Response> {
    Router::new()
        .get_async("/example/scalar_computation/:number", |_, ctx| {
            example_scalar_computation(ctx)
        })
        .get_async("/example/student/:id", |_, ctx| get_student(ctx))
        .run(request, env)
        .await
}
