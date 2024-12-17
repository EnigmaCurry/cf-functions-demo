use askama::Template;

#[derive(Template, Debug)]
#[template(path = "wrangler.toml.jinja")]
pub struct WranglerConfig {
    pub worker_name: String,
    pub compatibility_date: String,
    pub deployment: String,
    pub worker_domain: String,
    pub use_database: bool,
    pub worker_database_name: Option<String>,
    pub worker_database_id: Option<String>,
}
