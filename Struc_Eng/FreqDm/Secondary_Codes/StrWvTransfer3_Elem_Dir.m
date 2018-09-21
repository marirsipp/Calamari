function [NormStr_amp,NormStr_phase] = StrWvTransfer3_Elem_Dir(theta0,theta_w,T,path,PartName, Iteration, TorB,ElemTest,unit,scale)

%% Computes transfer function for directional stress output from ANSYS model
%Last edited by Bingbin Yu, 1/14/2016 
%Based on transfer.m, last edited by Peter Fobel, 5/4/2014 

%Inputs - theta0 (degrees) - defines platform orientation, 0<= theta0 <360
%       - theta_w (degree) - defines wave direction from wave scattered 
%         diagram, must be multiples of 30 (0,30,60...330)
%       - Period (T)(seconds) - can be any number greater than 0 (typically 
%         between 0s and 40s)
%       - path - general path name for results
%       - PartName - Name of member to be read stress results
%       - Iteration - Name of the iteration of the current structural
%         configration
%       - TorB - top or bottome surface
%       - Structure of the input file: column 1 to 10: ElemNo, ElemCentroid
%       X(mm), ElemCentroid Y, ElemCentroid Z, Sx, Sy, Sz, Sxy, Syz, Sxz
%       (MPa)
%       - unit, 'Pa' or 'MPa'
%       - scale, real load/actually applied load for simulation

%Output - "Smax1" - Stress/Hs absolute value of transfer function result for 
%         a particular wave period, heading, and orientation around column.
%         units are MPa/m of double amlitude wave height
%%
% theta0 = 0;
% theta_w = 0;
% T = 4;
% path = 'C:\Users\Ansys\Documents\MATLAB\FreqDomain\';
% PartName = 'IS_C1';
% Iteration = 'Itr7_4';
% TorB = 'Top';

%%
%Path for stress results
path1 = [path Iteration '\'];

%Calcualte wave heading relative to the platform, 0 to 360 degree
theta_h = theta0 - theta_w; 
if theta_h < 0
    theta_h1 = theta_h + 360;
else
    theta_h1 = theta_h;
end

%Round the wave heading to nearest multiplier of 30 degree
theta_h2 = mod (round (theta_h1/30) * 30,360);
    
heading = num2str(theta_h2);
period = num2str(round(T));
path2 = [path1 'Run' heading '\'];

% S_real_file = [path2 'ElemStr_' PartName '_Run' head_test 'T' period '_real.csv'];
S_real_file = [path2 'ElemStr_' PartName '_Run' heading 'T' period '_real_' TorB '.csv'];
file_real = importdata(S_real_file);
data_real = file_real.data(ElemTest,:); 
file_real.data = [];

% S_imag_file = [path2 'ElemStr_' PartName '_Run' head_test 'T' period '_imag.csv'];
S_imag_file = [path2 'ElemStr_' PartName '_Run' heading 'T' period '_imag_' TorB '.csv'];
file_imag = importdata(S_imag_file);
data_imag = file_imag.data(ElemTest,:);
file_imag.data =[];

if strcmp(unit,'Pa')
    NormStr = scale*(data_real(:,5:10)/1e6 + data_imag(:,5:10)/1e6*i);
else
    NormStr = scale*(data_real(:,5:10) + data_imag(:,5:10)*i);
end

% ElemN = size(data_real, 1); %total number of elements
NormStr_amp = abs(NormStr); %Normal stress amplitude
NormStr_phase = angle(NormStr); %Phase angles of normal stresses

% for n = 1:ElemN
%     S_pr(n,:) = CalPrcpStr_6dof(NormStr(n,:)); %Principal stress(MPa), S1, S2 or S3
%     S_pr_3dof(n,:) = CalPrcpStr_3dof(NormStr_3dof(n,:));
%     S_pr_abs(n,:) = CalPrcpStr_6dof(NormStr_amp(n,:));
%     S_pr_abs_3dof(n,:) = CalPrcpStr_3dof(NormStr_amp_3dof(n,:));
%     S_pr_real(n,:) = CalPrcpStr_6dof(Norm_real(n,:));
%     S_pr_imag(n,:) = CalPrcpStr_6dof(Norm_imag(n,:));
% end

% S = abs(S_pr);
% S_3dof = abs(S_pr_3dof);
% S_pr_amp = hypot(S_pr_real, S_pr_imag);

% for m = 1:ElemN
%     theta_pr(m,1:3) = acos( real(S_pr(m,1:3))./S(m,1:3) );
%     for n=1:3
%         if imag(S(m,n)) <0
%             theta_pr(m,n) = theta_pr(m,n)+pi;
%         end
%     end
% end
% theta_pr_deg = theta_pr/pi*180;

% S_max1 = max(S,[],2);
% S_max2 = max(S_pr_abs,[],2);
% S_max3 = max(S_pr_amp,[],2);

end