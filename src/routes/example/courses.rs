use crate::models::example::{ExampleScalarComputationResult, Student};
use serde::{Deserialize, Serialize};
use wasm_bindgen::JsValue;
use worker::*;

#[derive(Deserialize, Serialize, Debug)]
pub struct CourseRecord {
    pub course_name: String,
    pub professor_name: String,
    pub credits: i32,
}

pub async fn get_course<D>(ctx: RouteContext<D>) -> Result<Response> {
    let id = ctx.param("id").unwrap();
    let d1 = ctx.env.d1("DB")?;
    let statement = d1.prepare("SELECT c.course_name, p.first_name || ' ' || p.last_name AS professor_name, c.credits FROM courses c JOIN professors p on c.professor_id = p.professor_id WHERE c.course_id = ?1");
    let query = statement.bind(&[JsValue::from(id)])?;
    let result = query.first::<CourseRecord>(None).await?;
    match result {
        Some(i) => Response::from_json::<CourseRecord>(&i),
        None => Response::error("Course not found", 404),
    }
}

pub async fn get_all_courses<D>(ctx: RouteContext<D>) -> Result<Response> {
    let d1 = ctx.env.d1("DB")?;
    let statement = d1.prepare(
        "SELECT c.course_id, c.course_name, p.professor_id, 
                p.first_name || ' ' || p.last_name AS professor_name, 
                c.credits 
         FROM courses c 
         JOIN professors p ON c.professor_id = p.professor_id",
    );
    let query = statement.bind(&[])?; // No parameters needed for this query
    let result = query.all().await?;

    // Deserialize rows into a Vec<CourseRecord>
    let courses: Vec<CourseRecord> = result.results()?;

    if courses.is_empty() {
        Response::error("No courses found", 404)
    } else {
        Response::from_json(&courses)
    }
}
