(* Artem K *)



(*Compute function, checks if SampleTime limit reached and calls PID calculate *)

node Compute(Input:real; Now:real; Setpoint:real; Kp:real; Ki:real; Kd:real; SampleTime:real;) returns(Output:real;);

let

            Output =  if (Now - (0.0 -> pre Now) >= SampleTime) then

                    Compute_calc(Input, Now, Setpoint, Kp, Ki, Kd, SampleTime)

            else

                    0.0 -> pre Output;
tel;


(*PID calculation function that does the actually math*)

node Compute_calc(Input:real; Now:real; Setpoint:real; Kp:real; Ki:real; Kd:real; SampleTime:real;) returns(Output:real;);

var
    dInput:real;
    error:real;
    outputSum:real;
    Kitemp:real;

    
    let 
	error = Setpoint - Input;
	Kitemp = limit_integral(error, Ki);
        dInput = Input - (0.0 -> pre Input);
        
        outputSum = limit (0.0 -> pre outputSum + Ki * error * SampleTime/1000.0);
        
        Output = limit (Kp * error - Kd * dInput * 1000.0/SampleTime + outputSum);
        
    tel;
    
    
(* function to limit values between -1k to 1k for Arduino PWM *)

function limit (x:real;) returns (y:real;);

let

   y = if (x > 230.0) then 230.0 else if (x < -230.0) then -230.0 else x;

tel;

function limit_integral (error:real; Ki:real) returns (y:real;);

let
	y = if (error > .05) then 0.0 else if (error < -.05) then 0.0 else Ki;
tel;


(*
Input between .7680 and -.7

Now: 

double originalSetpoint = -0.0968;

double Kpt = 800;
double Kit = 24000;
double Kdt = 20;

SampleTime = 5;
*)
