use crate::models::example::ExampleScalarComputationResult;
use wasm_bindgen::JsValue;
use worker::*;

pub async fn example_scalar_computation<D>(ctx: RouteContext<D>) -> Result<Response> {
    let id = ctx.param("id").unwrap();
    let d1 = ctx.env.d1("DB")?;
    let statement = d1.prepare("SELECT ?1 + ?1 AS result");
    let query = statement.bind(&[JsValue::from(id)])?;
    let result = query.first::<ExampleScalarComputationResult>(None).await?;
    match result {
        Some(i) => Response::from_json::<ExampleScalarComputationResult>(&i),
        None => Response::error("Not found", 404),
    }
}
