function dot4file = writeDot4Files(rundir,varargin)
%% Description
% Input a run folder with a bunch of completed RAO runs
% generate a .4 file that can be used to easier visualize results
% need to use RunOF function suite to generate RAO runs
%% Preamble
% Written by Sam Kanner, with snippets from Alan Lum's OrcaFlexRAOs codes
% Copyright Principle Power Inc., 2016
if ~strcmp(rundir(end),filesep)
    rundir = [rundir filesep];
end
islashes=strfind(rundir,filesep);
raodir=[rundir(1:islashes(end-1)) 'RAOs' filesep];
if ~exist(raodir,'dir')
    mkdir(raodir)
end
outfile = 'outputs.mat';
if nargin==1
    raostr='RAO';
    rnastr='';
    iType=1;
elseif nargin==2
    raostr=varargin{1};
    rnastr='';
    iType=1;
elseif nargin==3
    raostr='RAO';
    rnastr=varargin{2};
    iType=1;
elseif nargin==4
    raostr='RAO';
    rnastr=varargin{2};
    iType=varargin{3};  
else
    raostr=varargin{1};
    rnastr='';
end
%% Find the RAO families and the specific runs per each RAO family
files=dir(rundir);
RAOnames=cell(1,1);
fnames=cell(1,2);
allheadings=nan(1,2);
allperiods=nan(1,2);
allheights=nan(1,2);
nruns=nan(1);
nRAO=0;
for jj=1:length(files)
    jname=files(jj).name;
    matchstr=regexp(jname,['[a-zA-Z]+' raostr],'match');
    if cellfun(@(c) isempty(c),matchstr)
        matchstr=regexp(jname,[raostr '[a-zA-Z]+'],'match');
    end
    if cellfun(@(c) ~isempty(c),matchstr)
         % we have a very specific naming convention for RAO runs, see
        % getRAORunList in RunOF_BATCH 
        % raostr sprintf('%s%03d%03d_%dm',RAORunList.Runname(1:end-1),round(headinglist(ii)),round(periodlist(ii)),round(RunListX(jj).Wave_Hs));
        celli=strcmp(matchstr{1},RAOnames);
        istr=strfind(jname,matchstr{1})+length(matchstr{1});
        dirL=3; TpL=3; HsL=1; TpD=10;
        if length(jname(istr:end))<9
            TpL=2;
            TpD=1;
        end
        pointr=istr;
        jhead=str2double(jname(pointr:pointr+dirL-1));
        if isnan(jhead)
            error(['Incorrect naming convention for RAO run for run named: ' jname])
        end
        pointr=pointr+dirL;
        jTp=str2double(jname(pointr:pointr+TpL-1))/TpD;
        if isnan(jTp)
            error(['Incorrect naming convention for RAO run for run named: ' jname])
        end
        pointr=pointr+TpL+1;
        jHs=str2double(jname(pointr:pointr+HsL-1));
        if isnan(jHs)
            error(['Incorrect naming convention for RAO run for run named: ' jname])
        end 
        disp(sprintf('Found %s RAO file with Hs = %2.1f, Tp = %2.1f, and Wave Dir = %d.',jname,jHs,jTp,jhead));
        if isempty(celli)
            % you have found the very first RAO file
            nRAO=nRAO+1;
            nrow=nRAO;
            nruns(nrow)=1;
            ncol=1;
        elseif sum(celli)==0
            % you have found a new RAO family
            nRAO=nRAO+1;
            nrow=nRAO;
            nruns(nrow)=1;
            ncol=1;
        elseif sum(celli)>0
            % you found a new run in an existing family.
            nrow=logical(celli);
            nruns(nrow)=nruns(nrow)+1;
            ncol=nruns(logical(celli));
        end
        RAOnames{nRAO,1}=matchstr{1};
        fnames{nrow,ncol}=jname;
        allheadings(nrow,ncol)=jhead;
        allperiods(nrow,ncol)=jTp;
        allheights(nrow,ncol)=jHs;           
    end
end
nRAOs=length(RAOnames); %number of families

%% Write the Dot4!!
for jj=1:nRAOs
    iuse=allheights(jj,:)~=0;
    nonZheights=allheights(jj,iuse);
    uHs=unique(nonZheights);
    % loop on the unique values of the wave heights
    for height=uHs
        % WAMIT RAO sort by period first
        [foo,iP]=sort(allperiods(jj,:)); % sort by period
        ijh=find(allheights(jj,iP)==height); % indices with matching wave heights for a given RAO family
        %periods=allperiods(jj,ijh); %row vector containing all periods for a given wave height, RAO family
        %headings=allheadings(jj,ijh);%row vector containing all wave headings for a given wave height, RAO family
        RAO = zeros(length(ijh)*6,7); % Dot4 file = Period Heading DOF ModRAO PhRAO ReRAO ImRAO
        is=1;
        for kk=1:length(ijh)
            ijkh=ijh(kk);
            kperiod=allperiods(jj,iP(ijkh));
            kheading=allheadings(jj,iP(ijkh));
            %write beginning of RAO columns
            RAO(is:is+5,1)=kperiod.*ones(6,1);
            RAO(is:is+5,2)=kheading.*ones(6,1);
            RAO(is:is+5,3)=transpose(1:6);
            
            % Get Data
            jkname=fnames{jj,iP(ijkh)};
            matfile=[rundir jkname filesep outfile];
            if kk==1
                optfiles = dir([rundir jkname filesep '*.opt']);
                if ~isempty(optfiles)
                    OPTfile=optfiles(1).name;
                    [Ptfm,Wind,Wave,Cur,General,Turbine,Results]=generateInputListfromOPT([rundir jkname filesep OPTfile]);
                    [foo,datfile,dotdat]=fileparts(Ptfm.datfile);
                else
                    datfile='';
                end
            end
            disp(sprintf('Loading outputs.mat file with Hs = %2.1f, Tp = %2.1f, and Wave Dir = %d.',height,kperiod,kheading));
            load(matfile);
            if isempty(rnastr)
                raodata=motions;
            elseif strcmp(rnastr,'TWR')
                raodata= TwrBsMtRNA; % bingbin wants TwrBsMtRNA(:,1:6) 
            elseif strcmp(rnastr,'RNA')
                try
                    raodata=accelRNA; % accel rel to g!!
                catch
                    raodata=accelHubH;
                end
            elseif strcmp(rnastr,'KEEL')
                raodata = KEELtrack;
                    
            end
            % TIME
            dt=time(2)-time(1);
            Fs = 1/dt;
            [npts,nD] = size(raodata);
            inrange = ceil((npts+1)/2); %range of frequency
            f = (0:inrange-1)*Fs/npts; %frequency
            % WAVE EL
            fftIn = fft(waveel);
            [fmax,imax]=max(abs(fftIn(1:inrange)));
            freq=f(imax); % dominant wave frequency -> should i just get it from the wave comp??
            Tp=1./freq;
            [foo, idx] = min(abs(f-freq)); %find closest data point to freq
            switch iType
                case 1
                     % from alan's RAO: take fft of motions
                    fftm=fft(raodata,[],1);
                    % MODULUS  
                    RAO(is:is+nD-1,4)=transpose( abs(fftm(idx,:)) ./ repmat(abs(fftIn(idx)),[1 nD]) );
                    if ~strcmp(rnastr,'TWR') &&  ~strcmp(rnastr,'KEEL')
                        RAO(is+nD-3:is+nD-1,4)=RAO(is+nD-3:is+nD-1,4).*pi/180;
                    end
                    %PHASE
                    RAO(is:is+nD-1  , 5) =transpose(AngleShift( (angle(fftm(idx,:))-angle(fftIn(idx))).*180/pi ));
                case 2
                    %Input: a,b low pass; a2, b2: high pass
                    norder=4;
                    Wn=dt/((Tp-.1*Tp)/2);
                    [b,a] = butter(norder,Wn); %Low pass 
                    Wn2=dt/((Tp+.1*Tp)/2);
                    [b2,a2] = butter(norder,Wn2,'high');

                    waveel_tmp = FiltFiltM(b,a,waveel); 
                    waveel_filt= FiltFiltM(b2,a2,waveel_tmp);
                    [waveAmp,wavePh,waveT,wXd]=getFStats(time,waveel_filt,0);
%                     if mean(waveT)>1.2*Tp || mean(waveT)<.8*Tp
%                         plot(time,waveel,time,waveel_filt,time(wXd(1).iMax),wXd(1).iMax,time(wXd(1),iMin),wXd(1).Min)
%                         error('Check your filtered signal')
%                     end
                    % MOTIONS
                    raodata_tmp = FiltFiltM(b,a,raodata);
                    raodata_filt = FiltFiltM(b2,a2,raodata_tmp);
                    [raoAmp,raoPh,raoT,rXd]=getFStats(time,raodata_filt,0);
%                     if mean(raoT)>1.1*Tp || mean(raoT)<.9*Tp
%                         for ii=1:size(raodata,2)
%                             plot(time,raodata,time,raodata_filt,time(rXd(ii).iMax),rXd(ii).iMax,time(rXd(ii).iMin),rXd(ii).Min)
%                         end
%                         error('Check your filtered signal')
%                     end
                    % MODULUS   
                    %RAO(is:is+5,4)=transpose( abs(fftm(idx,:)) ./ repmat(abs(fftIn(idx)),[1 6]) );
                    RAO(is:is+nD-1,4)=transpose( raoAmp./ repmat(waveAmp,[1 nD]) );
                    if ~strcmp(rnastr,'TWR') &&  ~strcmp(rnastr,'KEEL')
                        RAO(is+nD-3:is+nD-1,4)=RAO(is+nD-3:is+nD-1,4).*pi/180;
                    end
                    %PHASE
                    %RAO(is:is+5  , 5) =AngleShift( (angle(fftm(idx,:))-angle(fftIn(idx))).*180/pi );
                    RAO(is:is+nD-1  , 5) =raoPh-wavePh*360/Tp ;
            end
            %RE
            RAO(is:is+nD-1,6)= RAO(is:is+nD-1,4) .* cos( RAO(is:is+nD-1,5).*pi/180 ) ; 
            %IMAG
            RAO(is:is+nD-1,7)= RAO(is:is+nD-1,4) .* sin( RAO(is:is+nD-1,5).*pi/180 ) ; 
            is = is + 6;
        end
        
        dot4file=sprintf('%s%s%s_%dm_%s.4',raodir, RAOnames{jj,1} ,rnastr, round(height),datfile );
        %fid = fopen([RAOnames{jj,1} '_' num2str(hs), 'm_' datfilename '.4'],'w');
        fid = fopen(dot4file,'w'); % OVERWRITE!!
        fprintf(fid,'heading dummy line\n');
        fprintf(fid,'%0.7E %0.7E %d % 0.7E % 0.7E % 0.7E % 0.7E\n' ,RAO');
        fclose(fid);
        disp(['Successfuly extracted  RAO ' rnastr ' data for ' RAOnames{jj,1} ' and saved to ' dot4file])
    end
end

end