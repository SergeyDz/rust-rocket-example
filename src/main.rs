#[macro_use] extern crate rocket;
extern crate pnet;

rocket_healthz::healthz!();
use pnet::datalink;

#[get("/")]
fn index() -> &'static str {
    for iface in datalink::interfaces() {
        println!("{:?}", iface.ips);
    }
    
    "Hello, world!"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index, healthz])
}