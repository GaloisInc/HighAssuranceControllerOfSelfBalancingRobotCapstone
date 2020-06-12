# Kind 2 Rust code generation

* Official [Documentation](https://kind.cs.uiowa.edu/kind2_user_doc/)
* After you pull the docker image, do `./run.sh`
* You will see something like:
	```
	Analyzing Plant
	  with First top: "Plant" (no subsystems)

	<Success> Property SS is valid by inductive step after 0.145s.

	--------------------------------------------------------------------------------
	Summary of properties:
	--------------------------------------------------------------------------------
	SS: valid (at 12)
	================================================================================

	--------------------------------------------------------------------------------
	Post-analysis: rust generation

	<Note> Compilation to Rust is still a rather experimental feature:
	       in particular, arrays are not supported.

	  Compiling node "Plant" to Rust in `/lus/simple.lus.out/Plant/implem`.

	  Done compiling.
	```
* You can inspect the generated code in `lus/lus.simple.out`

## Simple.lus
* `simple.lus` is a simple state space model, we assert certain limits on the input `u` 
* our steady state condition says `SS = (y<0.1 and cnt < 10) or (cnt >= 10);` says output `y` is less than 0.1 at least for 9 interations
* `  assert(u < 1.0);` places limits on the input `u`
* You can run it with `cargo run` and type your input `u_0`

## Kind2 Embedded Code generator

This folder has modified version the `lustreToRust.ml` called `lustreToRust.ml-embedded`, this file can simply be placed into the source files of Kind2. The file will need to be renamed back to `lustreToRust.ml` and the original version will have to be overwritten.  Kind2 requires multiple dependencies, follow the Kind2 [readme](https://github.com/kind2-mc/kind2).

I've found the easiest way to test this build and use this embedded version of kind2 is to run `ocamlbuild -j 0 -pkg yojson -cflags -w,@P@U@F kind2.native` in the `/kind2/src` file after running `./autogen.sh` as per the kind2 readme.  This will generate `kind2.native` in `_build`.

A copy of this build can be found in the above folder `lus/kind2.native`.  Run `kind2.native pid2.lus --compile=true` to generate a folder with Rust code.

### Kind2 LustreToRust Generated Modifications
For reference I've generated a file `lustreToRust_diff.txt` between the original `lustreToRust.ml` and the 'embedded' version in this folder.  All of the modifications I made where done by commenting out sections of the string that is used in Ocaml to generate the Rust code.  None of the Ocaml code has been modified, and very little of the core state machine is modified.  The original lustreToRust generator creates a cmd window program that accepts inputs into the cmd window, and spits out results.  It also confirms if your assertions are true or not.

**Here is a list of the general modifications I made:**
1. Commented out `clap_and_run() function`, there's no point to run this as a seperate program in embedded.
2. Commented out references to `std`
3. Commented out all there cmd window interfaces, i.e. `InputReader`
4. Commented out all `Result` types, Removed `OK()` returns, and Removed `Err`
5. Entirely replaced `read_init` (old read_init is still generated, but another function is used)
6. Entirely replaced `read_next` (ditto above)
    1. Critical change here, I modified the input to a mutable reference, this was I could keep things FFI compliant with C++.  I believe the original functionality had it return a new object to replace the old one instead of modifying the same object each time.
    2. This means that I do not return the next state anymore, instead I override the values in the current structure.  **This is an area where I can see potential functional errors.**  (See lines 241 - 244) So far though the controllers I have generated are working properly.
7. Commented out `run()`
8. Commented out `pub mod parse () function`, used for command window, not needed for functionality.
9. Commented `arity()`, again cmd window.

**Changes I did not make:**
1. I did not deal with assertions, this is potential because of my ignorance of Kind2, but I did not see how this could be useful in embedded Rust.  That means if your lustre code has assertions, the generated Rust code **will not** work properly.

### So you've generated a controller...
Usually I copy and past the code into a folder setup for generating Rust controller libraries i.e. [Artem1199/otis-arduino](https://github.com/Artem1199/otis-arduino/tree/master/otis_twipv2/Rust-Cortex-M-PID/pidControl/src).  I create a shim function to call `read_init` to initialize the controller.  Then create a 2nd shim function `read_next` to run the calculations.  That otis-arduino repo has a full explanation of the shim functions.  `lib.rs` holds the shim functions while each controller is seperated in it's own file.
