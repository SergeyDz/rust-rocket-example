#[macro_use] extern crate rocket;
rocket_healthz::healthz!();

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[launch]
fn rocket() -> _ {
    rocket::build().mount("/", routes![index, healthz])
}