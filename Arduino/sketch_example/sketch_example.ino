/**
 * This is an example of how to link Arduino project against static Rust library
 * Use Arduino MKR WIFI 1010
 * which has SAMD21 Cortex-M0+ 32bit Low Power ARM MCU
 * see https://store.arduino.cc/usa/mkr-wifi-1010 for details
 */
#include <Foo.h>


// the setup function runs once when you press reset or power the board
void setup() {
  int foo_value = foo();
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(1000);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);                       // wait for a second
}
