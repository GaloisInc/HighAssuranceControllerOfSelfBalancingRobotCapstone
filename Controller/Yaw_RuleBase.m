% Generate an indexing matrix for the number of rules
NumberofInputs=2;
MFM = 1;
for i = 1:NumberofInputs-1
   MFM = MFM*length(Centers(i).C);
end

%% Tilt Input Centers

CentersYAW(1).C=[-0.5 -0.25 -0.125 0 0.125 0.25 0.5];
CentersYAW(2).C=[-0.5 -0.25 -0.125 0 0.125 0.25 0.5];

%% Output Rule Crisp Values - Equally Spaced
NB = -0.2; 
NM = -0.1;
NS = -0.06;
ZR = 0;
PS = -1*NS; 
PM = -1*NM;
PB = -1*NB;

%% Define the rule matrix for a PD controller 
%(Typical see - 
% https://www.researchgate.net/profile/Kuldip_Rattan/publication/3638612_Analysis_and_design_of_a_proportional_plus_derivative_fuzzy_logic_controller/links/54f0838f0cf24eb87940bcdf/Analysis-and-design-of-a-proportional-plus-derivative-fuzzy-logic-controller.pdf)
RulesYAW =[NB NB NB NB NM NS ZR;
        NB NB NB NM NS ZR PS;
        NB NB NM NS ZR PS PM;
        NB NM NS ZR PS PM PB;
        NM NS ZR PS PM PB PB;
        NS ZR PS PM PB PB PB;
        ZR PS PM PB PB PB PB];
   
