function OutS=seedSelection(OutS,vars2seed,how2select,runPrefix,iplot,iname)
%% Called by seedSelection_BATCH()
% Written by Sam Kanner
% Copyright Principle Power Inc. 2016
%takes a main seed and looks for all the possible seed numbers
%then takes the mean of the maxs over all of the seeds of a parameter and tries to find the run
%whose mean is closest to this value.
%depends on getStats4Seeds (for now) in order to load the OutS
%also has a plotting funciton and can save a .mat
%% TODO: improve the plotting functionality
% How to make the seed selection plots for COLtrack more clear? So many
% sensors...


if length(vars2seed) ~= length(how2select)
    error('List of variables to seed (vars2seed) and how to select the seed (how2select) must be the same length')
end

%OutS=selectSeed(OutS,vars2seed,how2select,runPrefix,iname);

% only selectSeed a 1-D variable, such as basebendRXY, motionsRXY, or motions[1-6], etc. 
basevars=regexprep(vars2seed,'\d*','');
numvars=str2double(regexprep(vars2seed,'\D',''));
[RunNumS,famname]=getfamname(OutS,basevars,runPrefix,iname);
nRuns=length(RunNumS);
%if we are in a COLtrack
% nCols=3;
% nPts=4;
for var_i = 1:length(vars2seed);
    variable = vars2seed{var_i};
    basevar=basevars{var_i};
    if any(~cellfun('isempty',strfind({'ml', 'bar', 'baz'},basevar))) % numbers in variable name are OK
        basevar=variable;
    end
    h2s=how2select{var_i};
    extremes=zeros(nRuns,1);
    for jj=1:nRuns
        if isfield(OutS.(basevar).([runPrefix RunNumS{jj}]),'Max') || isfield(OutS.(basevar).([runPrefix RunNumS{jj}]),'Min')
            nD=length(OutS.(basevar).([runPrefix RunNumS{jj}]).Max);
            if nD>1 && ~isnan(numvars(var_i))
                iD=numvars(var_i);
            else
                iD=1;
            end
            if strcmp(h2s,'max')
                extremes(jj)= max(OutS.(basevar).([runPrefix RunNumS{jj}]).Max(iD));
            elseif strcmp(h2s,'min')
                extremes(jj)= min(OutS.(basevar).([runPrefix RunNumS{jj}]).Min(iD));
            else
                error('How do you want to select the seed?')
            end
        else
            extremes(jj)=nan;
        end
    end
    extremebar=nanmean(extremes);
    iseed=find( abs( extremes - extremebar) ==  min( abs( extremes - extremebar) ));
    if length(iseed)>1 && var_i==1 && ~isnan(extremebar)
        for kk=1:length(iseed)
            disp(['Warning: Runs ' RunNumS{iseed(kk)} ' have the same distance to the mean extreme value. Probably only 2 seeds'])
        end
    end
    h2sstr=['Seed' famname h2s];
    if ~isnan(extremebar)
        OutS.(variable).(h2sstr)=str2double(char(RunNumS{iseed(1)}));
    else
        OutS.(variable).(h2sstr)=nan;
    end
end

if iplot
    plotSeeds(OutS,vars2seed,how2select,runPrefix,iname)
end

end

function plotSeeds(OutS,vars,hows,runPrefix,iname)
runNames=fieldnames(OutS.(vars{1}));
%nRuns=length(runNames);
[RunNumS,famname]=getfamname(OutS,vars,runPrefix,iname);

nRuns=length(RunNumS);
for ii = 1:length(vars);
    variable = vars{ii}; % variable name like, 'basebendRXY'
    h2s = hows{ii};% like 'max' or 'min'
    time=OutS.(variable).([runPrefix RunNumS{1}]).time;
    if length(OutS.(variable).([runPrefix RunNumS{1}]).Mean)>1
        warning('You are trying to plot a multi-dimensional variable (such as "motions", etc), which is unsupported. Only using the first dimension (such as surge) in the plots.')
    end
    [nT,nD]=size(OutS.(variable).([runPrefix RunNumS{1}]).Data);
    datamat=zeros(nT,nRuns); %ASSUME: all seeds that finished successfully should have same run-time
    maxmat=zeros(1,nRuns);
    maxtime=zeros(1,nRuns);
    % get the seed data
    h2sstr=['Seed' famname h2s];
    seedstr=num2str(OutS.(variable).(h2sstr));
    iseed=strfind(RunNumS,seedstr);
    icell=~cellfun('isempty',iseed);
    jj2seed=find(icell);
    for jj=1:nRuns
        %datamat(:,(jj-1)*nD+1:(jj-1)*nD+nD)=OutS.(variable).([runPrefix RunNumS{jj}]).Data; %capable of handling multi-dimensional .Data
        if nD>1 && strcmp(h2s,'max')
            datamat(:,jj)=OutS.(variable).([runPrefix RunNumS{jj}]).Data(:,1);
             maxmat(jj)=max(OutS.(variable).([runPrefix RunNumS{jj}]).Max); % see getStats.m for the assignment of the structure
             maxtime(jj)=max(OutS.(variable).([runPrefix RunNumS{jj}]).MaxTime);
        elseif nD>1 && strcmp(h2s,'min')
            datamat(:,jj)=OutS.(variable).([runPrefix RunNumS{jj}]).Data(:,2);
            maxmat(jj)=min(OutS.(variable).([runPrefix RunNumS{jj}]).Min);
            maxtime(jj)=max(OutS.(variable).([runPrefix RunNumS{jj}]).MinTime);
        else
            datamat(:,jj)=OutS.(variable).([runPrefix RunNumS{jj}]).Data;
            maxmat(jj)=OutS.(variable).([runPrefix RunNumS{jj}]).Max;
            maxtime(jj)=OutS.(variable).([runPrefix RunNumS{jj}]).MaxTime;
        end
        if jj==jj2seed
            legstr{jj}=[runPrefix RunNumS{jj} '= The Chosen One'];
        else
            legstr{jj}=[runPrefix RunNumS{jj}];
        end
    end
%%%%%%%%%%%%--- MAKE SEED SELECT FIGURE (good for QA-QC)
    display('Plotting')
    figure(50+ii)
    h1=plot(time,datamat(:,1:nRuns)');
    set(h1(jj2seed),'linewidth',2)
    legend(legstr)
    hold on
    %plot horizontal lines at the maximums
    Dt=time(end)-time(1);
    for jj=1:nRuns
        
        line([time(1) time(end)],[maxmat(jj) maxmat(jj)],'color',[.5 .5 .5],'linewidth',2)
        text(min(maxtime)-.002*Dt,maxmat(jj)*1.002,legstr{jj})
    end
    
    line([time(1) time(end)],[maxmat(jj2seed) maxmat(jj2seed)],'color',[1 1 1].*(nRuns+1-nRuns+1)/(nRuns+1),'linewidth',3)
    %plot a red horizontal line at the mean of the max's
    line([time(1) time(end)],[mean(maxmat) mean(maxmat)],'color','r','linewidth',2)
    title(variable)
    drawnow
    grid on
    grid minor
end
hold off
%something about saving figs?
end

function [RunNumS,famname]=getfamname(OutS,vars,runPrefix,iname)
% how to obtain the seed number from the entire run number
% case 1: like Alan- single digit number when number of seeds <10
% case 2: like Ilias- double digit number always

runNames=fieldnames(OutS.(vars{1}));
nRuns=length(runNames);
RunNumS={};
jj=0;
for ii=1:nRuns
    runName=runNames{ii};
    if ~isempty(regexp(runName(end),'[0-9]','once'))
        jj=jj+1;
        RunNumS{jj}=runName(1+length(runPrefix):end); 
    end
end
runName1=runNames{1};
switch iname
    case 1
        if length(runNames)>1 
            ij=0;
            runName2=runNames{end};
            while isempty(regexp(runName2(end),'[0-9]','once'))
                runName2=runNames{end-ij};
                ij=ij+1;
            end
        else
            runName2=runName1(1:end-1);
        end
        famname=[];
        for jj=length(runPrefix)+1:min([length(runName1),length(runName2)])
            if strcmp(runName1(jj),runName2(jj))
                famname=[famname runName1(jj)];
            end
        end
    case 2
        famname=runName1(length(runPrefix)+1:end-2);
end
end