# ------------------------------------------------------------------------------
# Cargo Build Stage
# ------------------------------------------------------------------------------
FROM rust:latest as cargo-build
RUN apt-get update
RUN apt-get install musl-tools libssl-dev -y 
#RUN rustup override set nightly
RUN rustup target add x86_64-unknown-linux-musl
WORKDIR /usr/src/myapp
COPY Cargo.toml Cargo.toml
RUN mkdir src/
RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs
RUN RUSTFLAGS=-Clinker=musl-gcc PKG_CONFIG_ALLOW_CROSS=1 cargo build --release --target=x86_64-unknown-linux-musl
RUN rm -f target/x86_64-unknown-linux-musl/release/deps/myapp*
COPY . .
RUN PKG_CONFIG_ALLOW_CROSS=1 cargo build --release --target=x86_64-unknown-linux-musl

# ------------------------------------------------------------------------------
# Final Stage
# ------------------------------------------------------------------------------
FROM alpine:3.15
ENV RUST_LOG=Info
RUN addgroup -g 1000 myapp
RUN adduser -D -s /bin/sh -u 1000 -G myapp myapp
WORKDIR /home/myapp/bin/
COPY --from=cargo-build /usr/src/myapp/target/x86_64-unknown-linux-musl/release/rust-rocket-example .
RUN chown myapp:myapp rust-rocket-example
USER myapp
CMD ["./rust-rocket-example"]
