 function g = KMLOGIC(n,input,s,R,MFM)
%% 
%  Find the two adjacent membership fvalues [y1 y2] 
% and the index value (j) of the first active membership function   
[y1, y2, j]=KMFUZZIFY(input(n),1,length(s(n).C),s(n).C);
%%
% Find the grouping of rules needed for the next input of n inputs
  sindex1 = ((j-1)*MFM)+1;
  sindex2 = (sindex1-1)+MFM;
  eindex = sindex2+MFM;
  R1 = R(sindex1:sindex2);
  R2 = R(sindex2+1:eindex);
%%  
  if n > 1
    MFM2=MFM/(length(s(n-1).C));
    g=[y1 y2]*[KMLOGIC(n-1,input,s,R1,MFM2);KMLOGIC(n-1,input,s,R2,MFM2)];
  else
    g = [y1 y2]*[R1;R2];
  end

