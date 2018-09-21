%% FreqFatig_AllParts.m calculates fatigue damage due to wave loads in frequency domain 
%Calculation is done by member groups. Each group has a single thickness
%and SN curve. This is done for selection of worst nodes/elements
%Run FreqFatig_ipt_**.m first to generate variables prerequisite for this
%code
%By Bingbin Yu, Principle Power Inc. 
%Last major edits: April 2017

%theta_wp1 = theta0 - wave_theta.simulated; % wave heading relative to platform orientation;
%theta_wp = mod(theta_wp1,360);
path_itr = [path0 Itr '\']; %General path for each iteration, stores wave scatter diagram
path_out = [path_itr 'Results_Mthd' num2str(Method_Analysis) '\']; % Path for storing results

if ~exist(path_out,'dir')
    mkdir(path_out)
end

load([path0 SNfile])
N_group = size(Parts,2);

Func_name = ['SpectralFatigue_Mthd' num2str(Method_Analysis)];
RunType = 'all';
if Method_Analysis == 3    
    Func_byMthd = [Func_name '(path_itr, path_str, MetData_File, theta0, wave_theta, Part, SNcurve, MaxPeriod, unit,scale, RunType)' ];
elseif Method_Analysis == 6
    Func_byMthd = [Func_name '(path_itr, path_str, MetData_File, theta0, wave_theta, Part, SNcurve, InputMthd6, unit,scale, RunType)' ];
elseif Method_Analysis == 7
    if ~exist('SeedNo','var')
        p=randperm(10);
        SeedNo = p(1);
    end
elseif Method_Analysis == 8
    Func_byMthd = [Func_name '(path_itr, path_str, MetData_File, theta0, wave_theta, Part, SNcurve, InputMthd8, unit,scale, RunType)' ];
else    
    Func_byMthd = [Func_name '(path_itr, path_str, MetData_File, theta0, wave_theta, Part, SNcurve, InputMthd7, unit,scale, RunType, SeedNo)' ];
end

for n=1:N_group
    Part.Name = Parts{n};
    Part.Thk = CGinfo.(Part.Name).thk;
    Part.SNname = CGinfo.(Part.Name).SN;
    
    TransferFile = [path_itr Part.Name '_Top_Shs0.mat'];
    try
        load(TransferFile, 'PartElemInfo');
        Result1(:,1:4)= PartElemInfo;
    catch 
        Result1(:,1:4) = ElemInfo(path_str, Part.Name, wave_theta.simulated(1), unit);
    end
    
    Part.Surf = 'Top';
    Life_Top1 = eval(Func_byMthd);
    Part.Surf = 'Btm';
    Life_Btm1 = eval(Func_byMthd);
    Result1(:,5) = Life_Top1;
    Result1(:,6) = Life_Btm1;
    OutputName = [path_out,Part.Name,'.csv'];
    csvwrite(OutputName,Result1)
    OutputName1 = [path_out,Part.Name,'.mat'];
    save(OutputName1,'Result1')
    clear Result1
end
