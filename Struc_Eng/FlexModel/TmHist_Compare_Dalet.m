clc
clear all

%Flexible model - Dalet Frame - SAP Orca comparison

path0 = 'D:\Bingbin\Documents\Fatigue assessment\@WFP WFA\WFA\FlexModel\TestCase5_SpringFrame\';
Case1 = 'BetaCase';
% Case1 = 'GammaCase';
% Case1 = 'AlphaBetaCase';

path1 = [path0 Case1 '\'];
path_orca = [path1 'Orca\'];

%SAP results to compare 
% FrameNo = 19; % LMB mid point
% StationNo = 0;
FrameNo = 10;
StationNo = 1.95556;  % Col2 25.16m above keel
MmtSap = 2;

%Orca results to compare
% OrcaRow = 45; % LMB mid point
% MmtDir = 'y';
% OrcaRow = 27; % Col2 4m above keel
OrcaRow = 6; % Col2 25m above keel
MmtDir = 'x';

%Loading case names
beta = 100;
if beta == 1000
    Case2 = ['beta' num2str(beta)];
else
    Case2 = ['beta0' num2str(beta)];
end

% gamma = 500;
% if gamma == 1000
%     Case2 = ['gamma' num2str(gamma)];
% else
%     Case2 = ['gamma0' num2str(gamma)];
% end

% alpha = 1;
% beta = 1000;
% if alpha <10
%     Case2 = ['alpha00' num2str(alpha) '_beta' num2str(beta)];
% elseif alpha <100
%     Case2 = ['alpha0' num2str(alpha) '_beta' num2str(beta)];
% else
%     Case2 = ['alpha' num2str(alpha) '_beta' num2str(beta)];
% end

RstFile = [path1 'SAP_Output_' Case2 '.xlsx'];

T = 10; %s
t = 0:1:T;

ratio = sin(2*pi/T*t')*beta/1000;
% ratio = sin(2*pi/T*t')*gamma/1000;
% ratio = sin(2*pi/T*t')*alpha/100;
%%
LoadName1 = num2cell(10*t');
LoadName = cell(length(t),1);
LoadName_NL = cell(length(t),1);

for i = 1:length(t)
    if t(i) == 0
        LoadName{i} = [Case2 '_t00' num2str(LoadName1{i})];
        LoadName_NL{i} = [Case2 '_t00' num2str(LoadName1{i}) '_NL'];
    elseif t(i) <10
        LoadName{i} = [Case2 '_t0' num2str(LoadName1{i})];
        LoadName_NL{i} = [Case2 '_t0' num2str(LoadName1{i}) '_NL'];
    else
        LoadName{i} = [Case2 '_t' num2str(LoadName1{i})];
        LoadName_NL{i} = [Case2 '_t' num2str(LoadName1{i}) '_NL'];
    end    
end

result = SAP_Post_Force_Single(RstFile, FrameNo, StationNo);
for i = 1:length(t)
    P(1,i) = result.(LoadName{i})(1);
    M2(1,i) = result.(LoadName{i})(5);
    M3(1,i) = result.(LoadName{i})(6);
    P(2,i) = result.(LoadName_NL{i})(1);
    M2(2,i) = result.(LoadName_NL{i})(5);
    M3(2,i) = result.(LoadName_NL{i})(6);
end

t_expd = [t,t+T,t+T*2,t+T*3,t+T*4,t+T*5,t+T*6,t+T*7,t+T*8,t+T*9];
P_expd = [P,P,P,P,P,P,P,P,P,P];
M2_expd = [M2,M2,M2,M2,M2,M2,M2,M2,M2,M2];
M3_expd = [M3,M3,M3,M3,M3,M3,M3,M3,M3,M3];

if MmtSap == 2
    M_expd = -M2_expd;
elseif MmtSap == 3
    M_expd = M3_expd;
end
%%
cd([path_orca Case2 '\'])
fnames = dir('*wall*');
temp_w = importdata(fnames.name);
fnames = dir(['*' MmtDir '-Bend*']);
temp_m = importdata(fnames.name);
%%
%Linear theory solution
t1 = 0:0.5:10*T;
ratio1 = sin(2*pi/T*t1')*beta/1000;
for n = 1:length(t1)
    Rst_LinrThry(n,:) = Dalet_Frame_LMBmid_PtFc(0,ratio1(n));
end

%%
path_comp = [path1 '\Compare'];
FigName = [path_comp '\' Case2];

figure(1)
subplot(2,1,1)
plot(temp_w.data(1,:),temp_w.data(OrcaRow,:),t_expd,P_expd(1,:),t_expd,P_expd(2,:))
% plot(temp_w.data(1,:),temp_w.data(3,:),t_expd,P_expd(1,:),t_expd,P_expd(2,:),t1,Rst_LinrThry(:,1)')
legend('Orca','SAP\_Linear','SAP\_NL')
xlabel('Time (s)')
ylabel('Wall tension (N)')
title(['Wall tension time series - ' Case2])

subplot(2,1,2)
plot(temp_m.data(1,:),temp_m.data(OrcaRow,:),t_expd,M_expd(1,:),t_expd,M_expd(2,:))
legend('Orca','SAP\_Linear','SAP\_NL')
xlabel('Time (s)')
ylabel([MmtDir '-bending moment (N-m)'])
title([MmtDir '-bending moment time series - ' Case2])

h1=figure(1);
print(h1,'-dpng',[FigName '.png'],'-r300')
hgsave(h1,FigName)

%%
path_rainflow='C:\Users\Ansys.000\Documents\MATLAB\TimeDomain\Codes';
cd(path_rainflow)
DEL_wall(1) = DELCal(P_expd(1,:)/1e3,t_expd,3)*1e3;
DEL_wall(2) = DELCal(P_expd(2,:)/1e3,t_expd,3)*1e3;
DEL_wall(3) = DELCal(temp_w.data(OrcaRow,:)/1e3,temp_w.data(1,:),3)*1e3;

DEL_bend(1) = DELCal(M_expd(1,:)/1e3,t_expd,3)*1e3;
DEL_bend(2) = DELCal(M_expd(2,:)/1e3,t_expd,3)*1e3;
DEL_bend(3) = DELCal(temp_m.data(OrcaRow,:)/1e3,temp_m.data(1,:),3)*1e3;