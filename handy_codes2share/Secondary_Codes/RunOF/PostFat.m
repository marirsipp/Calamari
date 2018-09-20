function PostFat(fatdir)
%% Description
% Based off of PPFB.m: but must use RunOF to run the OrcaFAST models and
% generate the .opts. 
% Finds all the .opts in the fatdir 'Run*' subdirectories and save into a
%structure
% Written by Sam Kanner and Alan Lum
% Copyright Principle Power Inc. 2016
%% Variables2Define
% RunStr=[string], 'Run', Beginning of Run Name
% nSeeds = [integer], Number of seeds per bin
% t_trans = [float], Time to begin analyzing the time series (time at which
% transient ends)
% LineNames = {cell array}, {'LMB','VB','UMB'}, Array of strings of the
% beginning of the lines to output the forces
%% Preamble
% Written by Sam Kanner
% Copyright Principle Power Inc., 2016
iptname=getIPTname(mfilename);
run(iptname);
%%% BEGIN CODE
if ~strcmp(fatdir(end),filesep)
    fatdir=[fatdir filesep];
end
iRunStr=strfind(fatdir,RunStr)-1;
if ~isempty(iRunStr)
    resdir=[fatdir(1:iRunStr) 'Results' filesep];
else
    resdir=[fatdir(1:end) 'Results' filesep];
end
dirs= dir([fatdir RunStr '*']);
if isempty(dirs)
    error('change the RunStr')
end
iran=0;
for ii=1:length(dirs)
    OPTfile=[fatdir dirs(ii).name filesep dirs(ii).name '.opt'];
    [PtfmI,WindI,WaveI,CurI,GenI,TurbI,ResI]=generateInputListfromOPT(OPTfile);
    if ~isfield(TurbI,'Name') %due to constantly updating OPTfile contents
        TurbI.Name='Hitachi_5MW';% can be removed later
    end

    if ~isempty(ResI)
        iran=iran+1;
        Res(iran)=ResI;
        Runs(iran).Name=dirs(ii).name;
        RunNum=str2double(Runs(iran).Name(strfind(dirs(ii).name,RunStr)+length(RunStr)+1:end))+1; %remove leading 1
        Runs(iran).BinNum=ceil(RunNum/nSeeds); %assume form of DLC spreadsheet (for each bin, write the nSeeds, then go on to the next bin)
        Runs(iran).Ttrans=t_trans;
        Runs(iran).Lines=LineNames;
        if ~isfield(ResI,'yawfix')
             ResI.yawfix=yawfix;%due to constantly updating OPTfile contents, can be removed later
             ResI.NacYaw_mean=NacYaw_mean;%due to constantly updating OPTfile contents, can be removed later
        end
        try  
            Wind(iran)=WindI;
            Wave(iran)=WaveI;
            Res(iran)=ResI;
            %Turb(ii)=TurbI;
            %Gen(ii)=GenI;
        catch
            warning(['Your Wind or Wave parameters have changed throughout the fatigue runs, skipping Run:' dirs(ii).name])
        end
    end
end
disp(['Found ' sprintf('%d',iran) ' completed runs in ' fatdir])

RunList=1:iran;
RemRuns=RunList;
iS=1;
while ~isempty(RemRuns)
    %search for runs with the same wind/wave parameters (but not wind/wave
    %seed!)
    iRun=RunList==RemRuns(1); %get the index of the first of the  remaining runs
    iSeeds=[Wind.Speed]==Wind(iRun).Speed & [Wind.Dir]==Wind(iRun).Dir & ...
        [Wave.Dir]==Wave(iRun).Dir & [Wave.Hs]==Wave(iRun).Hs & [Wave.Tp]==Wave(iRun).Tp;
    %SeedRuns=RunList(iSeeds);
    % concatenate the .outb and .sim and write to a folder in resdir
    WindDirs(iS)=connectTheDats(fatdir,resdir,Runs(iSeeds),Wind(iSeeds),Res(iSeeds),nSeeds);
    iNotRem=~ismember(RemRuns,RunList(iSeeds));
    RemRuns=RemRuns(iNotRem);
    disp(['Number of Runs Remaining: ' sprintf('%d',length(RemRuns))])
    iS=iS+1;
end
RotateBatches([resdir 'basebend' filesep],WindDirs,nSeeds+1); %for the time series at the end
end

function WindDir=connectTheDats(fatdir,ResultsDir,Runs,Wind,Res,nSeeds)
%name stolen from Ilias
if ~exist(ResultsDir,'dir')
    mkdir(ResultsDir);
    disp(['creating' ResultsDir])
end
nRuns=length(Runs);
%% TODO: Should not copy runs to replace ones that have died. 
% Should just give BBY a run with a variable run-time, that she just scales
% up to 1 year. 
if nRuns<nSeeds
    for ii=1:nSeeds-nRuns
        Runs(nRuns+ii)=Runs(ii);
        Wind(nRuns+ii)=Wind(ii);
        Res(nRuns+ii)=Res(ii);
        disp(['duplicating ' Runs(ii).Name]);
    end
end
towername='basebend';
if ~exist([ResultsDir,towername],'dir')
    mkdir([ResultsDir,towername])
    disp(['creating ' ResultsDir towername])
end
BinNumStr=sprintf('%03d',Runs(1).BinNum);
%overwrite folders, if they exist
towerfid = fopen([ResultsDir,towername,filesep,BinNumStr '.dat'],'w+');
fclose(towerfid);
%% open an Orca Sim to get all of the lines (independent of discretization)
%assume that all Orca models are the same throughout all of the fatigue
%runs
FASTTotalTime=0;
SIMTotalTime=0;
[Lines,SIMtime,SIMtimeInFAST]=getLinesInSim([fatdir Runs(1).Name filesep],ResultsDir,Runs(1).Lines,BinNumStr,Runs(1).Ttrans);
for jj=1:nSeeds
    RunFolder=[fatdir Runs(jj).Name filesep];
    Outputs=dir([RunFolder 'Outputs' filesep]);
    iOut=false;
    if ~isempty(Outputs)
        OutFolder=Outputs.name;
        iOut=true;
    end
    %% FAST binary!
    towerfid = fopen([ResultsDir,towername,filesep,BinNumStr '.dat'],'a');
    if ~iOut
        Outbs=dir([RunFolder '*.outb']);
        if length(Outbs)>1
            warning(['Found more than 1 .outb in run folder. WTF? Taking the first one.'])
        elseif length(Outbs)<1
            error(['Outb file not found in folder: ' RunFolder])
        end
        FASTbinary=[RunFolder Outbs(1).name];
        [FAST_out, headers, units] = ReadFASTbinary(FASTbinary);
        FASTtime = FAST_out(:,ismember(headers,'Time'));
        endFASTt=max(FASTtime);
        timetol=1e-3; %are the FAST time steps not integer multiples of the Orca timesteps?!?
        iFASTTime= FASTtime >= Runs(jj).Ttrans -timetol & FASTtime <= endFASTt; % just in case we want to truncate the time series in the future
        basebend = FAST_out(iFASTTime,ismember(headers, {'TwrBsFxt';'TwrBsFyt';'TwrBsFzt';'TwHt1MLxt';'TwHt1MLyt';'TwHt1MLzt';})) * 1000; %in kN, convert to N
        basebend=interp1(FASTtime(iFASTTime),basebend,SIMtimeInFAST);
        data2write=[basebend' ; SIMtimeInFAST-SIMtimeInFAST(1)+FASTTotalTime];
    else
        %copy it from outputs folder
        %like ConnectDat, from Ilias
        FASTfid = fopen([OutFolder 'basebend.dat'],'r');
        basebend = fread(FASTfid,'double');
        fclose(FASTfid);
        timefid = fopen([OutFolder 'time.dat'],'r');
        FASTtime = fread(timefid,'double');
        fclose(timefid);
        warning('I still need to truncate the time series!!')
        data2write=[ basebend';FASTtime'];
    end
    fwrite(towerfid,data2write, 'double');
%     %% ORCA SIM!
%     Sims=dir([RunFolder '*.sim']);
%     if length(Sims)>1
%         warning(['Found more than 1 .sim in run folder. WTF? Taking the first one.'])
%     elseif length(Sims)<1
%         error(['Sim file not found in folder: ' RunFolder])
%     end
%     Xstrs={'X','Y','Z'};
%     % Extract Line Member results in the .sim
%     %% From PostOF:
%     if ~iOut
%         resh_mod = ofxModel([RunFolder Sims(1).name]);
%         resh_obj = resh_mod.objects;
%         resh_lines = resh_obj(cellfun(@(obj) isa(obj,'ofxLineObject'), resh_obj)); %Grab all LinesObjects
%         starttime=resh_mod.simulationStartTime;
%         timedata = resh_mod.simulationTimeStatus;
%         timeend = floor(timedata.CurrentTime - 1);
% 
%         t_start=starttime+Runs(jj).Ttrans;
%     end
%     for ii = 1:length(Lines)
%         linename=Lines(ii).name;
%         linefid = fopen([ResultsDir,linename,filesep,BinNumStr '.dat'],'a');
%         if ~iOut
%             line = resh_lines{Lines(ii).num};
%             resh_gen=resh_obj{1};
%             %SIMtime= resh_gen.TimeHistory('Time',ofx.Period(t_start,timeend));
%             for kk=1:3
%                 fA(:,kk) = line.TimeHistory(['End G' Xstrs{kk} '-Force'], ofx.Period(t_start, timeend), ofx.oeEndA);
%                 fB(:,kk) = line.TimeHistory(['End G' Xstrs{kk} '-Force'], ofx.Period(t_start, timeend), ofx.oeEndB);
%             end
%             fAr=Rotate2DMat(fA,(Wind(jj).Dir-Res(jj).yawfix)*pi/180);
%             fBr=Rotate2DMat(fB,(Wind(jj).Dir-Res(jj).yawfix)*pi/180);
%             fline(:,1:3) = fAr + fBr;
%             ma(1) = (line.EndAX - line.EndBX)/2; %Positive mean A > B, line goes from B to A in positive direction, to end A is positive, to end B is negative
%             ma(2) = (line.EndAY - line.EndBY)/2;
%             ma(3) = (line.EndAZ - line.EndBZ)/2;
%             nT=size(fA,1);
%             fline(:,4:6) = cross(repmat(ma,[nT,1]), fA) + cross(repmat(-ma,[nT,1]),fB) ; %moments do not need to be rotated??
%             fline(:,4:6) = Rotate2DMat(fline(:,4:6), (Wind(jj).Dir-Res(jj).yawfix)*pi/180);
%             data2write=[fline'; SIMtime-SIMtime(1)+SIMTotalTime];
%         else
%             %% copy file from Outputs folder,
%             %like ConnectDat, from Ilias
%             SIMfid = fopen([OutFolder,linename, '.dat'],'r');
%             data = fread(SIMfid,'double');
%             fclose(SIMfid);
%             timefid = fopen([OutFolder 'time.dat'],'r');
%             SIMtime = fread(timefid,'double');
%             fclose(timefid);
%             warning('I still need to truncate the time series!!')
%             data2write=[data';SIMtime'];
%         end
%         fwrite(linefid,data2write, 'double');
%         fclose(linefid);
%     end
FASTTotalTime=FASTTotalTime+SIMtimeInFAST(end)-SIMtimeInFAST(1)+ mean(diff(SIMtimeInFAST));
SIMTotalTime=SIMTotalTime+SIMtime(end)-SIMtime(1)+mean(diff(SIMtime));
end
fclose(towerfid);
fclose('all');
WindDir=Wind(1).Dir;
end

function [Lines,SIMtime,SIMtimeInFAST]=getLinesInSim(RunFolder,ResFolder,LineNames,BinNumStr,t_trans)
    %% ORCA SIM!
    Sims=dir([RunFolder '*.sim']);
    if length(Sims)>1
        warning(['Found more than 1 .sim in run folder. WTF? Taking the first one.'])
    elseif length(Sims)<1
        error(['Sim file not found in folder: ' RunFolder])
    end
    resh_mod = ofxModel([RunFolder Sims(1).name]);
    
    
    starttime=resh_mod.simulationStartTime;
    timedata = resh_mod.simulationTimeStatus;
    timeend = floor(timedata.CurrentTime - 1);
    t_start=starttime+t_trans;

    resh_obj = resh_mod.objects;
    resh_gen=resh_obj{1};
    SIMtime= resh_gen.TimeHistory('Time',ofx.Period(t_start,timeend));
    SIMtimeInFAST=SIMtime-starttime;
    resh_lines = resh_obj(cellfun(@(obj) isa(obj,'ofxLineObject'), resh_obj)); %Grab all LinesObjects
    nLines=length(LineNames);
    nML=1;
    for kk=1:nLines
        linename=LineNames{kk};
        for mm=1:length(resh_lines)
            iML=strfind(resh_lines{mm}.Name,linename);
            if ~isempty(iML)
                Lines(nML).name=resh_lines{mm}.Name;
                Lines(nML).num=mm;
                if ~exist([ResFolder,Lines(nML).name],'dir')
                    mkdir([ResFolder,Lines(nML).name])
                end
                linefid = fopen([ResFolder,Lines(nML).name,filesep,BinNumStr '.dat'],'w+');
                nML=nML+1;
                fclose(linefid);
            end
        end
    end
end
