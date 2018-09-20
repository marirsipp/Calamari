function seedSelection_BATCH(IPTfile,varargin)
%% Description
% Takes a an array of DLC families, seed selects based on user-defined
% inputs and write a .mat and .csv file with the selected seeds (careful,
% it overwrites!) 
% Written by Sam Kanner
% Copyright Principle Power Inc. 2016
%% Variables2Define
% mainDLCs = [array], of DLC families to sort through
% runPrefix = [string] of the beginning of how the run folders are called
% rundir = [string] of where the Run## folders are located,
% tdir = [string] you want the tables output into (will create a folder
% called 'Stats' and 'Seeds' for the .mat and the .csv, respectively.) 
% vars = [cell array] of strings of the 'sensors' you want to examine
% vars2seed = [cell array] of strings of the 1-D sensors you want to seed by, ie 'motionsXY', 'basebendRXY'
% how2select = [cell array] of strings, same length of vars2seed 
% isave=1; % 1= save .mat files of the seeds (needed for plotting later) %0= don't save
% iplot=0;% 1 = create lots of plots of the seed selection for manual inspection, %0= don't plot
% iname=2; %type of run naming system 1 = like Alan, 2= like Ilias
%       iname=1 1: like Alan- single digit number when number of seeds <10
%       iname=2: like Ilias- double digit number always
%%
% Written by Sam Kanner
% Copyright Principle Power Inc., 2016
%% Default Values
iExtract=1;
isave=1;
iname=2;
iAn=1:10;% assume no Bridle, all mooring lines are anchored
iBr=[]; %iBr=[1:3]';
%% Use an input file to specify properties of platform
if nargin>0
    iptname=IPTfile;
else
    iptname=getIPTname(mfilename);
end
run(iptname);
%% SETUP
nrows=length(mainDLCs);
ncols=length(vars2seed);
dataseed=zeros(nrows,ncols);
if ~strcmp(rundir(end),filesep)
    rundir=[rundir filesep];
end 

slashes=strfind(rundir,filesep);
maindir = rundir(1:slashes(end-1));
if ~exist('statdir','var')
    statdir= [maindir filesep 'Statistics' filesep 'Stats'];
end
if ~exist(statdir,'dir')
    disp('creating a Statistics directory')
    mkdir(statdir)
end

%% MAIN CODE
for ii=1:length(mainDLCs)
    mainDLC=mainDLCs(ii);
    if isnumeric(mainDLC)
        mainDLC=sprintf('%d',mainDLC);
    end
    fname=sprintf('SeedStats_%s.mat',mainDLC);
    %% SECONDARY CODE #1 
    RunRange=getSeeds(mainDLC,rundir,runPrefix); % get the list of folders that have the same family name
    %% SECONDARY CODE #2 
    % extract the stats from the time series (using outputs.mat or outputs folder)
    if iExtract
        OutS=getStats(rundir,RunRange,vars2seed,runPrefix,iAn,iBr); 
    end
    % Can plot the time series to show the extremes and when they occur (iplot=1 in seedSelection_BATCHipt.m)
    if isave
        %intermediary save, in case something goes wrong
         save([statdir filesep fname],'OutS')
    end 
    %% SECONDARY CODE #3
     % select the seed that 'best represents' all of the seeds 
    OutS=seedSelection(OutS,vars2seed,how2select,runPrefix,iplot,iname); 
    if isave
        %final save, overwriting previous save with new seed information
         save([statdir filesep fname],'OutS')
         disp(['(Over)writing summary statistics file: ' statdir filesep fname])
    end 
    % Post-processor preparation
    [seedtype,dataseed(ii,:)]=getSeeds4Table(OutS,vars2seed); % make a simple table to show which seeds have been chose
end
%% POST-PROCESS
%create tables
headers=['Seed-parent,'];
for ii=1:ncols
    headers=[headers seedtype{ii} ','];
end
header1='Table of representative random wave seeds based on various criteria:';
DLCstr=sprintf('%d',mainDLCs(1)); %only uses the DLC # of the first mainDLC
if ~exist(tdir,'dir')
    disp('Statistics directory not found. Creating one...')
    mkdir(tdir)
end
tname=sprintf('%sSeeds_%s.csv',tdir, DLCstr(1:2));
if exist(tname,'file')
    disp('overwriting Seed table')
end
fid1=fopen(tname,'w+');
fprintf(fid1,'%s \n',header1);
fprintf(fid1,'%s \n',headers);
tfmt=[repmat('%d,',[1 ncols+1]) '\n'];
for jj=1:nrows
    jrow=[mainDLCs(jj) dataseed(jj,:) ];
    fprintf(fid1,tfmt,jrow);
end
fclose(fid1);
end


function [seedtype,seednum]= getSeeds4Table(OutS,vars)
[foo,iv]=unique(vars,'first'); 
uvars=vars(sort(iv));
seedstr='Seed';
ncols=0;
seedtype={};

for var_i = 1:length(uvars);
    variable = uvars{var_i};
    seedNames=fieldnames(OutS.(variable));
    for jj=1:length(seedNames) %Seedmin, Seedmax, etc
        sName=seedNames{jj};
        isName=strfind(sName,seedstr);
        if ~isempty(isName)
            ncols=ncols+1;
            seedtype{ncols}=[variable '-' sName(end-2:end)]; % terrible memory allocation
            seednum(ncols)=OutS.(variable).(sName);  % terrible memory allocation
        end
    end
end

end
