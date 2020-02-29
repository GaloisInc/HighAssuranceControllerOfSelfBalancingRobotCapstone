%{
Ignacio Mejia-Rodriguez 
Portland State University
Capstone Project: Winter Term

%Fuzzy Control MATLAB implementation of balance controller in
"Implementation Of Mamdani Fuzzy Control on a Multi_DOF TWIP Robot"

Description: This script creates a fuzzy inference system that can be used
in a Simulink block diagram for analysis. The inputs of the fuzzy logic
control block are:

-- error
-- change of error

The output is:

-- Control signal

The system is essentially a fuzzy PD controller.

Referances:


-- "IMPLEMENTATION OF MAMDAMI FUZZY CONTROL ON A MULTI-DOF TWO-WHEEL 
    INVERTED PENDULUM ROBOT" by Yubai Liu & Xueshan Gao

-- "Intelligent Control Design & MATLAB Simulation" by Jinkun Liu

%}

clear all;
close all;

%% Create Fuzzy Inference System (i.e fis)

a=newfis('Balance');                      % Mamdani-style FIS structure

%==========================================================================
%% Fuzzify input (error (e)) and output (u)

% membership functions to fuzzify e
a=addvar(a,'input','e',[-6,6]);             %Parameter e
a=addmf(a,'input',1,'NB','trapmf',[-6 -6 -5 -2]);    
a=addmf(a,'input',1,'NM','trimf',[-5,-2,-0.5]);
a=addmf(a,'input',1,'NS','trimf',[-1.75,-0.75,0]);
a=addmf(a,'input',1,'Z0','trimf',[-0.5,0,0.5]);
a=addmf(a,'input',1,'PS','trimf',[0,0.75,1.75]);
a=addmf(a,'input',1,'PM','trimf',[0.5,2,5]);
a=addmf(a,'input',1,'PB','trapmf',[2,5,6,6]);  

%==========================================================================

a=addvar(a,'input','e_d',[-2,2]); %Parameter e_d

% membership functions to fuzzify d/dt (e(t))

a=addmf(a,'input',2,'NBd','trapmf',[-2 -2 -1.5 -1]);    
a=addmf(a,'input',2,'NMd','trimf',[-1.5,-1,-0.5]);
a=addmf(a,'input',2,'NSd','trimf',[-1,-0.5,0]);
a=addmf(a,'input',2,'Z0d','trimf',[-0.5,0,0.5]);
a=addmf(a,'input',2,'PSd','trimf',[0,0.5,1]);
a=addmf(a,'input',2,'PMd','trimf',[0.5,1,1.5]);
a=addmf(a,'input',2,'PBd','trapmf',[1,1.5,2,2]);

%==========================================================================

a=addvar(a,'output','u',[-10,10]); %Parameter u

% membership functions to fuzzify u

a=addmf(a,'output',1,'NBu','trimf',[-9.5,-8.5,-8]);    
a=addmf(a,'output',1,'NMu','trimf',[-5.5,-5,-4.5]);
a=addmf(a,'output',1,'NSu','trimf',[-2,-1.5,-1]);
a=addmf(a,'output',1,'Z0u','trimf',[-0.5,0,0.5]);
a=addmf(a,'output',1,'PSu','trimf',[1,1.5,2]);
a=addmf(a,'output',1,'PMu','trimf',[4.5,5,5.5]);
a=addmf(a,'output',1,'PBu','trimf',[8,8.5,9.5]);

%==========================================================================
%% Create Rule list

% rulelist given intuition of our system 

rulelist=[1 1 1 1 1;   
          2 1 1 1 1;  
          3 1 1 1 1;  
          4 1 2 1 1;   
          5 1 4 1 1;  
          6 1 4 1 1;
          7 1 4 1 1;
          
          1 2 1 1 1;
          2 2 2 1 1;
          3 2 2 1 1;
          4 2 2 1 1;
          5 2 4 1 1;
          6 2 4 1 1;
          7 2 4 1 1;
          
          1 3 1 1 1;
          2 3 2 1 1;
          3 3 3 1 1;
          4 3 3 1 1;
          5 3 4 1 1;
          6 3 4 1 1;
          7 3 4 1 1;
          
          1 4 2 1 1;
          2 4 2 1 1;
          3 4 3 1 1;
          4 4 4 1 1;
          5 4 5 1 1;
          6 4 6 1 1;
          7 4 6 1 1;
          
          1 5 4 1 1;
          2 5 4 1 1;
          3 5 4 1 1;
          4 5 5 1 1;
          5 5 5 1 1;
          6 5 6 1 1;
          7 5 7 1 1;
          
          1 6 4 1 1;
          2 6 4 1 1;
          3 6 4 1 1;
          4 6 6 1 1;
          5 6 6 1 1;
          6 6 6 1 1;
          7 6 7 1 1;
          
          1 7 4 1 1;
          2 7 4 1 1;
          3 7 4 1 1;
          4 7 6 1 1;
          5 7 7 1 1;
          6 7 7 1 1;
          7 7 7 1 1];

a=addrule(a,rulelist);

%==========================================================================
%% Defuzzify using the centroid method

a1=setfis(a,'DefuzzMethod','centroid');  % Defuzzy

%==========================================================================
%% Save to fuzzy file "Bal.fis"
writefis(a1,'Bal'); 

%==========================================================================
%% Read "Bal.fis" and plot the input and output membership functions

a2=readfis('Bal');
figure(1);
plotfis(a2);            % Plot fuzzy control system block diagram
figure(2);
plotmf(a,'input',1);    % Plot input membership function
figure(3)
plotmf(a,'input',2);    % Plot input membership function
figure(4);
plotmf(a,'output',1);   % Plot output membership function

%==========================================================================
%% Set up Dynamic simulation (i.e relation between input and output)

flag=1;                 % Set Flag = 1 if you want to see the dynamic 
                        % simulation(i.e relation between inputs and output 
                        % of the controller)

if flag==1
    showrule(a);        % Show fuzzy rule base
    ruleview('Bal');    % Dynamic Simulation
end

%==========================================================================
