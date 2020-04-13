
% *---------------------------------------------------------------------- *
% Copyright Kuldip S Rattan and Matthew Clark
% *---------------------------------------------------------------------- *
% *---------------------------------------------------------------------- *
% KMFUZZIFY - Inference Logic
% Based on patent pending https://patents.google.com/patent/US20170278008A1/en
% All Rights Reserved - Free to use but do not modify without permission

% This m-file computes the membership values of the fuzzy sets (defined 
% over a normalized universe of discourse between -1 and 1) for a given
% input . centers is a vector containing the center points or peak points   
% of the triagular fuzzy sets whose membership values are being determined 
% for the given input x,  Fuzzy partitioing is assumed.  y is the output
% vector. It is also assumed that the membership values for inputs greater
% than and less than -1 is 1 is [0 1] or [1 0], respectively..  
% *---------------------------------------------------------------------- *
%
function [y1,y2,j]=KMFUZZIFY(x,i,d,centers)
if (i==1) && (x < centers(1))
   y1 = 1;
   y2 = 0;
   j = 1;
elseif (i==d) && (x > centers(d))
   y1 = 0;
   y2 = 1;
   j = i-1;
elseif (x>=centers(i)) && (x <= centers(i+1))
   y1=(centers(i+1)-x)/(centers(i+1)-centers(i));
   y2=(x-centers(i))/(centers(i+1)-centers(i));
   j=i;
else
   [y1, y2, j]=KMFUZZIFY(x,i+1,d,centers);
end
