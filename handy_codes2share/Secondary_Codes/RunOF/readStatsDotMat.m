function Data=readStatsDotMat(matfile)
% need Data.Min, Data.Max,Data.Std, Data.Mean
% Data.headers, Data.units
[FullPath, stats, dotmat] = fileparts(matfile);
slashes=strfind(FullPath,filesep);
PDir=FullPath( slashes(end)+1:end ); %usually the Runname
load(matfile); % it is OutS
disp(['Loading stats.mat located in ' PDir])
varnames=fieldnames(OutS);
%Data.filename=matfile;
Data.headers=varnames;
for kk=1:length(varnames)
    nD=length(OutS.(varnames{kk}).Mean);  % all equal to 1
    Data.units{kk}=OutS.(varnames{kk}).Unit;
    Data.Mean{kk}=OutS.(varnames{kk}).Mean;
    Data.Min{kk}=OutS.(varnames{kk}).Min;
    Data.Max{kk}=OutS.(varnames{kk}).Max;
    Data.Std{kk}=OutS.(varnames{kk}).Std;
end
end