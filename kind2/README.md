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

`/Artem1199/Kind2` is branch of kind2 with a modified version of `lustreToRust.ml` that is responsible for the Rust code generation from lustre.  Nothing else in the branch has been modified, so lustreToRust.ml can be placed into any copy of Kind2 and compile Kind2 with a code generator.  Kind2 requires multiple dependencies, follow the kind2 [readme](https://github.com/kind2-mc/kind2).

I've found the easiest way to test this build and use this embedded version of kind2 is to run `ocamlbuild -j 0 -pkg yojson -cflags -w,@P@U@F kind2.native` in the Artem1199/kind2/src file after running ./autogen.sh as per the kind2 readme.  This will generate `kind2.native` in `_build`.  A copy of this build can be found in the above folder `lus/kind2.native`.  Run `kind2.native pid2.lus --compile=true` to generate a folder with Rust code.

For reference I've generated a file difference between the original lustreToRust.ml and the 'embedded' version.  All of the modifications I made where done by commenting out sections of the string that is used in Ocaml to generate the Rust code.  None of the Ocaml code has been modified, and very little of the core state machine is modified.

The most significant change is the use of the mutable references for structs.  Previously the generated Rust code would take ownership of the structs, but now C++/Arduino is responsible for passing a pointer to the memory, so the Rust code no longer creates any objects like before.

`pid2.lus` is a working pid controller that I have already tested on the MKR1010.
