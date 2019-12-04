#![no_std]
/**
 * It is important to:
 * 1. use #![no_std] because we don't have standard library on the target (it has to be the first line on the file)
 * 2. define functions as `extern "C"`
 * 3. use #[no_mangle]
 * 
 * You can use 
 */

extern crate panic_halt; // you can put a breakpoint on `rust_begin_unwind` to catch panics

#[no_mangle]
pub extern "C" fn foo() -> i32 {
	66
}

