# High Assurance Self Balancing Robot Capstone

This is main repository for the PSU capstone.

* `japery` contains documents from the previous capstone team
* `otis-arduino` contains Arduino code with simple PID controller for the robot
* `Arduino` contains a demo library for embedding Rust code into arduino projects, as well as example sketch
* `rust-lib` is a demo Rust library

## Setting up the Environment
Kind2 isn't distributed on common managers and can be tricky to build. Has been successfully built on Ubuntu 18.04 during the last capstone. If it is necessary to build kind2 from source, ensure that Ocaml 4.04 is present. Also, depending on the source hash, some compiler flags will need to be modified; for the version packaged, the `-Werror` command was removed from czmq and libczmq. 

The verification tools have been packaged in Nix. There is a package description in the `kind2` folder. If nix isn't installed on the system, run
```
cd nix && sh bootstrap-nix.sh
```
Alternatively, if Nix is installed, 
```
cd nix
nix-shell # To get an interactive shell with kind2 in PATH
nix-build # To get a sym link to kind in ./result
```
can be run. 

NOTE: *If using WSL in Windows 10 prior to the creators update, the Nix package will fail to install properly.* This can be fixed by following [these instructions](https://dev.to/notriddle/installing-nix-under-wsl-2eim).

## Using Rust in Arduino projects
1. `cd rust-lib/ && ./build.sh && cd ..`
2. `cp rust-lib/libFoo.a Arduino/libraries/Foo/src/cortex-m0plus/.`
3. Open `Arduino/sketch_example/sketch_example.ino` in Arduino IDE
4. Select board `Arduino MKR WiFi 1010` (in general it has to be a board with [architecture supported by Rust](https://forge.rust-lang.org/release/platform-support.html#tier-2))
5. In Arduino IDE select *File->Settings->Verbose Compile*
6. You end up with a compiled arduino binary. Now you can upload it to the board.
