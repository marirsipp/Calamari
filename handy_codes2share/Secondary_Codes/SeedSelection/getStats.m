function OutS=getStats(rundir,RunRange,vars2seed,runPrefix,varargin)
%% Called by getStats4Seeds(mainDLC,rundir,vars,runPrefix)>> seedSelection_BATCH()
%rundir  = path where the 'Runs' folder is located
% vars is all of the vairable names you are interested in 
% RunRange is an array of integers corresponding to the runs you want to
% put in a single structure (currently does not work if the runname has
% letters at the end
% Written by Sam Kanner, with inspiration from Alan's StatShort
% Copyright Principle Power Inc. 2016
%% PURPOSE: take a RunRange, loop through the vars and create the structure OutS
%% TODO:
% Request by Ilias: add a functionality to take the max over the X-Y
% directions instead of taking the magnitude
% How to 
%% NOTES
% COLtrack must have at least 12 tracking points in order to work properly
OutS=[];
if ~strcmp(rundir(end),filesep)
    rundir=[rundir filesep];
end 
nCol=3;

if isempty(RunRange)
    error('No Runs were selected to extract Stats')
end

if nargin>=5
    iAn=varargin{1};
end
if nargin>=6
    iBr=varargin{2};
end
newRunOF=0;
for RunNum = RunRange
    RunNumS = num2str(RunNum);
    %load outputs.mat (time series)
    outputsfile=[rundir, runPrefix, RunNumS filesep 'outputs.mat'];
    if exist(outputsfile,'file')
        newRunOF=1;
        foundfile=1;
        disp(['Found outputs.mat file in: ' rundir, runPrefix, RunNumS])
        outputs=load(outputsfile);
    else
        foundfile=0;
        warning(['Did not find outputs.mat file in: ' rundir, runPrefix, RunNumS])
    end
    % strip numbers
    basevars=regexprep(vars2seed,'\d*','');
    for var_i = 1:length(basevars);
        
        variable = basevars{var_i}; 
        % strip XY or RXY 
        strs2strip={'XY','RXY'};
        cellind = cellfun(@(s) ~isempty(strfind(variable,s)),strs2strip,'uni',0);
        if sum([cellind{:}])>0
            ifoundstrs=find([cellind{:}]);
            for pp=1:length(ifoundstrs)
                str2strip=strs2strip{ifoundstrs(pp)};
                variable=strrep(variable,str2strip,'');
            end
        end
        if newRunOF && foundfile
            varnames=fieldnames(outputs);
            if strncmp(variable,'ml',2)
                imlEffT= find(~cellfun('isempty',regexp(varnames, regexptranslate('wildcard','ml*EffT'))));
                nML=length(imlEffT);
                nn=0;
                for mm=1:nML
                    mlname=varnames{imlEffT(mm)};
                    out = regexp(mlname,'\d*','match'); 
                    mlnum=str2num(out{:});
                    if ismember(mlnum,iAn)
                        nn=nn+1;
                        AnEffT(:,nn) = outputs.(mlname)(:,end); % take the last node
                    end
                end
                outputdata_temp=AnEffT;
                variable='AnchorEffT';
                t_temp=outputs.time;
                iMoor=1;                
            elseif isfield(outputs,variable)
                iMoor=0;
                outputdata_temp=outputs.(variable);
                t_temp=outputs.time;
            else
                error([variable 'does not exist in ' outputsfile '. Try loading the mat file and see what variables are there to seedSelect from.'])
            end
        else
            RunPath = [rundir, runPrefix, RunNumS '\Outputs\' variable '.dat']; %hard-coded file name. grrr....
            fid = fopen(RunPath); 
            if fid>=3 %file successfully opened
                foundfile=1;
                x = fread(fid,'double');
                fclose(fid);
                fid = fopen([rundir, runPrefix, RunNumS '\Outputs\time.dat']); %hard-coded file name. grrr....
                t_temp = fread(fid,'double');
                fclose(fid);
                if var_i==1
                    disp(['Found Seed #:' RunNumS(end) ', RunNum: ' RunNumS])
                end
                outputdata_temp =reshape(x,length(x)/length(t_temp),length(t_temp))';
            else
                foundfile=0;
            end
        end
        if foundfile
           % if exist('Turbine','var')
            %    if strcmp(Turbine.Code,'SDE')
                    % read in .fst file
            fstfiles=dir([rundir, runPrefix, RunNumS  filesep '*.fst']);
            if size(fstfiles,1)==1
                FST_file=[rundir, runPrefix, RunNumS ,filesep, fstfiles(1).name]; % choose the first fst file 
                [t_in,t_out]=getCutTime(FST_file,t_temp);
            elseif size(fstfiles,1)>1
                warning(['Multiple .fst files found in runfolder, using: '  fstfiles(1).name])
                FST_file=[rundir, runPrefix, RunNumS ,filesep, fstfiles(1).name]; % choose the first fst file 
                [t_in,t_out]=getCutTime(FST_file,t_temp);                
            elseif size(fstfiles,1)==0
                t_in=0;
                t_out=inf;
                iFAST=0;
            end

            if newRunOF
                if isfield(outputs,'CutInTime')
                    t_in_default=outputs.CutInTime;
                    if t_in>t_in_default
                        warning('You are running some sort of turbine maneuver (startup, shutdown, turbine pitch. Overwriting CutInTime to be %4.2f. See getCutTime to determine cut-in/out logic for these types of runs.',t_in)                   
                    else
                        % use the CutInTime defined by the user
                        t_in=t_in_default;
                    end
                end
                if isfield(outputs,'CutOutTime')
                    t_out_default=outputs.CutOutTime;
                    if t_out<t_out_default
                        warning('Overwriting CutOutTime to be %4.2f',t_out)
                    else
                        % use the CutOutTime defined by the user
                        t_out=t_out_default;
                    end
                end
            end
             %   end
           % end
            outputdata = outputdata_temp(t_temp>t_in & t_temp<t_out,:); % don't remove transient
            t = t_temp(t_temp>t_in & t_temp<t_out,:);
            nD=size(outputdata,2);
            [outputdata_min, outputdata_min_time] = min(outputdata);
            [outputdata_max, outputdata_max_time]= max(outputdata);
            % save to structure
            OutS.(variable).([runPrefix RunNumS]).time = t; %% ONLY USED FOR PLOTTING -> Should remove!
            OutS.(variable).([runPrefix RunNumS]).Mean = mean(outputdata);
            OutS.(variable).([runPrefix RunNumS]).Std = std(outputdata);
            OutS.(variable).([runPrefix RunNumS]).Min = outputdata_min;
            OutS.(variable).([runPrefix RunNumS]).Max = outputdata_max;
            OutS.(variable).([runPrefix RunNumS]).MinTime = t(outputdata_min_time);
            OutS.(variable).([runPrefix RunNumS]).MaxTime = t(outputdata_max_time);
            if nD == 1
                OutS.(variable).([runPrefix RunNumS]).Data = outputdata(:,1); 
            end
            if iMoor
                [output_max, iMLmax]= max(outputdata_max);
                [output_min, iMLmin]= min(outputdata_max);
                maxoutputdata=outputdata(:,iMLmax);
                OutS.(['Max' variable]).([runPrefix RunNumS]).time = t;
                OutS.(['Max' variable]).([runPrefix RunNumS]).Data = maxoutputdata;
                OutS.(['Max' variable]).([runPrefix RunNumS]).Mean = mean(maxoutputdata);
                OutS.(['Max' variable]).([runPrefix RunNumS]).Std = std(maxoutputdata);
                OutS.(['Max' variable]).([runPrefix RunNumS]).Max = output_max;
                OutS.(['Max' variable]).([runPrefix RunNumS]).MaxLine = iAn(iMLmax);
                OutS.(['Max' variable]).([runPrefix RunNumS]).Min = output_min;
                OutS.(['Max' variable]).([runPrefix RunNumS]).MaxTime = t(outputdata_max_time(iMLmax));
                OutS.(['Max' variable]).([runPrefix RunNumS]).MinTime = t(outputdata_max_time(iMLmin));
            end
            if (nD== 3|| nD == 6) && ~iMoor
                if strcmp(variable,'motions')
                    outputXY=sqrt((outputdata(:,1)-outputdata_temp(1,1)) .^2 + (outputdata(:,2)-outputdata_temp(1,2)).^2);
                else
                    outputXY=sqrt(outputdata(:,1).^2 + outputdata(:,2).^2);                    
                end
                OutS.(variable).([runPrefix RunNumS]).Data = outputXY; %% arbitrary for now
                
                dirXY = atan(outputdata(:,2)./outputdata(:,1));
                               % XY
               OutS.([variable 'XY']).([runPrefix RunNumS]).Mean = mean(outputXY);
               [outputXY_min, outputXY_min_time] = min(outputXY);
               [outputXY_max, outputXY_max_time]= max(outputXY);
               OutS.([variable 'XY']).([runPrefix RunNumS]).time = t; %% ONLY USED FOR PLOTTING -> Should I remove?
               OutS.([variable 'XY']).([runPrefix RunNumS]).Data = outputXY; %% ONLY USED FOR PLOTTING -> Should I remove?
               OutS.([variable 'XY']).([runPrefix RunNumS]).Std = std(outputXY);
               OutS.([variable 'XY']).([runPrefix RunNumS]).Min = outputXY_min;
               OutS.([variable 'XY']).([runPrefix RunNumS]).Max = outputXY_max;
               OutS.([variable 'XY']).([runPrefix RunNumS]).MinTime = t(outputXY_min_time);
               OutS.([variable 'XY']).([runPrefix RunNumS]).MaxTime = t(outputXY_max_time);
               OutS.([variable 'XY']).([runPrefix RunNumS]).MinDir = dirXY(outputXY_min_time);
               OutS.([variable 'XY']).([runPrefix RunNumS]).MaxDir = dirXY(outputXY_max_time);
            end
            if nD== 6%create a combination variable               
               outputRXY=sqrt(outputdata(:,4).^2 + outputdata(:,5).^2);               
               dirRXY = atan(outputdata(:,4)./outputdata(:,5));
               %RXY    
               OutS.([variable 'RXY']).([runPrefix RunNumS]).Mean = mean(outputRXY);
               [outputRXY_min, outputRXY_min_time] = min(outputRXY);
               [outputRXY_max, outputRXY_max_time]= max(outputRXY);
               OutS.([variable 'RXY']).([runPrefix RunNumS]).time = t; %% ONLY USED FOR PLOTTING 
               OutS.([variable 'RXY']).([runPrefix RunNumS]).Data = outputRXY; %% ONLY USED FOR PLOTTING 
               OutS.([variable 'RXY']).([runPrefix RunNumS]).Std = std(outputRXY);
               OutS.([variable 'RXY']).([runPrefix RunNumS]).Min = outputRXY_min;
               OutS.([variable 'RXY']).([runPrefix RunNumS]).Max = outputRXY_max;
               OutS.([variable 'RXY']).([runPrefix RunNumS]).MinTime = t(outputRXY_min_time);
               OutS.([variable 'RXY']).([runPrefix RunNumS]).MaxTime = t(outputRXY_max_time);
               OutS.([variable 'RXY']).([runPrefix RunNumS]).MinDir = dirRXY(outputRXY_min_time);
               OutS.([variable 'RXY']).([runPrefix RunNumS]).MaxDir = dirRXY(outputRXY_max_time);
            end
            if strcmpi(variable,'COLtrack') || strcmpi(variable,'WEPtrack')% we are in ColTrack
                nVar=size(outputdata,2);
                nProbe=nVar/nCol;
                %nProbe=4; %number of probes per column (top or bottom)

                %how to get COLtrack data- find column center submergence
                %by taking the mean around the 4 probes
                meanoutputdatacol=zeros(length(t),nCol);
                maxoutputdatacol=zeros(length(t),nCol);
                minoutputdatacol=zeros(length(t),nCol);
                if strcmpi(variable,'COLtrack')
                    for jj=1:nCol
                        meanoutputdatacol(:,jj)=mean(outputdata(:,nProbe*(jj-1)+1:nProbe*(jj-1)+nProbe),2);
                        %maxoutputdatacol(:,jj)=max(outputdata(:,nProbe*(jj-1)+1:nProbe*(jj-1)+nProbe),[],2);
                        %minoutputdatacol(:,jj)=min(outputdata(:,nProbe*(jj-1)+1:nProbe*(jj-1)+nProbe),[],2);
                    end
                    outputdata=meanoutputdatacol; % negatives give same information?
                    [outputdata_min, outputdata_min_time] = min(meanoutputdatacol); %want the min over the timeseries of the center of column
                    [outputdata_max, outputdata_max_time]= max(meanoutputdatacol); %want the max over the timeseries of the center of column
                elseif strcmpi(variable,'WEPtrack')
                    for jj=1:nCol
                         meanoutputdatacol(:,jj)=mean(outputdata(:,nProbe*(jj-1)+1:nProbe*(jj-1)+nProbe),2);
                        maxoutputdatacol(:,jj)=max(outputdata(:,nProbe*(jj-1)+1:nProbe*(jj-1)+nProbe),[],2); % we lose specific sensor information, but oh well...
                        minoutputdatacol(:,jj)=min(outputdata(:,nProbe*(jj-1)+1:nProbe*(jj-1)+nProbe),[],2);
                    end
                    % want the worst data and sensors on each column
                    outputdata=[maxoutputdatacol minoutputdatacol];
                    [outputdata_min, outputdata_min_time] = min(minoutputdatacol); 
                    [outputdata_max, outputdata_max_time]= max(maxoutputdatacol);
                end
                OutS.(variable).([runPrefix RunNumS]).Data = [ max(outputdata,[],2) min(outputdata,[],2)]; %find the time series of instantaneous max's and mins over all 12 points (just the positives) 
                OutS.(variable).([runPrefix RunNumS]).time = t;  %% ONLY USED FOR PLOTTING -> Should remove!
                OutS.(variable).([runPrefix RunNumS]).Mean = mean(meanoutputdatacol);
                OutS.(variable).([runPrefix RunNumS]).Std = std(meanoutputdatacol);
                OutS.(variable).([runPrefix RunNumS]).Min = outputdata_min; % min's of all tracking points
                OutS.(variable).([runPrefix RunNumS]).Max = outputdata_max; % max's of all tracking points
                OutS.(variable).([runPrefix RunNumS]).MinTime = t(outputdata_min_time);
                OutS.(variable).([runPrefix RunNumS]).MaxTime = t(outputdata_max_time);
            end
            clear x t AnEffT
        else
            % you didn't find the outputs so make an error log
            
            OutS.(variable).([runPrefix RunNumS])=nan;
                OutS.(['Max' variable]).([runPrefix RunNumS])=nan;
                OutS.([variable 'XY']).([runPrefix RunNumS])=nan;
                OutS.([variable 'RXY']).([runPrefix RunNumS])=nan;
            if exist([rundir, runPrefix RunNumS '\Error_log.txt'],'file')
                fid=fopen([rundir, runPrefix RunNumS '\Error_log.txt']);
                error_log=fgetl(fid);
                fclose(fid);
            else
                error_log=['variable: ' variable ' does not exist'];
            end
            if var_i==1
                warning(['Cannot find ' RunNumS '-' variable ', Error log=' error_log])
            end
        end
    end
    clear output*
end

end