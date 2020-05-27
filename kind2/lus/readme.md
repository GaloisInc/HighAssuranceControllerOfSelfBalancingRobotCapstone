## Controllers
There are two working controllers in this folder: `pid2.lus` and `fuzzy.lus`.  Running `./kind2.native fuzzy.lus --compile true` will "verify the files" and create embedded friendly Rust code.  There is no verification step or model in the files, so nothing will be verified, but the code will be generated.

### pid2.lus
Basic PID controller with multiple inputs based on [br3ttb PID](https://github.com/br3ttb/Arduino-PID-Library/).

### fuzzy.lus
Fuzzy logic controller heavily based on [Matt's Matlab Code](https://github.com/GaloisInc/HighAssuranceControllerOfSelfBalancingRobotCapstone/tree/master/Controller).  Matt's controller heavily uses recursion and arrays.  Lustre doesn't like recursion, and **arrays do not work with the Rust generated**.  This means all the matrices were expanded out to `if/else` statements.

This controller balances the robot, but poorly.  Tunning the controller is much more difficult since there are more paramaters.  After having issues setpoint error, an integral was added to the controller that helped remove the setpoint error.
