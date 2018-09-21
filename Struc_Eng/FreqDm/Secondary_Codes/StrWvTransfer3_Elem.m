function [S_max1] = StrWvTransfer3_Elem(theta0,theta_w,T,path,PartName, Iteration, TorB,ElemTest,unit,scale)

%% Computes transfer function for principle stress output from ANSYS model
%Use this script in conjunction with SpectralFatigue2.m
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

% %Calculate heading of the input file, due to symmetry
% if theta_h2 >180
%     theta_h3 = 360-theta_h2;
% else
%     theta_h3 = theta_h2;
% end
    
heading = num2str(theta_h2);
period = num2str(round(T));
% head_test = '0';
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
%     Norm_real = data_real(:,5:10)/1e6; %Convert to MPa
%     Norm_imag = data_imag(:,5:10)/1e6;
    NormStr = scale*(data_real(:,5:10)/1e6 + data_imag(:,5:10)/1e6*i);
else
%     Norm_real = data_real(:,5:10);
%     Norm_imag = data_imag(:,5:10);
    NormStr = scale*(data_real(:,5:10) + data_imag(:,5:10)*i);
end

% Norm_real_3dof(:,1:2) = data_real(:,6:7);
% Norm_real_3dof(:,3) = data_real(:,9);
% Norm_imag_3dof(:,1:2) = data_imag(:,6:7);
% Norm_imag_3dof(:,3) = data_imag(:,9);

ElemN = size(data_real, 1); %total number of elements
% NormStr_amp = hypot(Norm_real,Norm_imag); %Normal stress amplitude
% NormStr_amp_3dof = hypot(Norm_real_3dof,Norm_imag_3dof);

%Phase angles of normal stresses
% for m = 1:ElemN
%     theta(m,1:6) = acos( data_real(m,5:10)./NormStr_amp(m,1:6) );
%     for n=1:6
%         if data_imag(m,n+4) <0
%             theta(m,n) = theta(m,n)+pi;
%         end
%     end
% end
% theta_deg = theta/pi*180;

% NormStr = Norm_real + Norm_imag*i;
% NormStr_3dof = Norm_real_3dof + Norm_imag_3dof*i;

% PlaneStr(:,1:2) = data_real(:,6:7);
% PlaneStr(:,3) = data_real(:,9);

for n = 1:ElemN
    S_pr(n,:) = CalPrcpStr_6dof(NormStr(n,:)); %Principal stress(MPa), S1, S2 or S3
%     S_pr_3dof(n,:) = CalPrcpStr_3dof(NormStr_3dof(n,:));
%     S_pr_abs(n,:) = CalPrcpStr_6dof(NormStr_amp(n,:));
%     S_pr_abs_3dof(n,:) = CalPrcpStr_3dof(NormStr_amp_3dof(n,:));
%     S_pr_real(n,:) = CalPrcpStr_6dof(Norm_real(n,:));
%     S_pr_imag(n,:) = CalPrcpStr_6dof(Norm_imag(n,:));
end

S = abs(S_pr);
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

S_max1 = max(S,[],2);
% S_max2 = max(S_pr_abs,[],2);
% S_max3 = max(S_pr_amp,[],2);

% if strcmp( TorB,'Top')
%     for i = 1:ElemN
%         S1 = hypot(data_real(i,5),data_imag(i,5)); %S1, top 
%         S3 = hypot(data_real(i,7),data_imag(i,7)); %S3, top
%         Shs(i,1) = max([S1,S3]); %
%     end
% elseif strcmp( TorB,'Btm')
%     for i = 1:ElemN
%         S2 = hypot(data_real(i,6),data_imag(i,6)); %S1, btm
%         S4 = hypot(data_real(i,8),data_imag(i,8)); %S3, btm
%         Shs(i,1) = max([S2,S4]); %
%     end
% else
%     disp('Top or bottom surface input is invalid')
% end

% data(:,1:3) = data_real(:,2:4);
% data(:,4) = S_max1;
% scatter3(data(:,1),data(:,2),data(:,3),15,data(:,4),'filled')
end