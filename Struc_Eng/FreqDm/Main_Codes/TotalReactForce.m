function[Rst] = TotalReactForce(FcFile)
%Calculate total spring reaction force and moment about platform center

%Input
% path0 ='C:\Users\Ansys.000\Documents\MATLAB\FreqDomain\'; 
% ItrNo = 'Itr7_3';
% Head = 'Run0';
% RorIm = 'real';
% Ext = 'CorrRotAccSmallMeter';
% Ext = 'Damp';

% path1 = [path0 ItrNo '\Results\' 'ReactForces\'];
% FcFile = [path1 'RctFc_' Head '_' RorIm '.csv'];
% FcFile = [path1 'RctFc_' Head '_' RorIm '_' Ext '.csv'];
FcData = importdata(FcFile);

Period = FcData.data(:,1);

FzC1 = FcData.data(:,5); %N
FxC1 = FcData.data(:,6);
FzC2 = FcData.data(:,11);
FxC2 = FcData.data(:,12);
FyC2 = FcData.data(:,16);
FzC3 = FcData.data(:,20);
FxC3 = FcData.data(:,21);
FyC3 = FcData.data(:,25);

Fr = [FzC1,FxC1,FzC2,FxC2,FyC2,FzC3,FxC3,FyC3]; %Reaction force matrix

LM_FzC1 = [0, -30426, 0]; %Momment arm for Mx, My, Mz about platform center, mm
LM_FxC1 = [0, -18000, 0];
LM_FzC2 = [26350, 15213, 0];
LM_FxC2 = [0, -18000, -31330];
LM_FyC2 = [18000, 0, -18088];
LM_FzC3 = [-26350, 15213, 0];
LM_FxC3 = [0, -18000, 31330];
LM_FyC3 = [18000, 0, -18088];

LM = [LM_FzC1;LM_FxC1;LM_FzC2;LM_FxC2;LM_FyC2;LM_FzC3;LM_FxC3;LM_FyC3];

Total_F = [ FxC1+FxC2+FxC3, FyC2+FyC3, FzC1+FzC2+FzC3]/1000; %kN
Total_M = [Fr*LM(:,1),Fr*LM(:,2),Fr*LM(:,3)]/1e6; %kNm

Rst = [Period, Total_F*1000, Total_M*1000]; %s, N
end