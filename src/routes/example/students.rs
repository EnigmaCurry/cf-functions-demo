use crate::models::example::{ExampleScalarComputationResult, Student};
use wasm_bindgen::JsValue;
use worker::*;

pub async fn get_student<D>(ctx: RouteContext<D>) -> Result<Response> {
    let id = ctx.param("id").unwrap();
    let d1 = ctx.env.d1("DB")?;
    let statement = d1.prepare("SELECT student_id, first_name, last_name, date_of_birth, major FROM Students WHERE student_id = ?1");
    let query = statement.bind(&[JsValue::from(id)])?;
    let result = query.first::<Student>(None).await?;
    match result {
        Some(i) => Response::from_json::<Student>(&i),
        None => Response::error("Student not found", 404),
    }
}
