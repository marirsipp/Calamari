function BB = getBB(rundir,runtype,varname,iExtract,varargin)
isave = 1;
iseps = strfind(rundir,filesep);
maindir = rundir(1:iseps(end-1));
bbdir = [maindir 'Fatigue' filesep];
outfile = 'outputs.mat';
StartTime = 20;
FreqLim = [.01 5]; %[Hz]
if ~exist(bbdir,'dir')
    mkdir(bbdir);
end
bbfile = [bbdir runtype '_BB.mat'];

switch runtype
    case 'FASTRAO'
        if nargin<5
            Wave_Seed = nan;
        else 
            if isstr(varargin{1})
                dot4file = varargin{1};
                Wave_Seed = 0;
            elseif isnumeric(varargin{1})
                Wave_Seed = 1;
            end
        end
    case {'WIR','TurbWIR' }
        Wave_Seed = nan;
        if nargin<5
            CutInTime = nan;
        else
            CutInTime = varargin{1};
        end
end

if iExtract || ~exist(bbfile,'file')
    files=dir(rundir);
    nFile = 0;
    if Wave_Seed ~=0
        for jj=1:length(files)
            jname=files(jj).name;
            matchstr=regexp(jname,['[a-zA-Z]+' runtype],'match'); % grab the letters
            iMatch = 0;
            if isempty(matchstr)
                matchstr=regexp(jname,[runtype '[a-zA-Z]+'],'match');
            end
            if ~isempty(matchstr)
                 iMatch =1;
                 % we have a very specific naming convention
                 runnums = regexp(jname,'\d*','match'); % wavedir, wavetp; wavehs
                 switch runtype
                     case 'FASTRAO'
                         TpL = 3;
                         wavedirtp = runnums{1};
                         dir1 = str2double(wavedirtp(1:TpL)); % head
                         dir1name = 'Wave_Dir';
                         dir2 = str2double(wavedirtp(TpL+1:end)); % Tp
                         dir2name = 'Wave_Tp';
                         dir3 = str2double(runnums{2}); % Hs
                         dir3name = 'Wave_Hs';
                         disp(sprintf('Found %s RAO file with Hs = %2.1f, Tp = %2.1f, and Wave Dir = %d.',jname,dir3,dir2,dir1));
                     case {'WIR','TurbWIR' }
                         if length(runnums)==2
                            dir1 = str2double(runnums{1}); % head
                            dir1name = 'Wind_Dir';
                            dir2 = str2double(runnums{2})/10; %
                            dir2name = 'Wind_Speed';
                            dir3 = nan;
                            dir3name = 'foo';
                            disp(sprintf('Found %s WIR file with WS = %2.1f and Wind Dir = %d.',jname,dir2,dir1));
                         elseif length(runnums) ==3
                             % include TI somehow
                         end

                 end

             end

            matfile=[rundir jname filesep outfile];
            if exist(matfile,'file') 
                iFound =1 ;
            else
                iFound = 0;
            end
            if iFound && iMatch
                disp(['Loading ' matfile])
                Outputs = load(matfile);
                Outnames = fieldnames(Outputs);
                if sum( cellfun( @(s) ~isempty(strfind(s,varname)), Outnames  ) )
                    nFile = nFile +1;
                     % put environmental conditions in structure
                     BB(nFile).(dir1name) = dir1;
                     BB(nFile).(dir2name) = dir2;
                     BB(nFile).(dir3name) = dir3;
                    %% CUT IN TIME is TOO SHORT -> TRANSIENTS STILL OCCURRING!
                    if ~isnan(CutInTime)
                        tin = CutInTime;
                    else
                        tin = Outputs.CutInTime;
                    end
                    tout = Outputs.CutOutTime;
                    iout = Outputs.time>= tin & Outputs.time<=tout;
                    time = Outputs.time(iout);
                    timeseries =  Outputs.(varname)(iout,:);
                    
                    % TIME
                    dt=time(2)-time(1);
                    Fs = 1/dt; % [1/s] = Hz
                    [npts,nD] = size(timeseries);
                    inrange = ceil((npts+1)/2); %range of frequency
                    fr = (1:inrange)*Fs/npts; %frequency
%                     delfr=diff(fr);
%                     nFr = length(fr);
                    %BB(nFile).time = time;
                    switch runtype
                        case 'FASTRAO'
                            if Wave_Seed>0
                                [FreqIn,PSDin] = SpecDen(time,Outputs.waveel(iout,:),100);
                                BB(nFile).InputFreq = FreqIn;
                                BB(nFile).InputPSD = PSDin;
                            end
                        case {'WIR','TurbWIR' }
                                hhname = dir([rundir jname filesep '*.hh']);
                                if isempty(hhname)
                                    disp(['Cannot find hh file in WIR folder: ' jname])
                                else
                                    hhfile = [rundir jname filesep hhname.name];
                                    [twind,wind,winddir]  = readHH(hhfile);
                                    %wind = interp1(twind-StartTime,windspd,time); % hard-coded StartTime!!
                                    iout2 = twind-StartTime>= tin & twind-StartTime<=tout;
                                    twindspd = twind(iout2);
                                    windspd = wind(iout2);
                                    [FreqIn,PSDin]=SpecDen(twindspd,windspd,100);
                                end

                    end
                    % let's just take the One-sided PSD of the stress
                    [FreqOut,PSDout]=SpecDen(time,timeseries,100);
                    iFreq = FreqOut >= FreqLim(1) & FreqOut <= FreqLim(2);
                    BB(nFile).OutputFreq = FreqOut(iFreq);
                    BB(nFile).(varname) = PSDout(iFreq,:);
                end
                clear('Outputs')
            end
        end
    else
        %load .4
        if ~exist(dot4file,'file')
            dot4file = writeDot4Files(rundir,runtype,'TWR');
        else
            disp(['Found ' dot4file])
        end
        waveHstr =  regexp(dot4file,'_\d*m','match');
        waveH = str2double(  regexp(waveHstr{:},'\d','match') );
        fid = fopen(dot4file,'r');
        dummy = fgetl(fid);
        dot4data = textscan(fid,'%f %f %d %f %f %f %f');
        fclose(fid);
        nDof = 6;
        nFiles = length(dot4data{1})/nDof;
        for ii = 1:nFiles
            i1 = (ii-1)*nDof + 1;
            i2 = ii*nDof;
            BB(ii).Wave_Tp = dot4data{1}(i1);
            BB(ii).Wave_Dir = dot4data{2}(i1);
            BB(ii).Wave_Hs = waveH;
            twrbb = dot4data{4}(i1:i2);
            BB(ii).basebend = twrbb'; % already in the freq domain
            BB(ii).InputFreq = 1./BB(ii).Wave_Tp;
        end
    end
    if isave
        save(bbfile,'BB')
    end
else
    disp(['Found processed BaseBend file: ' bbfile])
    load(bbfile);
end
end

function [twind,windspd,winddir] = readHH(hhfile)
ndata=8;

if ~exist(hhfile,'file')
    error('.hh file does not exist')
end
fid=fopen(hhfile,'r+');

comments='!';
jj=0;
while strcmp(comments(1),'!')
    jj=jj+1;
    cpos1=ftell(fid);
    comments=fgetl(fid);
    preamble{jj}=comments;
end
preamble=preamble(1:end-1);
%go back to the beginning of the data
fseek(fid,cpos1,'bof');
fmtd=repmat('%f',[1 ndata]);
fdata = textscan(fid,fmtd);
fclose(fid);
twind = fdata{1};
windspd = fdata{2};
winddir = fdata{3};
wwindspd = fdata{4};
end