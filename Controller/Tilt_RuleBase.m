% Generate an indexing matrix for the number of rules
NumberofInputs=2;
MFM = 1;
for i = 1:NumberofInputs-1
   MFM = MFM*length(Centers(i).C);
end

%% Tilt Input Centers
CentersTILT(1).C=[-1 -0.95 -0.9 0 0.9 0.95 1];
CentersTILT(2).C=[-1 -0.3 -0.1 0 0.1 0.3 1];

% CentersTILT(1).C=[-0.9 -0.3 -0.1125 0 0.1125 0.3 0.9];
% CentersTILT(2).C=[-0.8 -0.4 -0.2 0 0.2 0.4 0.8];

%% Output Rule Crisp Values - Equally Spaced
NB = -1; 
NM = -.7;
NS = -0.3;
ZR = 0;
PS = -1*NS; 
PM = -1*NM;
PB = -1*NB;

% %% Output Rule Crisp Values - Equally Spaced
% NB = -1.7; 
% NM = -1;
% NS = -0.3;
% ZR = 0;
% PS = -1*NS; 
% PM = -1*NM;
% PB = -1*NB;

%% Define the rule matrix for a PD controller 
%(Typical see - 
% https://www.researchgate.net/profile/Kuldip_Rattan/publication/3638612_Analysis_and_design_of_a_proportional_plus_derivative_fuzzy_logic_controller/links/54f0838f0cf24eb87940bcdf/Analysis-and-design-of-a-proportional-plus-derivative-fuzzy-logic-controller.pdf)
RulesTILT =[NB NB NB NB NM NS ZR;
        NB NB NB NM NS ZR PS;
        NB NB NM NS ZR PS PM;
        NB NM NS ZR PS PM PB;
        NM NS ZR PS PM PB PB;
        NS ZR PS PM PB PB PB;
        ZR PS PM PB PB PB PB];
   
