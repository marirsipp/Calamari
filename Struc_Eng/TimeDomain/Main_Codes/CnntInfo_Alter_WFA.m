function[] = CnntInfo_Alter_WFA(path0, ItrNo, ModelType)

%Load the general CnntInfo file and add in new information regarding new
%iteration
%Run after updating ThkLib_WFA.m

%% Set up general connection info
clear Cnnt
Cnnt = CnntInfo_WFA_Gen(path0, ItrNo, ModelType); %General Cnnt Info 
%% Alter connection info for current iteration
%% ItrR5_16_7_2
if strcmp(ItrNo,'ItrR5_16_7_2')
    %Line415 - LMB12 * FB12
    Cnnt.L415.LMB12.HspThk = Thk.Nominal.LMBSpRing4;

    Cnnt.L415.FB12.Hsp = -1386;
    Cnnt.L415.FB12.HspTol = 500;
    Cnnt.L415.FB12.HspThk = Thk.Nominal.FBsplice;

    %Line416 - LMB13 * FB13
    Cnnt.L416.LMB13.HspThk = Thk.Nominal.LMBSpRing4;

    Cnnt.L416.FB13.Hsp = -1386;
    Cnnt.L416.FB13.HspTol = 500;
    Cnnt.L416.FB13.HspThk = Thk.Nominal.FBsplice;

    %Line417 - LMB21 * FB21
    Cnnt.L417.LMB21.HspThk = Thk.Nominal.LMBSpRing4;

    Cnnt.L417.FB21.Hsp = 11085;
    Cnnt.L417.FB21.HspTol = 500;
    Cnnt.L417.FB21.HspThk = Thk.Nominal.FBsplice;

    %Line418 - LMB13 * FB31
    Cnnt.L418.LMB31.HspThk = Thk.Nominal.LMBSpRing4;

    Cnnt.L418.FB31.Hsp = 11085;
    Cnnt.L418.FB31.HspTol = 500;
    Cnnt.L418.FB31.HspThk = Thk.Nominal.FBsplice;

%% ItrR5_15_20_test
elseif strcmp(ItrNo,'ItrR5_15_20_test')
    Cnnt.L1.SN = 'ABS_E_Test';
    Cnnt.L1.TB.SDir = 80:10:100;
end
%% Save CnntInfo file
path1 = [path0 ItrNo '\'];
CnntFile = [path1 'CnntInfo.mat'];
save(CnntFile, 'Cnnt')
end