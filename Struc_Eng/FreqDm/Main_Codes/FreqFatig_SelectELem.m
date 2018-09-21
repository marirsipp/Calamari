%% Frequency Domain Fatigue Calculation for Elements after Pre-screening
%Calculate fatigue life from frequency domain analysis, of elements that
%are below the targeted fatigue life based on presecreening method
%By Bingbin Yu, Principle Power Inc. 
%Last major edits: July 2017
%Based on SpectralFatigue.m, which is edited by Peter Fobel, 5/27/2014
% Run FreqFatig_ipt_**.m first (** is your computer name)

%% Input Parameters
%Name of member to be calculated fatigue damage. 
path_ScrnRst = [path_itr 'Results_Mthd' num2str(Method_PreScreen) '\']; % Path for storing results
path_FinalRst = [path_itr 'Results_Mthd' num2str(Method_FinalCal) '\'];
if ~exist(path_FinalRst,'dir')
    mkdir(path_FinalRst)
end
load([path0 SNfile])

N_SelGroup = size(SelectGroups,2);
Func_name = ['SpectralFatigue_Mthd' num2str(Method_FinalCal)];
RunType = 'sel';

if Method_FinalCal == 3    
    Func_byMthd = [Func_name '(path_itr, path_str, MetFile_Sel, theta0, wave_theta, Part, SNcurve, MaxPeriod, unit,scale, RunType)' ];
elseif Method_FinalCal == 6
    Func_byMthd = [Func_name '(path_itr, path_str, MetFile_Sel, theta0, wave_theta, Part, SNcurve, SelIptMthd6, unit,scale, RunType)' ];
elseif Method_FinalCal == 7
    if ~exist('SeedNo','var')
        p=randperm(10);
        SeedNo = p(1);
    end
    Func_byMthd = [Func_name '(path_itr, path_str, MetFile_Sel, theta0, wave_theta, Part, SNcurve, SelIptMthd7, unit,scale, RunType, SeedNo)' ];
end

if Method_FinalCal == 7
    Life_fname = ['Life_Mthd' num2str(Method_FinalCal) '_Seed' num2str(SeedNo)];
else
    Life_fname = ['Life_Mthd' num2str(Method_FinalCal)];
end

for n=1:N_SelGroup
    GroupName = SelectGroups{n};
    GroupFile = [path_ScrnRst GroupName '_ELem2Run.mat' ];
    Result = load(GroupFile);
    
    Connections = fieldnames(Result.Elem2run.(GroupName));
    N_Cnnt = size(Connections,1);
    
    Part.Name = GroupName;
    for k=1:N_Cnnt
        CnntName = Connections{k};
        Part.Thk = Result.Elem2run.(GroupName).(CnntName).Thk; %mm
        Part.SNname = Result.Elem2run.(GroupName).(CnntName).SNcurve;
                
        Part.Surf = 'Top';
        TopResult = Result.Elem2run.(GroupName).(CnntName).Top;
        if ~isempty(TopResult)
            ElemTest = TopResult.ElemRow;
            Part.ElemRow = ElemTest;
            Life_Top1 = eval(Func_byMthd);
            Result.Elem2run.(GroupName).(CnntName).Top.(Life_fname)=Life_Top1;
        end
           
        Part.Surf = 'Btm';
        BtmResult = Result.Elem2run.(GroupName).(CnntName).Btm;
        if ~isempty(BtmResult)
            ElemTest = BtmResult.ElemRow;
            Part.ElemRow = ElemTest;
            Life_Btm1 = eval(Func_byMthd);
            Result.Elem2run.(GroupName).(CnntName).Btm.(Life_fname)=Life_Btm1;
        end 
    end
    if ~isempty(Result.Elem2run.(GroupName))
        GroupResult.(GroupName) = Result.Elem2run.(GroupName);
    end
end


RstFile = [path_FinalRst 'Life_SelElem_Seed' num2str(SeedNo) '.mat'];
% RstFile = [path_FinalRst 'Life_SelElem.mat'];
save (RstFile, 'GroupResult','-v7.3')