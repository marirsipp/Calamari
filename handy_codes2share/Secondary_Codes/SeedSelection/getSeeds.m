function RunRange=getSeeds(mainDLC,rundir,runPrefix)
%% Called by seedSelection_BATCH()
% Written by Sam Kanner
% Copyright Principle Power Inc. 2016
%% use this function to extract stats when you don't know which seeds have died
% INPUTS: 
% MainDLC = (scalar) Run Number without the seeds
% rundir = (string) location of Runs
% runPrefix = (string) String of beginning of all folders you in the rundir,
% typically 'Run'
% OUTPUTS:
% OutS = (structure) containing statistics for the seeds that survived
%% NOTES
% Currently only accepts folder name with runPrefix followed by a list of
% numbers.
%% TODO: how do we want to take into account folder with numbers and letters?
files = dir(rundir);
dirFlags = [files.isdir];
subFolders = files(dirFlags);
keepRuns={}; %bad memory allocation
if isnumeric(mainDLC)
    mainDLC=sprintf('%d',mainDLC);
end
keepi=0;
RunRange=[]; % %bad memory allocation
for ii=1:length(subFolders)
    mainL=length(runPrefix)+length(mainDLC);
    nameL=length(subFolders(ii).name);
    seedL=max(0,nameL-mainL);
    seedi=strfind([runPrefix mainDLC],subFolders(ii).name(1:end-seedL));
    if  ~isempty(seedi) && ~isempty(regexp(subFolders(ii).name(end),'[0-9]','once'))
        numstrc=regexp(subFolders(ii).name,'-?\d+\.?\d*|-?\d*\.?\d+','match');
        charstrc=regexp(subFolders(ii).name,'-?\D+\.?\D*|-?\D*\.?\D+','match');
        if length(numstrc)~=1 || length(charstrc)>1
            warning(['Run number is not fully numeric, so skipping: ' subFolders(ii).name])
        else
            keepi=keepi+1;
            seedNum=subFolders(ii).name(seedi+mainL:end);
            keepRuns{keepi}=subFolders(ii).name;
            RunRange(keepi)=str2num( [mainDLC seedNum] );
        end
    end
end
%OutS=getStats(rundir,RunRange,vars,runPrefix);
end



