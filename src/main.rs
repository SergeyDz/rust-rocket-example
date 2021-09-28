#[macro_use] extern crate rocket;

rocket_healthz::healthz!();
use gethostname::gethostname;
use local_ip_address::local_ip;

#[get("/")]
fn index() -> &'static str {
    let my_local_ip = local_ip().unwrap();
    let my_host_name =gethostname();
    println!("Hostname: {:?}, IP: {:?}", my_host_name, my_local_ip);
    "Hello, world!"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index, healthz])
}