function RunOF_BATCH(varargin)
% Inputs: xlsfile (string) representing the FULL location of the DLC
% spreadsheet
% nProc (integer, optional) represents the number of processors (MATLAB
% windows) you want to open. If nProc=1, then no new MATLAB instances are open. 

if nargin<1 || isempty(varargin{1})
    [FileName,PathName]=uigetfile('.xlsx');
    xlsfile=[PathName FileName];
else
    xlsfile=varargin{1};
end

if nargin<2 || isempty(varargin{2})
    nProc= str2num(getenv('NUMBER_OF_PROCESSORS'));
else
    nProc=varargin{2};
end
if nargin<3
    nSheets=inf;
else
    nSheets=varargin{3};
end
[RunInfo,RunList]= readRunList(xlsfile,nSheets);
Runname_special={'RAOs','FDecays','FExcrns','Shtdwns'};
RunList = arrayfun(@(s) setfield(s,'Date',date),RunList); % add todays date into the RunList array
%get rid of NaNs in the Runnames
notnan=cellfun(@(V) any(~isnan(V(:))), {RunList.Runname});
RunList=RunList(notnan);
[iSel,ok]=listdlg('ListString',{RunList.Runname},'Name','Select runnames to RunOF','PromptString','Run names:','ListSize',[240 300]);
foodir=userpath;
userdir=[foodir(1:end-1) filesep];
if ok
%if size(input_list,2) == nargin('RunOF')
    RunListUX=RunList(iSel);
    iRAO=0;
    iFD=0;
    %break up the RAO or Free Decay run into a longer list
    if isfield(RunList,'Runname')
        celliRAO=strfind({RunListUX.Runname},Runname_special{1});
        ifRAO=find(cellfun(@(s) ~isempty(s), celliRAO));
        if ~isempty(ifRAO)
            iRAO=1;
            RunListUX=getRAORunList(RunListUX,Runname_special{1});
        end
        iFD=[];
        for pp=2:length(Runname_special)
            iFD=getSpecialIdx(iFD,{RunListUX.Runname},Runname_special{pp});
        end
%         celliFD=strfind({RunListUX.Runname},Runname_special{2});
%         celliFE=strfind({RunListUX.Runname},Runname_special{3});
%         celliFE=strfind({RunListUX.Runname},Runname_special{4});
%         ifFD=find(cellfun(@(s) ~isempty(s), celliFD));
%         ifFE=find(cellfun(@(s) ~isempty(s), celliFE));
%         iFD=sort([ifFD ifFE]);
        if ~isempty(iFD)
            iFD=1;
            RunListUX=getFDFELDRunList(RunInfo,RunListUX,Runname_special{2},Runname_special{3},Runname_special{4});
        end
    end
    %break up Fatigue run into single seeds (diagonally, that is Wind_Seed
    %and Swell_Seed change along with Wave_Seed)
    if isfield(RunListUX,'Wave_Seed') 
        Wave_Seed_Ls=cellfun(@(s) length(s), {RunListUX.Wave_Seed});
        if max(Wave_Seed_Ls)>1
            RunListUX=getFatRunList(RunListUX);
        end
    end
    
    % get the proper version of OrcaFlex ready
    Cofxdir=which('ofx'); % this will be on the matlabpath
    iOF=strfind(Cofxdir,'OrcaFlex');
    baseAPIdir=Cofxdir(1:iOF+length('OrcaFlex'));
    %endAPIdir=Cofxdir(iOF+length('OrcaFlex')+1:iOFseps(end)-1);
    ofxdirs=rdir(baseAPIdir,'regexp(name,[''\.''],''match'') ');
    % you may have multiple versions of OrcaFlex installed on your PC
    ofxvers86=str2double(regexp([ofxdirs.name],['\d+\.\d*'],'match'));
    ofxvers=ofxvers86(ofxvers86~=86);
    %iseps=strfind(ofxdirs(1).name,filesep);
    %ofxvers= arrayfun(@(s) str2double(s.name(iseps(end)+1:end)),ofxdirs);
    if sum(isnan(ofxvers))
        error('oh shit you somehow have orcaflex versions with different pathnames?')
    end
    %choose the max version
    latestofx=max(ofxvers);
    oldestofx=min(ofxvers);
    % default is to use oldest OrcaFlex version
    writeregWin('HKEY_LOCAL_MACHINE' ,'Software\WOW6432Node\Orcina\OrcaFlex\Installation Directory','Normal', [baseAPIdir sprintf('%1.1f',oldestofx) filesep]);
    if isfield(RunListUX(1),'Datfile')
        iFlex=~isempty(strfind(RunListUX(1).Datfile,'Flexible'));
    else
        iFlex=0;
    end
    verNum=1.0;
    if isfield(RunInfo,'OrcaFlexVer')
        verNum= str2double(regexp(RunInfo.OrcaFlexVer,['\d+\.\d*'],'match'));
        if isempty(verNum)
            verNum=str2double(regexp(RunInfo.OrcaFlexVer,['\d*'],'match'));
        end
    end
    if ~isempty(strfind(xlsfile,'Flexible')) || ~isempty(strfind(xlsfile,'flexible')) || ~isempty(strfind(RunInfo.Datfile ,'Flexible')) || iFlex || verNum >= 10.0
        writeregWin('HKEY_LOCAL_MACHINE' ,'Software\WOW6432Node\Orcina\OrcaFlex\Installation Directory','Normal', [baseAPIdir sprintf('%1.1f',latestofx) filesep])
    end
    nUX=length(RunListUX);
    nProc=min([nProc nUX]);
    nK=round(nUX/nProc);
    iK=1;
    for kk=1:nProc
        jK=iK+nK-1;
        if kk==nProc && iK<=nUX
            jK=nUX;
        end
        if jK<=nUX
            disp(sprintf('Matlab Window #%d = Run %s until Run %s',kk,RunListUX(iK).Runname,RunListUX(jK).Runname))
            RunListX=RunListUX(iK:jK);
            RunInfoX=RunInfo; % all windows have same RunInfo, right?
            matname=sprintf('foo%d.mat',kk);

            fullmatname=[userdir matname];
            save(fullmatname,'RunInfoX','RunListX')
            %if nProc>1
                runstr=sprintf('!matlab -nodesktop -nosplash /r "RunOF_Queue(\''%s\'')" &',fullmatname); % need to open a new MATLAB for HEX KEY to load properly
                eval(runstr)
            %else
            %    RunOF_Queue(fullmatname);
            %end
        end
        iK=jK+1;
        disp('Waiting for MATLAB window to open...')
        pause(1)
    end

%end
%     if General.iFat && nruns>1
%         PostFat([General.MainFolder General.RunFolder]);
%     end

    disp('Waiting until all simulations have launched...')
    foofiles=dir([userdir 'foo*']);
    cardinals={'first','second','third','fourth','fifth','sixth','seventh','eighth','ninth','tenth'};
    for jj=1:length(foofiles)
    %     if nProc>1
        if nProc>1
            nsec=10;
        else
            nsec=10;
        end
        while nsec>0
            disp(sprintf('Removing temporary file for %s launch in %d seconds ',cardinals{jj},nsec))
            pause(1)
            nsec=nsec-1;
        end
        delete([userdir foofiles(jj).name]);
    %     else
    %         delete([userdir foofiles(jj).name]);
    %     end
    end
    if iRAO
        %run the post-processor for RAOs to create the .4 file
        disp('You just ran some RAOs. Remember to run "writeDot4files" after they are done.')
        %rundir = uigetdir(userdir, 'Select Run folder to post-process RAO results');
        %dot4file = writeDot4Files(rundir);
        % then use comparev4 to plot results
    end
end
end

function iFout=getSpecialIdx(iFin,RunnameCell,specialName)
celliF=strfind(RunnameCell,specialName);
iFf=find(cellfun(@(s) ~isempty(s), celliF));
iFout=sort([iFin iFf]);
end
function RunListX=getFatRunList(RunList)
WindSeeds={'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T'};
WS_L=cellfun(@(s) length(s), {RunList.Wave_Seed});
iStrength=WS_L<=1;
iFat=WS_L>1;
RunListU=RunList(logical(iStrength));
FatRunList=RunList(logical(iFat));
nFat=sum(iFat);
if isempty(RunListU)
    iList=0;
else
    iList=length(RunListU);
end
RunListX=RunListU;
varnames=fieldnames(FatRunList);
for ii=1:nFat
    nSeed=length(FatRunList(ii).Wave_Seed);
    for nn=1:nSeed
        jj=iList+nn;       
        %set all variables as default
        for pp=1:length(varnames)
            RunListX(jj).(varnames{pp})=FatRunList.(varnames{pp});
        end
        %Overwrite name
        RunListX(jj).Runname=sprintf('%s%02d',FatRunList(ii).Runname,nn);
        RunListX(jj).Wave_Seed=nn;
        if isfield(RunListX,'Swell_Seed')
            RunListX(jj).Swell_Seed=nn;
        end
        if isfield(RunListX,'Wind_Seed')
            RunListX(jj).Wind_Seed=WindSeeds{nn};
        end
    end
    iList=iList+nSeed;
end
end
function RunListX=getFDFELDRunList(RunInfo,RunList,runstr1,runstr2,runstr3)

if isfield(RunInfo,'X_des')
    [nXdes,nDOF]=size(RunInfo.X_des);
    [nXrow,nXcol]=find(~isnan(RunInfo.X_des));
    nX=zeros(nXdes,1);
    for ii=1:nXdes
        nX(ii)=nDOF-sum(isnan(RunInfo.X_des(ii,:)));
    end
else
    nDOF=6;
    nX=nDOF;
    nXrow=ones(1,nDOF);
    nXcol=1:nDOF;
end
if isfield(RunInfo,'F_des')
    [nFdes,nFdof]=size(RunInfo.F_des); % can foo be >1 ??
    [nFrow,nFcol]=find(~isnan(RunInfo.F_des));
    nF=zeros(nFdes,1);
    for ii=1:nFdes
        nF(ii)=nFdof-sum(isnan(RunInfo.F_des(ii,:)));
    end
    nFexc = nFdof;
else
    nFdes=1;
    nFrow=ones(1,nDOF);
    nFcol=1:nDOF;
    nF=nDOF;
    nFexc = nDOF;
end
% if isfield(RunInfo,'LD_ratio')
%     nLD=~isnan(RunInfo.LD_ratio);
% else
%     nLD=ones(1,nDOF);
% end
if isfield(RunList,'Runname')
    celliFD=strfind({RunList.Runname},runstr1);
    celliFE=strfind({RunList.Runname},runstr2);
    celliSh=strfind({RunList.Runname},runstr3);
    ifFD=cellfun(@(s) ~isempty(s), celliFD);
    ifFE=cellfun(@(s) ~isempty(s), celliFE);
    ifSh=cellfun(@(s) ~isempty(s), celliSh);
    iFD=ifFD | ifFE | ifSh;
    nFD= ~ifFD & ~ifFE & ~ifSh;

    FDRunList=RunList(logical(iFD));
    RunListU=RunList(logical(nFD)); % don't need to preserve order of RunList
    % Get total number of new runs
    niFD=sum(ifFD); % number of free-decays you want to run (could be different datfile)
    nRunsFD=niFD*sum(nX);
  
    iSDE=find(ifSh);
    nSDE=length(iSDE);% number of shutdowns you want to run (could be Flex or FAST)
    nRunsSh=0;
    nWindDir=0;
    SDERunList=RunList(iSDE);
    for pp=1:nSDE
        SDERunListP=RunList(iSDE(pp));
        % Make list of wind headings
        if isfield(RunList,'Wind_Dir')
            WindDirs=SDERunListP.Wind_Dir;
            nWindDir(pp)=length(WindDirs);
            nRunsSh=nRunsSh+nWindDir(pp);
        end
    end
    
    niFE=sum(ifFE); % number of force excursions you want to run (could be different datfile)
    nRunsFE=niFE*2*sum(nFexc); % 2= + and - for each DOF
    % create new runlist
    RunListX=RunListU; 
%     %% add the beginning of RunList
%     for ii=1:length(RunListI)
%         RunListX(ii)=RunListI(ii);
%     end
    if isempty(RunListU)
        iList=0;
    else
        iList=length(RunListU);
    end
    varnames=fieldnames(FDRunList);
    %% Modify RunList - Free Decay
    for ii=1:nRunsFD
        %iDOF=mod(ii-1,max(DOFs))+1;
        jj=iList+ii;       
        %set all variables as default
        for pp=1:length(varnames)
            RunListX(jj).(varnames{pp})=FDRunList.(varnames{pp});
        end
        %Overwrite name
        RunListX(jj).Runname=sprintf('FDecay%d_%d',nXcol(ii),nXrow(ii));
    end
    iList=iList+nRunsFD;
    %% Modify RunList - Force Excursion
    for ii=1:nRunsFE/2
        %iDOF=mod(ii-1,max(DOFs))+1;
        jj=iList+2*ii-1;       
        %set all variables as default
        for pp=1:length(varnames)
            RunListX(jj).(varnames{pp})=FDRunList.(varnames{pp});
            RunListX(jj+1).(varnames{pp})=FDRunList.(varnames{pp});
        end
        %Overwrite name
        if max(nFrow)>1
            RunListX(jj).Runname=sprintf('FExcrn%d_%d-',nFcol(ii),nFrow(ii));
            RunListX(jj+1).Runname=sprintf('FExcrn%d_%d+',nFcol(ii),nFrow(ii));  
        else
            RunListX(jj).Runname=sprintf('FExcrn%d_-',nFcol(ii));
            RunListX(jj+1).Runname=sprintf('FExcrn%d_+',nFcol(ii));
        end
    end
    iList=iList+nRunsFE;
    %% Modify RunList - Shutdown
    for ss=1:nSDE
        for ww=1:nWindDir(ss)
            iList=iList+1;      
            WindDirs = SDERunList(ss).Wind_Dir;
            %set all variables as default
            for pp=1:length(varnames)
                RunListX(iList).(varnames{pp})=SDERunList(ss).(varnames{pp});
            end
            %Overwrite wind
                RunListX(iList).Wind_Dir=WindDirs(ww);
            %Overwrite name
            iShstr=strfind(SDERunList(ss).Runname,runstr3)+length(runstr3);
            RunListX(iList).Runname=sprintf('Shtdwn%d%s',WindDirs(ww),SDERunList(ss).Runname(iShstr:end));
        end
    end
    %iList=iList+nRunsSh;
%    iList=iList+nruns;
%     %% add the end of RunList
%     for ii=1:length(RunListF)
%         RunListX(iList+ii)=RunListF(ii);
%     end
end
end
function RunListX=getRAORunList(RunList,runstr)
%change all cells of WaveDir and WaveTp to numerical and to RunList
nList=length(RunList);
if isfield(RunList,'Runname')
    % need to sum over cells
    celliRAO=strfind({RunList.Runname},runstr);
    iRAOt=find(cellfun(@(s) ~isempty(s), celliRAO));
    if min(iRAOt)>1
        RunListI=RunList(1:iRAOt(1)-1);
    else
        RunListI=[];
    end
    if max(iRAOt)<nList
        RunListF=RunList(iRAOt(end)+1:end);
    else
        RunListF=[];
    end
    RunListX=RunList;
    %% add the beginning of RunList
    for ii=1:length(RunListI)
        RunListX(ii)=RunListI(ii);
    end
    if isempty(ii)
        iList=0;
    else
        iList=ii;
    end
    for pp=1:length(iRAOt)
        iRAO=iRAOt(pp);
        RAORunList=RunList(iRAO);
        % Make list of wave headings
        if isfield(RunList,'Wave_Dir')
            headings=RAORunList.Wave_Dir;
            nWaveDir=length(headings);

        else
            nWaveDir=0;
        end
         % Make list of wave periods
        if isfield(RunList,'Wave_Tp')
            periods=RAORunList.Wave_Tp;
            nWaveTp=length(periods);
        else
            nWaveTp=0;
        end
        %create new runlist
        nruns=nWaveDir*nWaveTp;    

        %% Add in the new RAO runs
        periodlist=kron(periods,ones(1,length(headings)));
        headinglist=repmat(headings,[1,length(periods)]);
        varnames=fieldnames(RAORunList);
        for ii=1:nruns
            jj=iList+ii;
            %set all variables as default
            for pp=1:length(varnames)
                RunListX(jj).(varnames{pp})=RAORunList.(varnames{pp});
            end
            %Overwrite name
            RunListX(jj).Runname=sprintf('%s%03d%03d_%dm',RAORunList.Runname(1:end-1),round(headinglist(ii)),round(periodlist(ii)*10),round(RunListX(jj).Wave_Hs));
            %overwrite wave_dir and tp
            RunListX(jj).Wave_Dir=headinglist(ii);
            RunListX(jj).Wave_Tp=periodlist(ii);
        end
        iList=iList+nruns;
    end
    %% add the end of RunList
    for ii=1:length(RunListF)
        RunListX(iList+ii)=RunListF(ii);
    end
end
end

