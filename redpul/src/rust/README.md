# TODO: Write a title

[![crates.io](https://img.shields.io/crates/v/{{CRATE}}.svg)](https://crates.io/crates/{{CRATE}})
[![docs.rs](https://docs.rs/{{CRATE}}/badge.svg)](https://docs.rs/{{CRATE}}/)
![CI](https://github.com/{{GH-USER}}/{{CRATE}}/workflows/CI/badge.svg)

TODO: Briefly describe the crate here (eg. "This crate provides ...").

Please refer to the [changelog](CHANGELOG.md) to see what changed in the last
releases.

## Usage

Add an entry to your `Cargo.toml`:

```toml
[dependencies]
{{CRATE}} = "0.0.0"
```

Check the [API Documentation](https://docs.rs/{{CRATE}}/) for how to use the
crate's functionality.

## Rust version support

This crate supports at least the 3 latest stable Rust releases. Bumping the
minimum supported Rust version (MSRV) is not considered a breaking change as
long as these 3 versions are still supported.


``` 

//
/// Return string `"Hello world!"` to R.
/// @export
#[extendr]
pub fn hello_world() -> &'static str {
    "Hello world!"
}

/// Addition of Integers
/// @export
#[extendr]
pub fn add_float(x: u32, y: u32) -> u32 {
    x + y
}

/// Return a vector
/// @export
#[extendr]
fn return_vec(x: i32, y: i32) -> Robj {
    let vec_val = r!([x, y]);
    vec_val
}

/// Return robj
/// @export
#[extendr]
fn return_obj(x: Robj) -> Robj {
    x
}

/// my_sum
/// @export
#[extendr]
pub fn my_sum(v: Robj) -> Robj {
    rprintln!("{:?}", v);
    v
}

/// pass_string
/// @export
#[extendr]
pub fn pass_string(text: &str) -> Robj {
    rprintln!("{:?}", text);
    text.into_robj()
}
```