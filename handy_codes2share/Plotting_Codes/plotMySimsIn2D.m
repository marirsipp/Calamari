function plotMySimsIn2D(varargin)
% Use createSimList to get desired simList--> choose stats.mat!!! (way
% faster)
% Use plotMySims to see a list of variables to plot
% h2p = 'Max', 'Min', 'Mean', or 'Std' (case-sensitive)

iTxt=0;
plotstr='kx';
if nargin>0
    simList=varargin{1};
end
if nargin>1
    varX=varargin{2};
end
if nargin>2
    varY=varargin{3};
end
if nargin>3
    h2s=varargin{4};
end
if nargin>4
    plotstr=varargin{5};
end
if nargin>5
    iTxt=varargin{6};
end
if nargin<1
    [xlsname, xlspath]= uigetfile(filetypes,'Select DLC Workbook');  
    simList=createSimList([xlspath xlsname]);
end
if ~iscell(simList)
    simList={simList};
end
%% Get simList data info
nSim=length(simList );
for ss=1:nSim
    jpath=simList{ss};
    FileData(ss).pathname=jpath;
    [FileData(ss).FullPath, FileData(ss).filename, FileData(ss).ext] = fileparts(jpath);
    slashes=strfind(jpath,filesep);
    FileData(ss).PDir=jpath( slashes(end-1)+1:slashes(end)-1  ); %usually the Runname
    %FileData(ss).PPDir=jpath( slashes(end-2)+1:slashes(end-1)-1  ); %usually the RunFolder name
    %FileData(ss).HomeDir=jpath(1:slashes(end-1)-1  ); % usually the folder Runs, absolute path
end

if strcmp(FileData(1).filename,'stats')
    Data(1)=readStatsDotMat(FileData(1).pathname);%this is a structure with 1-D subfields
    disp('Cannot choose a time truncation using "stats.mat", use "outputs.mat" or the .sim instead')
else
    error('Can only read in "stats.mat".')
end

if nargin<2
    % ask the user what stats data to plot
    [iChoice, isOK] = listdlg('PromptString','Select X variable to plot', 'Name', 'Variables available', 'ListString', Data(1).headers,'SelectionMode', 'Single');
    if ~isOK 
        error('User Cancelled')
    end
    varX=Data(1).headers{iChoice}; 
end

if nargin<3
    % ask the user what stats data to plot
    [iChoice, isOK] = listdlg('PromptString','Select Y variable to plot', 'Name', 'Variables available', 'ListString', Data(1).headers,'SelectionMode', 'Single');
    if ~isOK 
        error('User Cancelled')
    end
    varY=Data(1).headers{iChoice}; 
end
if nargin<4
    h2s = questdlg('What stats do you want to plot?','Stats ','Mean','Max','Min','Mean');
end
if ~iscell(h2s)
    h2s={h2s};
end
if ~iscell(varX)
    varX={varX};
end
if ~iscell(varY)
    varY={varY};
end
if length(varX) ~= length(varY)
    error('Make sure the length of your X and Y variables are the same')
end
if length(h2s)<length(varX)
    disp(['Length of stats type does not equal variable list length. Repeating ' h2s ' ' num2str(nSim) ' times.']);
    h2s=repmat({h2s},1,nSim);
end
nFig=length(varX);
for pp=1:nFig
    xstr=varX{pp};
    ystr=varY{pp}; 
    ix=strfind(Data(1).headers,xstr);
    ilogChoiceX = not(cellfun('isempty', ix));
    if ~sum(ilogChoiceX)
        error(['An X variable: ' xstr ' does not exist in the stats.mat'])
    elseif sum(ilogChoiceX)>1
         xdstr=inputdlg(['Enter dimension for plotting' ] , ['X-variable ' xstr],1,{'1'});
         xstr=[xstr xdstr{1}];
         ix=strfind(Data(1).headers,xstr);
         ilogChoiceX = not(cellfun('isempty', ix));
    end
    iChoiceX=find(ilogChoiceX);
    
    iy=strfind(Data(1).headers,ystr);
    ilogChoiceY = not(cellfun('isempty', iy));
    if ~sum(ilogChoiceY)
        error(['A Y variable: ' ystr ' does not exist in the stats.mat'])
    elseif sum(ilogChoiceY)>1
         ydstr=inputdlg(['Enter dimension for plotting' ] , ['Y-variable ' ystr],1,{'1'});
         ystr=[ystr ydstr{1}];
         iy=strfind(Data(1).headers,ystr);
         ilogChoiceY = not(cellfun('isempty', iy));
    end
    iChoiceY = find(ilogChoiceY);
    uXstr=Data(1).units{ilogChoiceX}; % all stats.mat must be ordered in the same way
    uYstr=Data(1).units{ilogChoiceY};
    figname=[xstr 'vs' ystr '_' h2s{pp}];
    figure('name',figname);
    yaxstr=[h2s{pp} ' of ' ystr,' ', '[' uYstr ']'];    xaxstr=[h2s{pp} ' of ' xstr,' ', '[' uXstr ']'];
    xd=nan(nSim,1);
    yd=nan(nSim,1);
    for ss=1:nSim
    %     if strcmp(FileData(ss).filename,'outputs')
    %         Res=load(FileData(ss).pathname);
    %         ResUnits=Res.Units;
    %         [data,headers,units]=readRes(Res,ResUnits,iLikeLines); % -> all data are 1D time series!!
    %         %[data,headers,units]=readOutputs([mypath{ss}, out_name{ss}]); %this is a time series
        if strcmp(FileData(ss).filename,'stats')
            Data(ss)=readStatsDotMat(FileData(ss).pathname);%this is a structure with 1-D subfields
        else
            error('Can only read in "stats.mat".')
        end
        alldata=Data(ss).(h2s{pp});
        xd(ss)=alldata{ilogChoiceX};
        yd(ss)=alldata{ilogChoiceY};
        if iTxt
            ht=text(xd*1.01,yd*1.01,FileData(ss).PDir);
        end
        hold on
    end
    plot(xd,yd,plotstr)
    grid on
    ylabel(yaxstr)
    xlabel(xaxstr)
    hold off
end
end