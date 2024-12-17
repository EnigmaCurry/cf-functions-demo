mod config;

use askama::Template;
use clap::Parser;

/// Command line argument parser
#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    /// Worker name
    #[arg(long, env = "WORKER_NAME")]
    worker_name: String,

    /// Compatibility date
    #[arg(long, env = "WRANGLER_COMPATIBILITY_DATE")]
    compatibility_date: String,

    /// Deployment environment
    #[arg(long, env = "DEPLOYMENT")]
    deployment: String,

    /// Worker database name
    #[arg(long, env = "WORKER_DATABASE_NAME")]
    worker_database_name: Option<String>,

    /// Worker database ID
    #[arg(long, env = "WORKER_DATABASE_ID")]
    worker_database_id: Option<String>,

    /// Worker domain
    #[arg(long, env = "WORKER_DOMAIN", default_value = "workers.dev")]
    worker_domain: String,
}

fn main() {
    let args = Args::parse();

    //Figure out if the database was configured or not:
    let use_database = (args
        .worker_database_name
        .clone()
        .unwrap_or(String::from(""))
        .len()
        > 0)
        && (args
            .worker_database_id
            .clone()
            .unwrap_or(String::from(""))
            .len()
            > 0);

    let cfg = config::WranglerConfig {
        worker_name: args.worker_name,
        compatibility_date: args.compatibility_date,
        deployment: args.deployment,
        use_database,
        worker_database_name: args.worker_database_name,
        worker_database_id: args.worker_database_id,
        worker_domain: args.worker_domain,
    };

    match cfg.render() {
        Ok(output) => println!("{}", output),
        Err(e) => eprintln!("Failed to render config: {}", e),
    }
}
