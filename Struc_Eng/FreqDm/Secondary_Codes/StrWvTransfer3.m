function [S_max1] = StrWvTransfer3(theta_w,T,path1,PartName,TorB, unit, scale)

%% Computes transfer function for principle stress output from ANSYS model
%Use this script in conjunction with SpectralFatigue2.m
%Last edited by Bingbin Yu, 1/14/2016 
%Based on transfer.m, last edited by Peter Fobel, 5/4/2014 

%Inputs - 
%       - theta_w (degree) - defines wave direction from wave scattered 
%         diagram, must be multiples of 30 (0,30,60...330)
%       - Period (T)(seconds) - can be any number greater than 0 (typically 
%         between 0s and 40s)
%       - path - general path name for results
%       - PartName - Name of member to be read stress results
%       - TorB - top or bottome surface
%       - Structure of the input file: column 1 to 10: ElemNo, ElemCentroid
%       X(mm), ElemCentroid Y, ElemCentroid Z, Sx, Sy, Sz, Sxy, Syz, Sxz
%       (MPa)
%       - unit, 'Pa' or 'MPa'
%       - scale, real load/actually applied load for simulation

%Output - "Smax1" - Stress/wave amplitude absolute value of transfer 
%         function result for a particular wave period, heading, and 
%         orientation around column. Units are MPa/m 
%%
%Path for stress results
%path1 = [path Iteration '\'];

% %Calcualte wave heading relative to the platform, 0 to 360 degree
% theta_h = theta0 - theta_w; 
% if theta_h < 0
%     theta_h1 = theta_h + 360;
% else
%     theta_h1 = theta_h;
% end
% 
% %Round the wave heading to nearest multiplier of 30 degree
% theta_h2 = mod (round (theta_h1/30) * 30,360);

%Now the theta_w is relative to platform (BYu, Aug2018)
heading = num2str(theta_w);
period = num2str(round(T));

path2 = [path1 'Run' heading '\'];

S_real_file = [path2 'ElemStr_' PartName '_Run' heading 'T' period '_real_' TorB '.csv'];
file_real = importdata(S_real_file);
data_real = file_real.data; %

S_imag_file = [path2 'ElemStr_' PartName '_Run' heading 'T' period '_imag_' TorB '.csv'];
file_imag = importdata(S_imag_file);
data_imag = file_imag.data;

file_real = [];
file_imag = [];

if strcmp(unit,'Pa')
%     Norm_real = data_real(:,5:10)/1e6; %Convert to MPa
%     Norm_imag = data_imag(:,5:10)/1e6;
    NormStr = scale*(data_real(:,5:10)/1e6 + data_imag(:,5:10)/1e6*i);
else
%     Norm_real = data_real(:,5:10);
%     Norm_imag = data_imag(:,5:10);
    NormStr = scale*(data_real(:,5:10) + data_imag(:,5:10)*i);
end

ElemN = size(data_real, 1); %total number of elements

% NormStr = Norm_real + Norm_imag*i;

% for n = 1:ElemN
%     S_pr(n,:) = CalPrcpStr_6dof(NormStr(n,:)); %Principal stress(MPa), S1, S2 or S3
% end
S_pr1 = CalPrcpStr_6dof_Mtrx(NormStr);
S = abs(S_pr1);
S_max1 = max(S,[],2);

end