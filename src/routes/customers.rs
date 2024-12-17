use crate::models::example::Example;
use axum::response::Json;

pub async fn get_customers() -> Json<Example> {
    let example = Example {
        hello: String::from("Hello customer!"),
    };

    Json(example)
}
