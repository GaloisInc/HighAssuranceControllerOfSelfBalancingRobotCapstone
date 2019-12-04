# High Assurance Self Balancing Robot Capstone

This is main repository for the PSU capstone.

* `japery` contains documents from the previous capstone team
* `otis-arduino` contains Arduino code with simple PID controller for the robot
* `Arduino` contains a demo library for embedding Rust code into arduino projects, as well as example sketch
* `rust-lib` is a demo Rust library

## Using Rust in Arduino projects
1. `cd rust-lib/ && ./build.sh && cd ..`
2. `cp rust-lib/libFoo.a Arduino/libraries/Foo/src/cortex-m0plus/.`
3. Open `Arduino/sketch_example/sketch_example.ino` in Arduino IDE
4. Select board `Arduino MKR WiFi 1010` (in general it has to be a board with [architecture supported by Rust](https://forge.rust-lang.org/release/platform-support.html#tier-2))
5. In Arduino IDE select *File->Settings->Verbose Compile*
6. You end up with a compiled arduino binary. Now you can upload it to the board.