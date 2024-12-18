use worker::*;
mod models;
mod routes;
use routes::example::{
    courses::{get_all_courses, get_course},
    db_scalar_computation::example_scalar_computation,
    students::get_student,
};

#[event(fetch, respond_with_errors)]
pub async fn main(request: Request, env: Env, _ctx: Context) -> Result<Response> {
    Router::new()
        .get_async("/example/scalar_computation/:number", |_, ctx| {
            example_scalar_computation(ctx)
        })
        .get_async("/example/student/:id", |_, ctx| get_student(ctx))
        .get_async("/example/course/:id", |_, ctx| get_course(ctx))
        .get_async("/example/courses", |_, ctx| get_all_courses(ctx))
        .run(request, env)
        .await
}
