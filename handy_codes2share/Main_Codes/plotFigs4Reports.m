function plotFigs4Reports(iptfile,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% How to Use %%%%%%%%%%%%%%%%%%
% 0. Run the SeedSelection_BATCH script on all of the runs to select the
% seeds for plotting and create the OutS structures needed for this script
% 1. Define the DLCs you want to plot in the 'DLC Definitions' aof your IPT file.
% Make sure you define the variable as YOURNAME_DLCs=[YOUR RUN NUMBERS];
% 2. Define the stats directories where the OutS files are saved as 'SeedStats_####'
% 2.1: You can define multiple directories such that: sdir{1}, sdir{2}, so that you can define the same runs across different models
% 3. Define (and create, if this is the first time) the figdir where you
% want all of your .figs and .pngs to be saved
% 4. Add a case in the plotFigs4ReportsIPT.m file -> save this file in your
% project directory
% 5. Run "plotFigs4JPN_Report('path\to\your\plotFigs4ReportsIPT.m')" 
% Written by Sam Kanner
% Copyright Principle Power Inc. 2017
%% Get input-file
if nargin<1
   iptfile = uigetfile('.m','Select input file for plotting figs');
end

run(iptfile);

if exist('statdir','var')
    sdir=statdir;
end

if length(sdir)<2
    lstrs='';
end
%All_DLCs=union(Abnorm_DLCs,Norm_DLCs);
try
    eval(['myDLC=' DLC2plt '_DLCs;'])
catch
    error(['Please define ' DLC2plt ' in the preamble'])
end
ndlc=myDLC(1);
nmax = floor(log(abs(ndlc))./log(10));
DLCnum=ndlc/10^nmax;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% DLCs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~iscell(sdir)
    mydir=sdir;
    sdir={};
    sdir{1}=mydir;
end
sdir1=sdir{1};
slashes=strfind(sdir1,filesep);
if ~exist('figdir','var')   
    figdir=[sdir1(1:slashes(end)) 'Figs'];
end
if ~isdir(figdir)
    mkdir(figdir)
end

if ~iscell(vars2plot)
    vars2plot={vars2plot};
end
for ss=1:length(sdir) 
    AllData(ss)=combineStats(myDLC,sdir{ss});
end

if ~isempty(strfind(DLC2plt,'Abnorm'))
    SF=1.1;
elseif ~isempty(strfind(DLC2plt,'Norm'))
    SF=1.35;
end


if strcmp(DLC2plt,'POW') || strcmp(DLC2plt,'PAR')
    DLCstr=DLCnum;
else
    DLCstr=DLC2plt;
end
nplots=length(vars2plot);
divis=ones(1,nplots);
vars2seed=vars2plot;
for jj=1:nplots
    jvar=vars2plot{jj};
    %isitXY=strcmp(jvar(end-1:end),'XY');

    
    if strcmp(jvar,'COLtrack') || strcmp(jvar, 'WEPtrack') %isitXY ||
        vars2seed{jj}=jvar;
%    
%         vars2seed{jj}=basevar;
%         basevar
    %else
    %    fstr = questdlg('Do you want to seed select by planar motion or rotational motion?','Naming Scheme','XY','RXY','XY');
    %    vars2seed{jj}=[jvar fstr];
    end
    if strfind(jvar,'basebend')
        %         divis=max(maxi)*SF; % if you want to plot the safety
        %         factor need to have the max of the data to plot
        divis(jj)=1;
    elseif strfind(jvar,'motions')
        divis(jj)=1;
    elseif strfind(jvar,'naccel')
        divis(jj)=5;
    else 
        divis(jj)=1;
    end
    %plotWithBars(AllData,myDLC,{jvar},{vars2seed},DLCstr,figdir,lstrs,divis,how2seed{jj});
end
plotWithBars(AllData,myDLC,vars2plot,vars2seed,DLCstr,figdir,lstrs,divis,how2select,iText);
end
