clc
clear all

%Calculate average tension from deformed shape due to bending

%Input 
% path0 = 'D:\Bingbin\Documents\Fatigue assessment\@WFP WFA\WFA\FlexModel\TestCase3_DaletFrame';
path0 = 'D:\Bingbin\Documents\Fatigue assessment\@WFP WFA\WFA\FlexModel\TestCase2_LMBOnly';
% CaseName = 'Dry_Alpha_1pt5';
CaseName = 'LMB_FF';
OutFileName = ['SAP_BeamResult_' CaseName '.xls'];
OutFile = [path0 '\' OutFileName];

Beam1 = 'Col2';
Beam2 = 'LMB';

%Beam properties
E = 200e9; %Pa, Young's modulus

L_Beam2 = 52.7; %m
ro_Beam2 = 1.1; %m, outer radius of LMB
thk_Beam2 = 0.025; %m, thickness of LMB

A_Beam2 = pi*(ro_Beam2^2 - (ro_Beam2-thk_Beam2)^2);
I_Beam2 = pi/4*(ro_Beam2^4 - (ro_Beam2-thk_Beam2)^4);
EA_Beam2 = E*A_Beam2;
EI_Beam2 = E*I_Beam2;
%%
%Calculate piece-wise deformed length of Beam 2
BeamDispTab = [Beam2 '_Disp'];
L = L_Beam2;
EA = EA_Beam2;
EI = EI_Beam2;
[num1, txt1] = xlsread(OutFile,BeamDispTab);
%%
Def_Crd = num1(:,1:3)+num1(:,4:6);
for n = 1:(size(Def_Crd,1)-1)
    L_seg(n) = sum ((Def_Crd (n+1,:) - Def_Crd (n,:)).^2)^0.5;
end

P = (sum(L_seg)-L)/L*EA;