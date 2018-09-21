%% Frequency Domain Fatigue Calculation for hot spots
%Calculate fatigue life from frequency domain analysis, of elements after
%first screening
%By Bingbin Yu, Principle Power Inc. 
%Last major edits: April 2017
%Based on SpectralFatigue.m, which is edited by Peter Fobel, 5/27/2014
% Run FreqFatig_ipt_**.m first (** is your computer name)

%% Input Parameters
%Name of member to be calculated fatigue damage. 
path_HspRst = [path_itr 'Results_Mthd' num2str(Method_hotspot) '\']; % Path for storing results
load([path0 SNfile])

N_HspGroup = size(HotspotGroups,2);
Func_name = ['SpectralFatigue_Mthd' num2str(Method_hotspot)];
RunType = 'hsp';
if Method_hotspot == 3    
    Func_byMthd = [Func_name '(path_itr, path_str, MetFile_hsp, theta0, wave_theta, Part, SNcurve, MaxPeriod, unit,scale, RunType)' ];
elseif Method_hotspot == 6
    Func_byMthd = [Func_name '(path_itr, path_str, MetFile_hsp, theta0, wave_theta, Part, SNcurve, HspIptMthd6, unit,scale, RunType)' ];
elseif Method_hotspot == 7
    if ~exist('SeedNo','var')
        p=randperm(10);
        SeedNo = p(1:6);
    end
    Func_byMthd = [Func_name '(path_itr, path_str, MetFile_hsp, theta0, wave_theta, Part, SNcurve, HspIptMthd7, unit,scale, RunType, SeedNo)' ];
end

for n=1:N_HspGroup
    GroupName = HotspotGroups{n};
    PartFile = [path_HspRst GroupName '_Summary.xls' ];
    Result = importdata(PartFile);
    if isfield(Result.data,'Sheet1') %On Tiamat the .xls file include several sheets (only sheet1 has the info)
        rstdata = Result.data.Sheet1;
        rsttext = Result.textdata.Sheet1;
    else
        rstdata = Result.data;
        rsttext = Result.textdata;
    end
    PartThk = rstdata(:,1); %mm, member thickness
    Part.Name = GroupName;
    Part.Thk = PartThk;
    Part.SNname = rsttext(2:end,2);
    Part.CnntName = rsttext(2:end,1);
    
    Part.Surf = 'Top'; %Top or bottom surface of the member, 'Top' or 'Btm'
    ElemTest = rstdata(:,4);    
    Part.ElemRow = ElemTest;
    Life_Top1 = eval(Func_byMthd);
    
    Part.Surf = 'Btm';
    ElemTest = rstdata(:,7);
    Part.ElemRow = ElemTest;
    Life_Btm1 = eval(Func_byMthd);
    
    Life.(GroupName) = [Life_Top1 Life_Btm1];
end

%For running different seeds
if Method_hotspot == 7
    RstFile = [path_HspRst 'Life_Seed' num2str(SeedNo) '.mat'];
else
    RstFile = [path_HspRst 'Life.mat'];
end
save (RstFile, 'Life','-v7.3')