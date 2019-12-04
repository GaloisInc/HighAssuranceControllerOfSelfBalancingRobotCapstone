#!/bin/bash
cargo build --release --target=thumbv7m-none-eabi --verbose
cp target/thumbv7m-none-eabi/release/librust_lib.a libFoo.a
