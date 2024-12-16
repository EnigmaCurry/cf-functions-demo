use crate::models::example::Example;
use axum::response::Json;

pub async fn root() -> Json<Example> {
    let example = Example {
        hello: String::from("Hello Axum!"),
    };

    Json(example)
}
