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
