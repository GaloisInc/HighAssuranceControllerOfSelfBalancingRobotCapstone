%{
Ignacio Mejia-Rodriguez 
Portland State University
Capstone Project: Spring Term

% Fuzzy Control MATLAB implementation of yaw controller in
"Interval Type-2 Fuzzy Logic Modeling & Control of a mobile TWIP", by Jian
Huang.

Description: This script creates a fuzzy inference system that can be used
in a Simulink block diagram for analysis. The inputs of the fuzzy logic
control block are:

-- error
-- change of error

The output is:

-- Control signal

The Simulink Control system is essentially a fuzzy PD controller.

Referances:


-- "IMPLEMENTATION OF MAMDAMI FUZZY CONTROL ON A MULTI-DOF TWO-WHEEL 
    INVERTED PENDULUM ROBOT" by Yubai Liu & Xueshan Gao

-- "Intelligent Control Design & MATLAB Simulation" by Jinkun Liu

Note: Run this script after "Fuzzy_Balance_Controller_Mamdani.m"
%}


close all;

%% Create Fuzzy Inference System (i.e fis)

a_y=newfis('Yaw');                      % Mamdani-style FIS structure

%==========================================================================
%% Fuzzify input (error (e)) and output (u)

% membership functions to fuzzify e
s1_y = 0.5;
a_y=addvar(a_y,'input','e',[-1*s1_y,1*s1_y]);             %Parameter e
a_y=addmf(a_y,'input',1,'NB','trapmf',[-1*s1_y, -1*s1_y, -1*s1_y, -0.5*s1_y]);    
a_y=addmf(a_y,'input',1,'NM','trimf',[-0.75*s1_y,-0.5*s1_y,-0.25*s1_y]);
a_y=addmf(a_y,'input',1,'NS','trimf',[-0.5*s1_y,-0.25*s1_y,0*s1_y]);
a_y=addmf(a_y,'input',1,'Z0','trimf',[-0.25*s1_y,0*s1_y,0.25*s1_y]);
a_y=addmf(a_y,'input',1,'PS','trimf',[0*s1_y,0.25*s1_y,0.5*s1_y]);
a_y=addmf(a_y,'input',1,'PM','trimf',[0.25*s1_y,0.5*s1_y,0.75*s1_y]);
a_y=addmf(a_y,'input',1,'PB','trapmf',[0.5*s1_y,1*s1_y,1*s1_y,1*s1_y]);  

%==========================================================================



% membership functions to fuzzify d/dt (e(t))
s2_y = 0.5;
a_y=addvar(a_y,'input','e_d',[-1*s2_y,1*s2_y]); %Parameter e_d
a_y=addmf(a_y,'input',2,'NBd','trapmf',[-1*s2_y, -1*s2_y, -1*s2_y, -0.5*s2_y]);    
a_y=addmf(a_y,'input',2,'NMd','trimf',[-0.75*s2_y,-0.5*s2_y,-0.25*s2_y]);
a_y=addmf(a_y,'input',2,'NSd','trimf',[-0.5*s2_y,-0.25*s2_y,0*s2_y]);
a_y=addmf(a_y,'input',2,'Z0d','trimf',[-0.25*s2_y,0*s2_y,0.25*s2_y]);
a_y=addmf(a_y,'input',2,'PSd','trimf',[0*s2_y,0.25*s2_y,0.5*s2_y]);
a_y=addmf(a_y,'input',2,'PMd','trimf',[0.25*s2_y,0.5*s2_y,0.75*s2_y]);
a_y=addmf(a_y,'input',2,'PBd','trapmf',[0.5*s2_y,1*s2_y,1*s2_y,1*s2_y]);

%==========================================================================



% membership functions to fuzzify u
s3_y = 0.2;
a_y=addvar(a_y,'output','u',[-1*s3_y,1*s3_y]); %Parameter u
a_y=addmf(a_y,'output',1,'NBu','trapmf',[-1*s3_y,-1*s3_y,-1*s3_y,-0.4*s3_y]);    
a_y=addmf(a_y,'output',1,'NMu','trimf',[-0.8*s3_y,-0.5*s3_y,-0.2*s3_y]);
a_y=addmf(a_y,'output',1,'NSu','trimf',[-0.6*s3_y,-0.3*s3_y,0.1*s3_y]);
a_y=addmf(a_y,'output',1,'Z0u','trimf',[-0.35*s3_y,0,0.35*s3_y]);
a_y=addmf(a_y,'output',1,'PSu','trimf',[-0.1*s3_y,0.25*s3_y,0.6*s3_y]);
a_y=addmf(a_y,'output',1,'PMu','trimf',[0.2*s3_y,0.5*s3_y,0.8*s3_y]);
a_y=addmf(a_y,'output',1,'PBu','trapmf',[0.4*s3_y,1*s3_y,1*s3_y,1*s3_y]);

%==========================================================================
%% Create Rule list

% rulelist given intuition of our system 

rulelist_y=[1 1 1 1 1;   
          2 1 1 1 1;  
          3 1 1 1 1;  
          4 1 1 1 1;   
          5 1 2 1 1;  
          6 1 3 1 1;  
          7 1 4 1 1;
          
          1 2 1 1 1;
          2 2 1 1 1;   
          3 2 1 1 1;   
          4 2 2 1 1;
          5 2 3 1 1;   
          6 2 4 1 1;   
          7 2 5 1 1;   
          
          1 3 1 1 1;    
          2 3 1 1 1;    
          3 3 2 1 1;  
          4 3 3 1 1;
          5 3 4 1 1;
          6 3 5 1 1;  
          7 3 6 1 1;  
          
          1 4 1 1 1;  
          2 4 2 1 1;
          3 4 3 1 1;
          4 4 4 1 1;
          5 4 5 1 1;
          6 4 6 1 1;
          7 4 7 1 1;  
          
          1 5 2 1 1;  
          2 5 3 1 1;  
          3 5 4 1 1;  
          4 5 5 1 1;
          5 5 6 1 1;  
          6 5 7 1 1;  
          7 5 7 1 1;  
          
          1 6 3 1 1;  
          2 6 4 1 1;
          3 6 5 1 1;  
          4 6 6 1 1;  
          5 6 7 1 1;  
          6 6 7 1 1;  
          7 6 7 1 1;
          
          1 7 4 1 1;
          2 7 5 1 1;  
          3 7 6 1 1;  
          4 7 7 1 1;  
          5 7 7 1 1;
          6 7 7 1 1;
          7 7 7 1 1];

a_y=addrule(a_y,rulelist_y);

%==========================================================================
%% Defuzzify using the centroid method

a1_y=setfis(a_y,'DefuzzMethod','centroid');  % Defuzzy

%==========================================================================
%% Save to fuzzy file "Bal.fis"
writefis(a1_y,'Yaw'); 

%==========================================================================
%% Read "Bal.fis" and plot the input and output membership functions

a2_y=readfis('Yaw');
figure(1);
plotfis(a2_y);            % Plot fuzzy control system block diagram
figure(2);
plotmf(a_y,'input',1);    % Plot input membership function
figure(3)
plotmf(a_y,'input',2);    % Plot input membership function
figure(4);
plotmf(a_y,'output',1);   % Plot output membership function

%==========================================================================
%% Set up Dynamic simulation (i.e relation between input and output)

flag_y=1;                 % Set Flag = 1 if you want to see the dynamic 
                        % simulation(i.e relation between inputs and output 
                        % of the controller)

if flag_y==1
    showrule(a_y);        % Show fuzzy rule base
    ruleview('Yaw');    % Dynamic Simulation
end

%==========================================================================