use axum::{routing::get, Router};
use std::sync::Arc;
use worker::{Context, Env};

pub mod example;
pub mod root;
