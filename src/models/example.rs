use serde::{Deserialize, Serialize};

#[derive(Deserialize, Serialize, Debug)]
pub struct Example {
    pub hello: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct ExampleScalarComputationResult {
    pub result: f64,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct Student {
    pub student_id: i32,
    pub first_name: String,
    pub last_name: String,
    pub date_of_birth: String, // Consider using `chrono::NaiveDate` for date handling
    pub major: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct Professor {
    pub professor_id: i32,
    pub first_name: String,
    pub last_name: String,
    pub department: String,
}

#[derive(Deserialize, Serialize, Debug)]
pub struct Course {
    pub course_id: i32,
    pub course_name: String,
    pub credits: i32,
    pub professor_id: i32, // Foreign key reference
}

#[derive(Deserialize, Serialize, Debug)]
pub struct Enrollment {
    pub enrollment_id: i32,
    pub student_id: i32,         // Foreign key reference
    pub course_id: i32,          // Foreign key reference
    pub enrollment_date: String, // Consider using `chrono::NaiveDate` for date handling
    pub grade: Option<String>,   // Grade might be nullable
}
