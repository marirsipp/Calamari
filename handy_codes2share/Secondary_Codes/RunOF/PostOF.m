function [hooray,General]=PostOF(tempdir,resultsdir,iptFile,Ptfm,Turbine,Wind,Wave,Cur,General)
[trackpointsWEP,trackpointsCOL,trackpointsKEEL]=getTrackPts(Ptfm);
SIMname='primary';
OUTname='primary';
if strcmp(tempdir,resultsdir)
    SIMname=Turbine.Name;
    OUTname=Turbine.Name;
end
if General.OutputStatsFlag==2
    % just want to rerun stats with outputs.mat existing
    % recreate ResTable
    ResTable=recreateResTable([resultsdir 'outputs.mat']);
    Res.state=5; %successfully exit PostOF
else
    [Res,Units]=extractSIM([tempdir SIMname],Ptfm,Turbine,General,Wind,trackpointsCOL,trackpointsWEP,trackpointsKEEL);
    FAST=[];
    FUnits={};
    if Ptfm.iFAST
        [FAST,FUnits]=extractOUTB(OUTname,tempdir,Res,Ptfm,Turbine,Wind);
        if ~isfield(Res,'state')
            Res.state=99; % call it a successful run! probably ran just FAST (FAST_Flag=2). Make sure to exit successfully
        end
    end
    if Res.state~=5
        ResTable=getResTable(Res,Units,FAST,FUnits,Ptfm,Turbine,Wind,Wave,Cur,General);
    else
        ResTable=[];
    end
end

if General.OutputStatsFlag && Res.state~=5
    OutS=getResTableStats(ResTable,General.CutInTime,General.CutOutTime); % should I send in General.CutInTime for the time truncation???  can I use this in seed selection??
    save([resultsdir 'stats.mat'],'OutS');
end

switch General.OutputFlag
    case 1
        % don't need to do anything
    case 2
        % do something for post-process of the flexible model
    case 3
        datdir=[resultsdir 'Outputs' filesep]; %old way -> need to create the Outputs folder
        mkdir(datdir);
end
nvar=size(ResTable,1);
for ii = 1:nvar
    % save all variables in the ResTable to a .mat
    switch General.OutputFlag
        case 1
            varname=ResTable{ii,1};
            eval([varname ' = ResTable{ii,2}; ']); %transpose?
            Units.(varname)=ResTable{ii,3};
            if ii==1
                save([resultsdir 'outputs.mat'],varname);
            elseif ii==nvar
                save([resultsdir 'outputs.mat'],'Units','-append');
                save([resultsdir 'outputs.mat'],varname,'-append');
            else
                save([resultsdir 'outputs.mat'],varname,'-append');
            end
        case 2
            % do something for post-process of flexible model
        case 3
            if ~strncmpi(ResTable{ii,1},'lineBlade',9) || ~strncmpi(ResTable{ii,1},'lineML',6) 
                fid = fopen([datdir ResTable{ii,1} '.dat'],'w');
                fwrite(fid, ResTable{ii,2}', 'double');
                fclose(fid);
            end
    end
end

%% Write and Copy Results
if ~strcmp(tempdir,resultsdir) && General.RunFlag~=2
    % Write output files
    writeParams(resultsdir,Res,FAST,Ptfm,Turbine,Wind,Wave,Cur,General)
    optFile=writeOPT(iptFile,Res,FAST); %if run dies, OPT should be same as IPT
    status(11) = movefile(optFile, resultsdir);
    % Copy files
    if ~exist(resultsdir)
        dirsucc=mkdir(resultsdir);
    end
    outputname=Turbine.Name;
    if General.SaveSim
        status(1) = movefile([tempdir 'primary.sim'], [resultsdir, outputname, '.sim']);
    else
        disp('Save_Sim variable set to 0, not keeping OrcaFlex .sim file')
        status(1)=1;
    end
    status(2) = movefile([tempdir 'primary.dat'], [resultsdir, outputname, '.dat']);
    if Ptfm.iFAST
        status(3) = movefile([tempdir 'primary.fst'], [resultsdir, outputname, '.fst']);
        if exist([tempdir 'primary.elm'],'file')
            foo = movefile([tempdir 'primary.elm'], [resultsdir, outputname, '.elm']);
        end
        status(4) = movefile([tempdir 'primary.fsm'], [resultsdir, outputname, '.fsm']);
        status(5) = movefile([tempdir 'primary.out'], [resultsdir, outputname, '.out']);
        if ~status(5) %try binary outb if text didn't work
            status(5) = movefile([tempdir 'primary.outb'], [resultsdir, outputname, '.outb']);
        end
        status(6) = movefile([tempdir '*.sum'], resultsdir);
        status(7) = movefile([tempdir  '*_blade*'], resultsdir);
        status(8) = movefile([tempdir  '*_tower*.dat'], resultsdir);
        status(9) = movefile([tempdir 'discon.dll'], resultsdir);
        status(10) = copyfile([tempdir 'FASTlinkDLL.dll'], resultsdir);
        wndfile=dir([tempdir '*.wnd']);
        if ~isempty(wndfile)
            if ~isfield(General,'iKeepWnd')
                General.iKeepWnd=0;
            end
            if wndfile.bytes<20e6 || General.iKeepWnd
                status(11) = movefile([tempdir wndfile.name], resultsdir);
            end
        end
        hhfile = dir([tempdir '*.hh']);
        if ~isempty(hhfile)
            status(11) = movefile([tempdir hhfile.name], resultsdir);
        end
        status(12) =  movefile([tempdir '*.exe'], resultsdir); % move fast
        status(13) = movefile([tempdir '*_Ptfm.ipt'], resultsdir);
        status(14) = movefile([tempdir '*_aero.ipt'], resultsdir);
        % status(9) = movefile([tempdir '*.txt'], resultsdir);
        % delete([outputname '_blade*'],[outputname '_tower.dat']);
        
        % A relic of Alan's code, can be deleted
        if Res.state==5
            fid = fopen([resultsdir, 'Error_log.txt'],'w');
            fprintf(fid,'Simulation unstable, post-processing aborted');
            fclose(fid);
        elseif ~all(status)
            fid = fopen([resultsdir, 'Error_log.txt'],'w');
            fprintf(fid,sprintf('Error copying an input file: %d%d%d%d%d%d%d%d%d%d%d', status));
            fclose(fid);
        end
    end

    
elseif General.RunFlag==2
    % Write output files
    writeParams(resultsdir,Res,FAST,Ptfm,Turbine,Wind,Wave,Cur,General)
    optFile=writeOPT(iptFile,Res,FAST); %if run dies, OPT should be same as IPT
else
    status(15)=1;
end
if General.iLD
   %special post-process for linear damping iterations
   General=PostLD(General,Res);
end

if Res.state==5
    hooray=0;
else
    hooray=1;
end
end
function ResTable=recreateResTable(matfile)
Data=load(matfile);
varnames=fieldnames(Data);
nV=length(varnames);
ResTable=cell(nV,3);
for ii=1:nV
   ResTable{ii,1} = varnames{ii};
   ResTable{ii,2} = Data.(varnames{ii});
   [nT,nD]=size(Data.(varnames{ii}));
   ResTable{ii,3} = repmat({'m'},[1 nD]); %use Data.Units instead
end
end
function OutS=getResTableStats(ResTableFull,CutInTime,CutOutTime)
% take out lines
varnameFull={ResTableFull{:,1}};

%ilines=strncmp(varnameFull,'line',4);
resignore={'wavecomp','Units','LineType','COLtrack','TotalWEP','WEPtrack','KEELtrack','DecayForce','DecayForceTime'};
iIgnore1= strncmp(varnameFull,'line',4) ; % don't want to plot lines
iIgnore2=zeros(1,length(varnameFull));
for ii=1:length(resignore)   
    iIgnore=~cellfun('isempty',strfind(varnameFull,resignore{ii})); 
    if any(iIgnore)
        iIgnore2=iIgnore2 | iIgnore;
    end
end
%iwavecomp=strcmp(varnameFull,'wavecomp');
iremove=iIgnore1 | iIgnore2;
ResTable=ResTableFull(~iremove,:);

for ii = 1:size(ResTable,1)
    variable=ResTable{ii,1};
    if strcmp(variable,'time')
        t_temp=ResTable{ii,2};
    end 
end

t_out=min([CutOutTime max(t_temp)]); % ensure that CutOut is never greater than the runtime
t_in=CutInTime;
itrunc=t_temp>=t_in & t_temp<t_out;
t = t_temp(itrunc);
nT=length(t_temp);
for ii = 1:size(ResTable,1)
    variable=ResTable{ii,1};
    outputdata_temp=ResTable{ii,2};
    Unit=ResTable{ii,3};
    [nN,nD]=size(outputdata_temp);
    if nN==nT
        outputdata = outputdata_temp(itrunc,:); %truncate data?
    else
        outputdata = outputdata_temp;
    end
    for jj=1:nD
        if isnumeric(outputdata) && nN>1
            if nD>1
                varname=sprintf('%s%d',variable,jj);
            else
                varname=variable;
            end
            [outputk_min, outputk_min_time] = min(outputdata(:,jj),[],1);
            [outputk_max, outputk_max_time]= max(outputdata(:,jj),[],1);
            OutS.(varname).Mean=mean(outputdata(:,jj),1);
            OutS.(varname).Std=std(outputdata(:,jj),1);
            OutS.(varname).Min=outputk_min;
            OutS.(varname).Max=outputk_max;
            if nN==nT
                OutS.(varname).MinTime= t(outputk_min_time);
                OutS.(varname).MaxTime= t(outputk_max_time);
            end
            if length(Unit)==1
               OutS.(varname).Unit=Unit; 
            else
                OutS.(varname).Unit=Unit{jj};
            end
            if jj==3 && (nD==3 || nD==6)
                outputXY=sqrt(outputdata(:,1).^2 + outputdata(:,2).^2);
                OutS.([variable 'XY']).Mean = mean(outputXY);
                [outputXY_min, outputXY_min_time] = min(outputXY);
                [outputXY_max, outputXY_max_time]= max(outputXY);
                OutS.([variable 'XY']).Std = std(outputXY);
                OutS.([variable 'XY']).Min = outputXY_min;
                OutS.([variable 'XY']).Max = outputXY_max;
                if nN==nT
                    OutS.([variable 'XY']).MinTime = t(outputXY_min_time);
                    OutS.([variable 'XY']).MaxTime = t(outputXY_max_time);
                end
                OutS.([variable 'XY']).Unit= Unit{1};
            end
            if jj==6 && (nD==3 || nD==6)
                outputRXY=sqrt(outputdata(:,4).^2 + outputdata(:,5).^2);
                OutS.([variable 'RXY']).Mean = mean(outputRXY);
                [outputRXY_min, outputRXY_min_time] = min(outputRXY);
                [outputRXY_max, outputRXY_max_time]= max(outputRXY);
                %OutS.([variable 'RXY']).time = t; %% ONLY USED FOR PLOTTING -> Should remove!
                %OutS.([variable 'RXY']).Data = outputRXY; %% ONLY USED FOR PLOTTING -> Should remove!
                OutS.([variable 'RXY']).Std = std(outputRXY);
                OutS.([variable 'RXY']).Min = outputRXY_min;
                OutS.([variable 'RXY']).Max = outputRXY_max;
                if nN==nT
                    OutS.([variable 'RXY']).MinTime = t(outputRXY_min_time);
                    OutS.([variable 'RXY']).MaxTime = t(outputRXY_max_time); 
                end
                OutS.([variable 'RXY']).Unit= Unit{4};
            end
        end
    end
end
end
function optFile=writeOPT(iptFile,Res,FAST)
fid=fopen(iptFile,'r');
linen=0;
while ~feof(fid)
   linen=linen+1;
   contents{linen}=fgetl(fid); 
end
fclose(fid);
optFile=[iptFile(1:strfind(iptFile,'.')-1) '.opt'];
fid=fopen(optFile,'w+');
success=fid~=-1;
preamble{1}='!Principle Power Summary File for Simulation Using in-house OrcaFAST software v0';
headers={'!Run Summary'};
for jj=1:length(preamble)
    fprintf(fid,'%s\n',preamble{jj});
end
Data_OPT{1,1}=headers{1};
fprintf(fid,'\n%s\n',Data_OPT{1,1});
if isfield(Res,'yawfix')
    Data_OPT{2,1}=sprintf('%2.2f',Res.yawfix);
    Data_OPT{2,2}='-	Results.yawfix; Mean platform yaw rotation in fixed frame of reference [deg] (float)';
    fprintf(fid,'%-15s%-100s\n',Data_OPT{2,1},Data_OPT{2,2});
end
if isfield(FAST,'nacyaw_mean')
    Data_OPT{3,1}=sprintf('%2.2f',FAST.nacyaw_mean);
    Data_OPT{3,2}='-	Results.NacYaw_Mean; Mean nacelle yaw due to yaw controller [deg] (float)';
    fprintf(fid,'%-15s%-100s\n',Data_OPT{3,1},Data_OPT{3,2});
end

for kk=2:length(contents)
    fprintf(fid,'%s\n',contents{kk});
end
fclose(fid);
end

function General=PostLD(General,Res)
   mytime=Res.time;
   iTrunc=Res.time>=Res.CutInTime & Res.time<=CutOutTime;
   RunNumsCell=regexp(General.RunName,'\d*','match');
   RunNums=cellfun(@str2num,cat(1,RunNumsCell));
   if length(RunNums)==2
       nIter=RunNums(2);
   elseif length(RunNums)==1
       nIter=1;
   else
       error('Your naming convention for the Linear Damping RunName is weird...')
   end
   nDOF=RunNums(1);
   mydata=Res.motion(iTrunc,nDOF);
   % copied from PlotMySims
   mytime=mytime(iTrunc)-mytime(iTrunc(1));
   %mytime, mydata
   [amp,dec,T,Xm,iM,Xn,iN]=getFDecayStats(mytime,mydata,100);   
   P=polyfit(amp,dec,1);
   General.CritDamping=P(2);
   %% Criteria to determine whether to run another iteraiton
   if abs(General.CritDamping-General.DampingRatioGoal)>General.DampingRatioGoal*0.1
      General.iAgain=1;
      %write to Ptfm.xlsx file to change the linear damping values
      
   end
   % Decrement figure
    Fig{1}=figure('name', sprintf('%s Decrement, No. %d',motionNames{nDOF},nIter));
    ampX=0:.01:max(amp);
    Y=P(1)*ampX+P(2);
    plot(amp,dec,'kx',ampX,Y,'b-')
    hold on
    xlabel([motionNames{iDOF}  ' amplitude' '[' ustr ']']);
    ylabel('damping (% of critical)');
    grid on
    minY=min([floor(min(dec)) floor(P(2))]);
    maxY=ceil(max(dec));
    dY=maxY-minY;
    decaxis=[-.01 ceil(max(amp)) minY-.01*dY maxY];
    dX=decaxis(2);
    axis(decaxis)
    plot(0,P(2),'rx','markersize',8)
    rectangle('position',[0.05,P(2)-dY*.03,dX*.5,dY*.06],'facecolor','w','edgecolor','k')
    text(0.1,P(2),sprintf('Zero-Amplitude Damping = %2.1f',P(2)));
    hold off
end
function [FAST,Units]=extractOUTB(OUTname, tempfolder,Res,Ptfm,Turbine,Wind)
    %[mass_active_ballast(1),mass_active_ballast(2),mass_active_ballast(3)] = CalBallastWeight(Rotate2DMat(static_heel, (Wind.Dir-Res.yawfix)*pi/180),[Ptfm.Col.Lh*2/3 0],[-Ptfm.Col.Lh*1/3 Ptfm.Col.L/2],[-Ptfm.Col.Lh*1/3 -Ptfm.Col.L/2],Wta);
oname=[tempfolder OUTname ];
f=dir([oname '.out*']);
    %% Read FAST output and format properly results
if f(1).bytes
    foutb=dir([oname '.outb']);
    fout=dir([oname '.out']);
    if foutb.bytes %Preferably read FAST binary output if exists
        [FAST_out, headers, units] = ReadFASTbinary([oname '.outb']);
    elseif fout.bytes %Assuming some output exists, txt format
        fid = fopen([oname '.out']);
        for i = 1:6
            [~]=fgets(fid);
        end
        headers = textscan(fgets(fid), '%s');
        headers = headers{1};
        units = textscan(fgets(fid),'%s');
        units = units{1};
        ncol = length(headers);
        col_end = ncol; % number of output columns we actually need
        FAST_out = fscanf(fid, [repmat('%g ', [1,col_end]), repmat('%*g ', [1,ncol-col_end])], [col_end, inf])'; %reading less data doesn't save time! but saves space
        fclose(fid);    
    end
    timevar='Time';
    FAST.time = FAST_out(:,ismember(headers,timevar));
    Units.time=strrep(strrep(units(ismember(headers,timevar)),'(',''),')','');
    accelvar={'PtfmTAxi';'PtfmTAyi';'PtfmTAzi';'PtfmRAxi';'PtfmRAyi';'PtfmRAzi'};
    [tf,loc] = ismember(headers,accelvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.accel = FAST_out(:,idx);
    Units.accel=strrep(strrep(units(ismember(headers,accelvar)),'(',''),')','');
    thrustvar={'LSShftFxs';'LSShftFys';'LSShftFzs';'LSShftMxs';'LSSGagMys';'LSSGagMzs'};
    [tf,loc] = ismember(headers,thrustvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.thrustraw = FAST_out(:,idx) * 1000; % in kN, convert to N
    Units.thrust=transpose(strrep(strrep(strrep(units(ismember(headers,thrustvar)),'(',''),')',''),'k','')); % convert to N

    motvar={'PtfmSurge';'PtfmSway';'PtfmHeave';'PtfmRoll';'PtfmPitch';'PtfmYaw'};
    [tf,loc] = ismember(headers,motvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.mot = FAST_out(:,idx);
    Units.motions=strrep(strrep(units(ismember(headers,motvar)),'(',''),')','');
    naccelvar={'NcIMUTAxs';'NcIMUTAys';'NcIMUTAzs';'NcIMURAxs';'NcIMURAys';'NcIMURAzs'};
    [tf,loc] = ismember(headers,naccelvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.naccel = FAST_out(:,idx);
    Units.naccel=transpose(strrep(strrep(units(ismember(headers,naccelvar)),'(',''),')',''));
    basebendvar={'TwrBsFxt';'TwrBsFyt';'TwrBsFzt';'TwHt1MLxt';'TwHt1MLyt';'TwHt1MLzt';};
    [tf,loc] = ismember(headers,basebendvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.basebend = FAST_out(:,idx) * 1000; %in kN, convert to N
    Units.basebend=transpose(strrep(strrep(strrep(units(ismember(headers,basebendvar)),'(',''),')',''),'k','')); % convert to N
    %% Added by Antoine - Power Output
    poweroutvar={'GenPwr';};
    FAST.powerout = FAST_out(:,ismember(headers,poweroutvar));
    Units.powerout = strrep(strrep(units(ismember(headers,poweroutvar)),'(',''),')','');
    %% Added by Daniel Toledo - Rotor Speed
    FAST.rotspeed = FAST_out(:,ismember(headers,'RotSpeed'));
    Units.rotspeed = strrep(strrep(units(ismember(headers,'RotSpeed')),'(',''),')','');
    %% add in tower drag?
    TowerDrag=[Turbine.Tower.Drag 0 0 0 Turbine.Tower.Drag*Turbine.Tower.CoP 0];
    FAST.basebendwdrag = FAST.basebend+repmat(TowerDrag,[length(FAST.time) 1]).*ones(length(FAST.time),6);
    Units.basebendwdrag=Units.basebend;
    velvar={'PtfmTVxi';'PtfmTVyi';'PtfmTVzi';'PtfmRVxi';'PtfmRVyi';'PtfmRVzi';};
    [tf,loc] = ismember(headers,velvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.velocity = FAST_out(:,idx);
    Units.velocity=strrep(strrep(units(ismember(headers,velvar)),'(',''),')','');
    nacyawvar={'NacYaw'};
    FAST.nacyaw = FAST_out(:,ismember(headers, nacyawvar));
    Units.nacyaw=strrep(strrep(units(ismember(headers,nacyawvar)),'(',''),')','');
    yawbvar={'YawBrFxp';'YawBrFyp';'YawBrFzp';'YawBrMxp';'YawBrMyp';'YawBrMzp';}; % AYAYAYAYAYAY order must match .fst file!
    [tf,loc] = ismember(headers,yawbvar); [~,p] = sort(loc(tf)); idx = find(tf);  idx = idx(p);
    FAST.yawbearing= FAST_out(:,idx) * 1000; %in kN, convert to N
    Units.yawbearing=transpose(strrep(strrep(strrep(units(ismember(headers,yawbvar)),'(',''),')',''),'k','')); % convert to N
    balvar={'BallastMx';'BallastMy'};
    FAST.Ballast = FAST_out(:,ismember(headers, balvar))*1000;
    Units.Ballast=strrep(strrep(strrep(units(ismember(headers,balvar)),'(',''),')',''),'k',''); % convert to N
    windvar={'WindVxi';'WindVyi';'WindVzi';};
    FAST.WindSpeed = FAST_out(:,ismember(headers,windvar));
    Units.WindSpeed = strrep(strrep(units(ismember(headers,windvar)),'(',''),')','');
    FAST.Ballast_mass = zeros(size(FAST.Ballast,3));
    Units.Ballast_mass={'kg','kg','kg'};
    for i = 1:size(FAST.Ballast,1)
        [FAST.Ballast_mass(i,1),FAST.Ballast_mass(i,2),FAST.Ballast_mass(i,3)] = CalBallastWeight(Rotate2DMat([FAST.Ballast(i,1), FAST.Ballast(i,2)], (Wind.Dir-Res.yawfix)*pi/180),[Ptfm.Col.Lh*2/3 0],[-Ptfm.Col.Lh*1/3 Ptfm.Col.L/2],[-Ptfm.Col.Lh*1/3 -Ptfm.Col.L/2],Ptfm.BallastW);
    end
    FAST.nacyaw_mean = mean(FAST.nacyaw);
    FAST.thrust = FAST.thrustraw - ((Turbine.Weight/9.80655) .* FAST.naccel); %Here Remove Inertial Force from thrust
    FAST.thrustNcl = FAST.thrustraw;
    Units.thrustNcl = Units.thrust;
    %% WTF ARE ALL THESE THRUSTS?!?!
    FAST.thrustraw2 = FAST.thrustraw;
    Units.thrustraw2=Units.thrust;
    FAST.thrust2 = FAST.thrust;
    Units.thrust2=Units.thrust;
    FAST.naccel2 = FAST.naccel;
    Units.naccel2=Units.naccel;
    for i = 1:size(FAST.thrust,1) % rotate from shaft to local instantaneously!
        FAST.thrust2(i,1) = FAST.thrust(i,1)*cos(-Turbine.Tilt)-FAST.thrust(i,3)*sin(-Turbine.Tilt);
        FAST.thrust2(i,3) = FAST.thrust(i,1)*sin(-Turbine.Tilt)+FAST.thrust(i,3)*cos(-Turbine.Tilt);
        FAST.thrust2(i,4) = FAST.thrust(i,4)*cos(-Turbine.Tilt)-FAST.thrust(i,6)*sin(-Turbine.Tilt);
        FAST.thrust2(i,6) = FAST.thrust(i,4)*sin(-Turbine.Tilt)+FAST.thrust(i,6)*cos(-Turbine.Tilt);
        FAST.thrustraw2(i,1) = FAST.thrustraw(i,1)*cos(-Turbine.Tilt)-FAST.thrustraw(i,3)*sin(-Turbine.Tilt);
        FAST.thrustraw2(i,3) = FAST.thrustraw(i,1)*sin(-Turbine.Tilt)+FAST.thrustraw(i,3)*cos(-Turbine.Tilt);
        FAST.thrustraw2(i,4) = FAST.thrustraw(i,4)*cos(-Turbine.Tilt)-FAST.thrustraw(i,6)*sin(-Turbine.Tilt);
        FAST.thrustraw2(i,6) = FAST.thrustraw(i,4)*sin(-Turbine.Tilt)+FAST.thrustraw(i,6)*cos(-Turbine.Tilt);
        FAST.naccel2(i,1) = FAST.naccel(i,1)*cos(-Turbine.Tilt)-FAST.naccel(i,3)*sin(-Turbine.Tilt);
        FAST.naccel2(i,3) = FAST.naccel(i,1)*sin(-Turbine.Tilt)-FAST.naccel(i,3)*cos(-Turbine.Tilt);
        FAST.naccel2(i,4) = FAST.naccel(i,4)*cos(-Turbine.Tilt)-FAST.naccel(i,6)*sin(-Turbine.Tilt);
        FAST.naccel2(i,6) = FAST.naccel(i,4)*sin(-Turbine.Tilt)-FAST.naccel(i,6)*cos(-Turbine.Tilt);
    end
    FAST.thrust2(:,3) = FAST.thrust2(:,3) + Turbine.Weight; %Remove rotor weight
else
    FAST=[];
    warning('.OUT or .OUTB does not exist in TEMP folder')
end
end

function Res_Table=getResTable(Res,Units,FAST,FUnits,Ptfm,Turbine,Wind,Wave,Cur,General)
%             yawfix = mean(Res.motionr(120:end,6)); %mean yaw to adjust global to mean body
Params_Table=writeParams2Table(Res,FAST,Ptfm,Turbine,Wind,Wave,Cur,General);

% MLnames={'TopT','AnchorT','PreT','EffT','ArcL','ArcLTDP','LineType','TopAngle','UpliftAngle','AnchorAngle'}; %??
% nMLn=length(MLnames);
% Moor_Table=cell(nMLn*Res.nML,3);
for jj=1:(Res.nML + Res.nEC)
    % Naming is hard-coded from extractSIM->extractML
    if jj<=Res.nML
        jline=jj;
        lname='ml';
    else
        jline=jj-Res.nML;
        lname='ec';
    end
    jls=sprintf('%s%d',lname,jline); 
    if jj==1
        MLnames = fieldnames(Res.(jls));
        nMLn=length(MLnames);
        Moor_Table=cell(nMLn*(Res.nML+Res.nEC),3);
    end
    %mls=sprintf('ml%d',jj);
    for pp=1:nMLn
        if (strcmp(MLnames{pp},'TopT') || strcmp(MLnames{pp},'AnchorT') ) && ~isempty(FAST)
            jlsr=[jls 'r'];
            Moor_Table(pp+nMLn*(jj-1),:)={[jls MLnames{pp}], Res.(jlsr).(MLnames{pp}),Units.(jls).(MLnames{pp})};
        else
            Moor_Table(pp+nMLn*(jj-1),:)={[jls MLnames{pp}], Res.(jls).(MLnames{pp}),Units.(jls).(MLnames{pp})}; % would this work for cell arrays of strings?
        end
    end
end
if ~isempty(FAST) && Res.state~=99
    % then you ran an OrcaFAST run
    Res.motion(:,4:6) = zeros(length(Res.time),3);
    %Res.motionHubH(:,4:6) = zeros(length(Res.time),3);
    %Res.motionTwrB(:,4:6) = zeros(length(Res.time),3);
    Res.velocity(:,4:6) = zeros(length(Res.time),3);
    %Res.velocityHubH(:,4:6) = zeros(length(Res.time),3);
    %Res.velocityTwrB(:,4:6) = zeros(length(Res.time),3);
    Res.accel(:,4:6) = zeros(length(Res.time),3);
    %Res.accelHubH(:,4:6) = zeros(length(Res.time),3);
    %Res.accelTwrB(:,4:6) = zeros(length(Res.time),3);
    Res.thrust = zeros(length(Res.time),6);
    Res.thrustraw = zeros(length(Res.time),6);
    Res.thrustNcl = zeros(length(Res.time),6);
    Res.basebend = zeros(length(Res.time),6);
    Res.basebendwdrag = zeros(length(Res.time),6);
    Res.naccel = zeros(length(Res.time),6);
    Res.Ballast_mass = zeros(length(Res.time), 3);
    for ii = 1:6
        if ii>3
            % If you have run OrcaFAST, then overwrite the rotational motions
             Res.motion(:,ii) = interp1(FAST.time-General.StartTime, FAST.mot(:,ii), Res.time); % validated..
             % on a rigid body all rotational motions should be the same
             %Res.motionHubH(:,ii) = interp1(FAST.time, FAST.mot(:,ii), Res.time-General.StartTime); 
             %Res.motionTwrB(:,ii) = interp1(FAST.time, FAST.mot(:,ii), Res.time-General.StartTime); 
             Res.velocity(:,ii) = interp1(FAST.time-General.StartTime, FAST.velocity(:,ii), Res.time);
             %Res.velocityHubH(:,ii) = interp1(FAST.time, FAST.velocity(:,ii), Res.time-General.StartTime);
             %Res.velocityTwrB(:,ii) = interp1(FAST.time, FAST.velocity(:,ii), Res.time-General.StartTime);
             Res.accel(:,ii) = interp1(FAST.time-General.StartTime, FAST.accel(:,ii), Res.time);
             %Res.accelHubH(:,ii) = interp1(FAST.time, FAST.accel(:,ii), Res.time-General.StartTime);
             %Res.accelTwrB(:,ii) = interp1(FAST.time, FAST.accel(:,ii), Res.time-General.StartTime);
        else
            Res.Ballast_mass(:,ii) = interp1(FAST.time-General.StartTime, FAST.Ballast_mass(:,ii), Res.time);
            Res.windspeed(:,ii) = interp1(FAST.time-General.StartTime,FAST.WindSpeed(:,ii),Res.time);
        end
        Res.thrust(:,ii) = interp1(FAST.time-General.StartTime, FAST.thrust2(:,ii), Res.time);
        Res.thrustraw(:,ii) = interp1(FAST.time-General.StartTime, FAST.thrustraw2(:,ii), Res.time);
        Res.thrustNcl(:,ii) = interp1(FAST.time-General.StartTime, FAST.thrustNcl(:,ii), Res.time);
        Res.basebend(:,ii) = interp1(FAST.time-General.StartTime, FAST.basebend(:,ii), Res.time);
        Res.basebendwdrag(:,ii) = interp1(FAST.time-General.StartTime, FAST.basebendwdrag(:,ii), Res.time);
        Res.naccel(:,ii) = interp1(FAST.time-General.StartTime, FAST.naccel2(:,ii), Res.time);
        Res.yawbearing(:,ii)=interp1(FAST.time-General.StartTime, FAST.yawbearing(:,ii), Res.time);
        
    end
    Res.powerout(:,1)=interp1(FAST.time-General.StartTime, FAST.powerout, Res.time);
    Res.rotspeed(:,1)=interp1(FAST.time-General.StartTime, FAST.rotspeed, Res.time); %Added by Daniel Toledo - Rotor Speed
    % MOTIONS
    Res.motionr(:,1:3) = Rotate2DMat(Res.motion(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.motionr(:,4:6) = Rotate2DMat(Res.motion(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.motionr(:,6) = Res.motionr(:,6) + Wind.Dir*Ptfm.iFAST - Res.yawfix; % Correct Yaw
    Res.motionHubHr(:,1:3) = Rotate2DMat(Res.motionHubH(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.motionHubHr(:,4:6) = Rotate2DMat(Res.motionHubH(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.motionHubHr(:,6) = Res.motionHubHr(:,6) + Wind.Dir*Ptfm.iFAST - Res.yawfix; 
    Res.motionTwrBr(:,1:3) = Rotate2DMat(Res.motionTwrB(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.motionTwrBr(:,4:6) = Rotate2DMat(Res.motionTwrB(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.motionTwrBr(:,6) = Res.motionTwrBr(:,6) + Wind.Dir*Ptfm.iFAST - Res.yawfix; 
    % VELOCITIES
    Res.velocityr(:,1:3) = Rotate2DMat(Res.velocity(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180); %*Ptfm.iFAST
    Res.velocityr(:,4:6) = Rotate2DMat(Res.velocity(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.velocityHubHr(:,1:3) = Rotate2DMat(Res.velocityHubH(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.velocityHubHr(:,4:6) = Rotate2DMat(Res.velocityHubH(:,4:6), (Wind.Dir-Res.yawfix)*pi/180);
    Res.velocityTwrBr(:,1:3) = Rotate2DMat(Res.velocityTwrB(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.velocityTwrBr(:,4:6) = Rotate2DMat(Res.velocityTwrB(:,4:6), (Wind.Dir-Res.yawfix)*pi/180);
    % ACCEL
    Res.accelr(:,1:3) = Rotate2DMat(Res.accel(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.accelr(:,4:6) = Rotate2DMat(Res.accel(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.accelHubHr(:,1:3) = Rotate2DMat(Res.accelHubH(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.accelRNAr(:,1:3) = Rotate2DMat(Res.accelHubH(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180); % already taken from RNA buoy, which is rotated
    %Res.accelHubHr(:,4:6) = Rotate2DMat(Res.accelHubH(:,4:6), (Wind.Dir-Res.yawfix)*pi/180);
    Res.accelTwrBr(:,1:3) = Rotate2DMat(Res.accelTwrB(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    %Res.accelTwrBr(:,4:6) = Rotate2DMat(Res.accelTwrB(:,4:6), (Wind.Dir-Res.yawfix)*pi/180);
    Res.naccelr(:,1:3) = Rotate2DMat(Res.naccel(:,1:3), (Wind.Dir*Ptfm.iFAST+FAST.nacyaw_mean)*pi/180);
    
    % FORCES
    Res.thrustr(:,1:3) = Rotate2DMat(Res.thrust(:,1:3), (Wind.Dir*Ptfm.iFAST+FAST.nacyaw_mean)*pi/180);
    Res.thrustr(:,4:6) = Rotate2DMat(Res.thrust(:,4:6), (Wind.Dir*Ptfm.iFAST+FAST.nacyaw_mean)*pi/180);
    Res.thrustrawr(:,1:3) = Rotate2DMat(Res.thrustraw(:,1:3), (Wind.Dir*Ptfm.iFAST+FAST.nacyaw_mean)*pi/180);
    Res.thrustrawr(:,4:6) = Rotate2DMat(Res.thrustraw(:,4:6), (Wind.Dir*Ptfm.iFAST+FAST.nacyaw_mean)*pi/180);
    Res.basebendr(:,1:3) = Rotate2DMat(Res.basebend(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180); 
    Res.basebendr(:,4:6) = Rotate2DMat(Res.basebend(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.basebendwdragr(:,1:3) = Rotate2DMat(Res.basebendwdrag(:,1:3), Wind.Dir*Ptfm.iFAST*pi/180);
    Res.basebendwdragr(:,4:6) = Rotate2DMat(Res.basebendwdrag(:,4:6), Wind.Dir*Ptfm.iFAST*pi/180);
    Res.yawbearingr(:,1:3)=Rotate2DMat(Res.yawbearing(:,1:3), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    Res.yawbearingr(:,4:6)=Rotate2DMat(Res.yawbearing(:,4:6), (Wind.Dir*Ptfm.iFAST-Res.yawfix)*pi/180);
    
    Res.TwrBsMtRNAr(:,1:3) = Rotate2DMat(Res.TwrBsMtRNA(:,1:3), (0-Res.yawfix)*pi/180); % the wind direction is already taken into account in the RNA heading which is used to rotate the forces/moments
    Res.TwrBsMtRNAr(:,4:6) = Rotate2DMat(Res.TwrBsMtRNA(:,4:6), (0-Res.yawfix)*pi/180);
    
    %% motion table
    MOT_table={    
    'motions', Res.motionr, {Units.motions{1:3} FUnits.motions{4:6}};
    'motionsHubH', Res.motionHubHr, Units.motionsHubH;
    'motionsTwrB', Res.motionTwrBr, Units.motionsTwrB;
    'velocity', Res.velocityr, {Units.velocity{1:3} FUnits.velocity{4:6}};
    'velocityHubH', Res.velocityHubHr, Units.velocityHubH;
    'velocityTwrB', Res.velocityTwrBr, Units.velocityTwrB;
    'accel', Res.accelr, {Units.accel{1:3} FUnits.accel{4:6}};
    'accelHubH', Res.accelHubHr, Units.accelHubH;
    'accelTwrB', Res.accelTwrBr, Units.accelTwrB;
    };
    OF_table = {
    'waveel', Res.waveel,Units.waveel;
    'wavecomp', Res.wavecomp,Units.wavecomp;
    'waveforce', Res.waveforce,Units.waveforce;
    'wavedrift', Res.wavedrift,Units.wavedrift;
    'addedmassdamp', Res.addedmassdamp,Units.addedmassdamp;
    'otherdamping',Res.otherdamping,Units.otherdamping;
    'hydrostiff', Res.hydrostiff,Units.hydrostiff;
    'WEPtrack', Res.WEPtrack,Units.WEPtrack;
    'COLtrack', Res.COLtrack,Units.COLtrack;
    'KEELtrack', Res.KEELtrack,Units.KEELtrack;
%     'ml1TopT', Res.ml1r.TopT,Units.ml1.TopT;
%     'ml2TopT', Res.ml2r.TopT,Units.ml2.TopT;
%     'ml3TopT', Res.ml3r.TopT,Units.ml3.TopT;
    'DecayForce',Res.DecayForce, Units.DecayForce;
    'DecayForceTime',Res.DecayForceTime, Units.DecayForceTime;
    'TwrBsMtRNA',Res.TwrBsMtRNAr, Units.TwrBsMtRNA;
    };
    %% Create FAST results Table
    FAST_table = {
        'thrust', Res.thrustr, FUnits.thrust;
        'thrustraw', Res.thrustrawr, FUnits.thrust;
        'thrustNcl', Res.thrustNcl, FUnits.thrust;
        'basebend', Res.basebendr, FUnits.basebend;
        'basebendwdrag', Res.basebendwdragr, FUnits.basebendwdrag;
        'yawbearing',Res.yawbearingr, FUnits.yawbearing;
        'yawbearingNcl',Res.yawbearing, FUnits.yawbearing;
        'naccel', Res.naccelr, FUnits.naccel;
        'genpow', Res.powerout, FUnits.powerout;
        'rotspeed',Res.rotspeed,FUnits.rotspeed; %Added by Daniel Toledo - Rotor Speed
        'windspeed',Res.windspeed,FUnits.WindSpeed};
elseif Res.state==99
    % then you ran just a FAST run
        FAST.basebendr(:,1:3) = Rotate2DMat(FAST.basebend(:,1:3), (Wind.Dir)*pi/180); % No platform yaw motion....
        FAST.basebendr(:,4:6) = Rotate2DMat(FAST.basebend(:,4:6), (Wind.Dir)*pi/180);
        MOT_table = {
            'motions',FAST.mot,FUnits.motions;
            'velocity',FAST.velocity,FUnits.velocity;
            'accel',FAST.accel,FUnits.accel;
            };
        OF_table={};
        FAST_table = {
        'thrust', FAST.thrust2, FUnits.thrust;
        'thrustraw', FAST.thrustraw2, FUnits.thrust;
        'thrustNcl', FAST.thrustNcl, FUnits.thrust;
        'basebend', FAST.basebendr, FUnits.basebend;
        'basebendwdrag', FAST.basebendwdrag, FUnits.basebendwdrag;
        'yawbearing',FAST.yawbearing, FUnits.yawbearing;
        'naccel', FAST.naccel2, FUnits.naccel;
        'genpow', FAST.powerout, FUnits.powerout;
        'rotspeed',FAST.rotspeed,FUnits.rotspeed;
        'windspeed',FAST.WindSpeed,FUnits.WindSpeed;
        };
 
        Res.line_table={};
else
    % you ran an OrcaFlex run
    MOT_table={    
    'motions', Res.motion, Units.motions;
    'motionsHubH', Res.motionHubH, Units.motionsHubH;
    'motionsTwrB', Res.motionTwrB, Units.motionsTwrB;
    'velocity', Res.velocity, Units.velocity;
    'velocityHubH', Res.velocityHubH, Units.velocityHubH;
    'velocityTwrB', Res.velocityTwrB, Units.velocityTwrB;
    'accel', Res.accel, Units.accel;
    'accelHubH', Res.accelHubH, Units.accelHubH;
    'accelTwrB', Res.accelTwrB, Units.accelTwrB;
    'accelRNA', Res.accelRNA, Units.accelRNA;
    };
    %% Create Orca results Table
    if isfield(Res,'waveforce')
        
        OF_table = {
        'waveel', Res.waveel,Units.waveel;
        'wavecomp', Res.wavecomp,Units.wavecomp;
        'waveforce', Res.waveforce,Units.waveforce;
        'wavedrift', Res.wavedrift,Units.wavedrift;
        'addedmassdamp', Res.addedmassdamp,Units.addedmassdamp;
        'otherdamping',Res.otherdamping,Units.otherdamping;
        'hydrostiff', Res.hydrostiff,Units.hydrostiff;
        'WEPtrack', Res.WEPtrack,Units.WEPtrack;
        'KEELtrack', Res.KEELtrack,Units.KEELtrack;
        'COLtrack', Res.COLtrack,Units.COLtrack;
        'DecayForce',Res.DecayForce, Units.DecayForce;
        'DecayForceTime',Res.DecayForceTime, Units.DecayForceTime;  
        'TwrBsMtRNA',Res.TwrBsMtRNA, Units.TwrBsMtRNA;
        };
    else
        OF_table = {
        'waveel', Res.waveel,Units.waveel;
        'wavecomp', Res.wavecomp,Units.wavecomp;
        'DecayForce',Res.DecayForce, Units.DecayForce;
        'DecayForceTime',Res.DecayForceTime, Units.DecayForceTime;  
        };
    end
    FAST_table=[];

end
if ~isfield(General,'CutInTime')
    General.CutInTime=0;
end
if ~isfield(General,'CutOutTime')
    General.CutOutTime=max(Res.time);
end
if Res.state~=99
    time_table={'time', Res.time, Units.time;
            'CutInTime',General.CutInTime,Units.time;
            'CutOutTime',General.CutOutTime,Units.time;};
else
    time_table={'time', FAST.time, FUnits.time;
            'CutInTime',General.CutInTime,FUnits.time;
            'CutOutTime',General.CutOutTime,FUnits.time;};
end
%% Create Ballast Table
if Ptfm.BallastFlag==1 && Ptfm.iFAST
    Bal_Table={'BallastMass', Res.Ballast_mass,FUnits.Ballast_mass}; % time series of ballast controller, size= [nT_orca, 3]
else
    if isfield(Ptfm,'AB_Mass')
        if Res.state~=99
            Bal_Table={'BallastMass', repmat(Ptfm.AB_Mass,[length(Res.time) 1]).*ones(length(Res.time),3),{'kg','kg','kg'}}; % constant time series of local applied moment in Orca= [nT_orca, 3]
        else
            Bal_Table={'BallastMass', repmat(Ptfm.AB_Mass,[length(FAST.time) 1]).*ones(length(FAST.time),3),{'kg','kg','kg'}}; % constant time series of local applied moment in Orca= [nT_orca, 3]
        end
    else
        Bal_Table={};
    end
end
Res_Table = [time_table; MOT_table; OF_table; Bal_Table; FAST_table; Moor_Table; Res.line_table; Params_Table];
end


function Params_Table=writeParams2Table(Res,FAST,Ptfm,Turbine,Wind,Wave,Cur,General)
if isempty(FAST)
    FAST.nacyaw_mean=nan;
end
if isempty(Res)
    Res.yawfix=nan;
end
if isfield(Res,'motion') %Prevent crashing if doesn't exist
    Params_Table(:,1)={'inputcode','Wind_Dir','Wind_Speed','Wind_Type','Wave_Dir','Wave_Hs','Wave_Tp','Wave_Seed', ...
        'Cur_Dir','Cur_Spd','BallastFlag','nacyaw','runtime','simstart','Rmg','shaftpitch','overhang',...
        'fname','Mean_Yaw','Mean_nacyaw','Wta'};
    Params_Table(:,2)={Turbine.Code, Wind.Dir, Wind.Speed, Wind.Type, Wave.Dir, Wave.Hs,Wave.Tp, Wave.Seed, ...
        Cur.Dir, Cur.Speed,Ptfm.BallastFlag, Turbine.Yaw, General.EndTime, General.StartTime, Turbine.Weight, Turbine.Tilt, Turbine.Overhang, ...
        General.RunName, Res.yawfix, FAST.nacyaw_mean, Ptfm.BallastW};
    Params_Table(:,3) ={'-','deg','m/s','-','deg','m','s','-',...
        'deg','m/s','-','deg','s','s','N','deg','m',...
        '-','deg','deg','N'};
else
    Params_Table=cell(1,3);
end
end

function writeParams(resultsdir,Res,FAST,Ptfm,Turbine,Wind,Wave,Cur,General)
fid = fopen([resultsdir, 'param.txt'], 'w');
if isempty(FAST)
    FAST.nacyaw_mean=nan;
end
if isempty(Res)
    Res.yawfix=nan;
end
if isfield(Res,'motion') %Prevent crashing if doesn't exist
    fprintf(fid, sprintf(['###USER-DEFINED VARIABLES\ninputcode = %s\nWind_Dir = %g\nWind_Speed = %g' ...
        '\nWind_Type = %g\nWave_Dir = %g\nWave_Hs = %g\nWave_Tp = %g\nWave_Seed = %g' ...
        '\nCur_Dir = %f\nCur_Spd = %g\nBallastFlag = %g\nnacyaw = %g' ...
        '\nruntime = %g\nsimstart = %g\n###OTHER VARIABLES\nRmg = %g\nshaftpitch = %g\noverhang = %g' ...
        '\nfname = %s\nMean_Yaw = %g\nMean_nacyaw = %g\nWta = %g'], ...
        Turbine.Code, Wind.Dir, Wind.Speed, Wind.Type, Wave.Dir, Wave.Hs, ...
        Wave.Tp, Wave.Seed, Cur.Dir, Cur.Speed,Ptfm.BallastFlag, Turbine.Yaw, General.EndTime, General.StartTime, Turbine.Weight, ...
        Turbine.Tilt, Turbine.Overhang, General.RunName, Res.yawfix, FAST.nacyaw_mean, Ptfm.BallastW));
end
fclose(fid);
end
function [trackpointsWEP,trackpointsCOL,trackpointsKEEL]=getTrackPts(Ptfm)
if length(Ptfm.Col.L)==1
    Ptfm.Col.L=repmat(Ptfm.Col.L,[1 3]);
end
Xc=getColX(Ptfm,[0 0 0]);
trackpointsWEP=[0 0 0];
if isfield(Ptfm,'WEP')
    WEPtype=Ptfm.WEP{:};
    X=[Ptfm.(WEPtype).Pts{:,2}]';
    Y=[Ptfm.(WEPtype).Pts{:,3}]';
    XYZ=[X Y repmat(-abs(Ptfm.Col.Draft),[length(X) 1])];
    nPts=size(X,1);
    nWEPpts=nPts/3;
    [foo,iXmin]=min(round(X(1:nWEPpts)*10)/10); [foomax,iXmax]=max(round(X(1:nWEPpts)*10)/10); iXmax=find( round(X(1:nWEPpts)*10)/10 ==foomax);
    [foo,iYmin]=min(Y(1:nWEPpts)); [foo,iYmax]=max(Y(1:nWEPpts));
    iKeep=sort([iXmin ;iXmax ;iYmin ;iYmax],'ascend');
    iKeep=[iKeep nWEPpts+iKeep nWEPpts*2+iKeep];
    X1=mean(XYZ(1:nWEPpts,1));
    if X1>Ptfm.Col.D(1)
        OrcaOrigin=[2*Ptfm.Col.Lh/3 0 0];
    else
        OrcaOrigin=[ 0 0 0];
    end
    XYZ=XYZ-repmat(OrcaOrigin,[nPts 1]);
    trackpointsWEP=XYZ(iKeep,:);
end
%         trackpointsWEP = [8.5737 4.95 Ptfm.Col.Draft; %start WEP1
%             0 9.9 Ptfm.Col.Draft;
%             -17.1474 9.9 Ptfm.Col.Draft;
%             -17.1474 -9.9 Ptfm.Col.Draft;
%             0 -9.9 Ptfm.Col.Draft;
%             8.5737 -4.95 Ptfm.Col.Draft;
%             -51.875 29.95 Ptfm.Col.Draft; %start WEP2
%             -51.875 20.5 Ptfm.Col.Draft;
%             -43.013 5.2 Ptfm.Col.Draft;
%             -26.154 15.1 Ptfm.Col.Draft;
%             -34.728 29.95 Ptfm.Col.Draft;
%             -43.013 34.9 Ptfm.Col.Draft;
%             -43.013 -34.9 Ptfm.Col.Draft; %start WEP3
%             -34.728 -29.95 Ptfm.Col.Draft;
%             -26.154 -15.1 Ptfm.Col.Draft;
%             -43.013 -5.2 Ptfm.Col.Draft;
%             -51.875 -20.5 Ptfm.Col.Draft;
%             -51.875 -29.95 Ptfm.Col.Draft
%             ];
        ColAz=[0:90:270]*pi/180;
        tpColAz=repmat(transpose(ColAz),[3 1]);
        tpCol= repmat(kron(transpose(Ptfm.Col.D/2),ones(length(ColAz), 1) ),[1 2]).*[cos(tpColAz) sin(tpColAz)];
        trackpointsCOL=[kron(Xc(:,1),ones(length(ColAz),1))+tpCol(:,1),...
            kron(Xc(:,2),ones(length(ColAz),1))+tpCol(:,2),...
            Ptfm.Col.zh*ones(length(tpColAz),1)];
        
%         trackpointsCOL = [Ptfm.Col.D(1)/2,0,Ptfm.Col.zh; %start column 1 top, north counterclockwise
%             0,Ptfm.Col.D(1)/2,Ptfm.Col.zh;
%             -Ptfm.Col.D(1)/2,0,Ptfm.Col.zh;
%             0,-Ptfm.Col.D(1)/2,Ptfm.Col.zh;
%             -Ptfm.Col.Lh+Ptfm.Col.D(2)/2,Ptfm.Col.L(2)/2,Ptfm.Col.zh; %start column 2 top, north ccw
%             -Ptfm.Col.Lh,Ptfm.Col.L(2)/2+Ptfm.Col.D(2)/2,Ptfm.Col.zh;
%             -Ptfm.Col.Lh-Ptfm.Col.D(2)/2,Ptfm.Col.L(2)/2,Ptfm.Col.zh;
%             -Ptfm.Col.Lh,Ptfm.Col.L(2)/2-Ptfm.Col.D(2)/2,Ptfm.Col.zh;
%             -Ptfm.Col.Lh+Ptfm.Col.D(3)/2,-Ptfm.Col.L(3)/2,Ptfm.Col.zh; %start column 3 top, north ccw
%             -Ptfm.Col.Lh,-Ptfm.Col.L(3)/2+Ptfm.Col.D(3)/2,Ptfm.Col.zh;
%             -Ptfm.Col.Lh-Ptfm.Col.D(3)/2,-Ptfm.Col.L(3)/2,Ptfm.Col.zh;
%             -Ptfm.Col.Lh,-Ptfm.Col.L(3)/2-Ptfm.Col.D(3)/2,Ptfm.Col.zh;
%             ];
        trackpointsKEEL=Xc-repmat([0 0 abs(Ptfm.Col.Draft)],[3 1]);
end
%         environment=resh_mod('Environment');
%         nWT=environment.NumberOfWaveTrains; 
%         WTtype=zeros(nWT,1); % assume all wave trains are regular to start
%         for kk=1:nWT
%             environment.SelectedWaveTrain = environment.WaveName(kk);
%             WaveType=environment.WaveType;
%             WTtype(kk)=~strcmp(WaveType,'Airy');
%         end
%         maxNWC=1;
%         if sum(WTtype)>0
%             %there is at least 1 irregular wave
%             iregWT=find(WTtype);
%            for jj=1:sum(WTtype);
%                environment.SelectedWaveTrain = environment.WaveName(iregWT(jj));
%                maxNWC=max([maxNWC environment.WaveNumberOfComponents]);
%            end
%         end
%         for kk=1:nWT
%             environment.SelectedWaveTrain = environment.WaveName(kk);
%             if WTtype(kk)
%                 nWC=environment.WaveNumberOfComponents;
%                 resh_wavecomp = resh_mod.waveComponents;
%                 %[~,nWaveC]=size(resh_wavecomp);
%                 [resh_wavecomp.Frequency]'
%                 Res.wavecomp(1:nWC,3*(kk-1)+1) = [resh_wavecomp.Frequency]';
%                 Res.wavecomp(1:nWC,3*(kk-1)+1) = [resh_wavecomp.Amplitude]';
%                 Res.wavecomp(1:nWC,3*(kk-1)+1) = [resh_wavecomp.PhaseLagWrtSimulationTime]';
%             else
%                  Res.wavecomp(1,3*(kk-1)+1) = 2*pi/environment.WavePeriod;%[resh_wavecomp.Frequency];
%                  Res.wavecomp(1,3*(kk-1)+1) = environment.WaveHeight/2;%[resh_wavecomp.Amplitude];
%                  Res.wavecomp(1,3*(kk-1)+1) = 0;
%             end
%         end
%             Ptfm.Col.D/2,0,Ptfm.Col.Draft; %start column 1 bottom
%             0,Ptfm.Col.D/2,Ptfm.Col.Draft;
%             -Ptfm.Col.D/2,0,Ptfm.Col.Draft;
%             0,-Ptfm.Col.D/2,Ptfm.Col.Draft;
%             -Ptfm.Col.Lh+Ptfm.Col.D/2,Ptfm.Col.L/2,Ptfm.Col.Draft; %start column 2 bottom
%             -Ptfm.Col.Lh,Ptfm.Col.L/2+Ptfm.Col.D/2,Ptfm.Col.Draft;
%             -Ptfm.Col.Lh-Ptfm.Col.D/2,Ptfm.Col.L/2,Ptfm.Col.Draft;
%             -Ptfm.Col.Lh,Ptfm.Col.L/2-Ptfm.Col.D/2,Ptfm.Col.Draft;
%             -Ptfm.Col.Lh+Ptfm.Col.D/2,-Ptfm.Col.L/2,Ptfm.Col.Draft; %start column 3 bottom
%             -Ptfm.Col.Lh,-Ptfm.Col.L/2+Ptfm.Col.D/2,Ptfm.Col.Draft;
%             -Ptfm.Col.Lh-Ptfm.Col.D/2,-Ptfm.Col.L/2,Ptfm.Col.Draft;
%             -Ptfm.Col.Lh,-Ptfm.Col.L/2-Ptfm.Col.D/2,Ptfm.Col.Draft
%         if resh_moor2.type == 6 %is a line type == 6
%             res_ml2(:,1) = resh_moor2.TimeHistory('End GX-Force',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml2(:,2) = resh_moor2.TimeHistory('End GY-Force',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml2(:,3) = resh_moor2.TimeHistory('End GZ-Force',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml2r(:,1:3) = Rotate2DMat(res_ml2(:,1:3), (Wind.Dir-Res.yawfix)*pi/180);
%         elseif resh_moor1.type == 10 %is a spring type == 10
%             res_ml2(:,1) = resh_moor2.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor2.TimeHistory('End A X',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor2.TimeHistory('End B X',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor2.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml2(:,2) = resh_moor2.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor2.TimeHistory('End A Y',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor2.TimeHistory('End B Y',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor2.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml2(:,3) = resh_moor2.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor2.TimeHistory('End A Z',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor2.TimeHistory('End B Z',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor2.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml2r(:,1:3) = Rotate2DMat(res_ml2(:,1:3), (Wind.Dir-Res.yawfix)*pi/180);
%         end
% 
%         if resh_moor3.type == 6 %is a line type == 6
%             res_ml3(:,1) = resh_moor3.TimeHistory('End GX-Force',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml3(:,2) = resh_moor3.TimeHistory('End GY-Force',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml3(:,3) = resh_moor3.TimeHistory('End GZ-Force',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml3r(:,1:3) = Rotate2DMat(res_ml3(:,1:3), (Wind.Dir-Res.yawfix)*pi/180);
%         elseif resh_moor1.type == 10 %is a spring type == 10
%             res_ml3(:,1) = resh_moor3.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor3.TimeHistory('End A X',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor3.TimeHistory('End B X',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor3.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml3(:,2) = resh_moor3.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor3.TimeHistory('End A Y',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor3.TimeHistory('End B Y',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor3.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml3(:,3) = resh_moor3.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor3.TimeHistory('End A Z',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor3.TimeHistory('End B Z',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor3.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
%             res_ml3r(:,1:3) = Rotate2DMat(res_ml3(:,1:3), (Wind.Dir-Res.yawfix)*pi/180);
%         end
            %    fBX = -line.TimeHistory('End GX-Force', ofx.Period(t_start, timeend), ofx.oeEndB);
            %fAY = line.TimeHistory('End GY-Force',  ofx.Period(t_start, timeend), ofx.oeEndA);
            %fBY = -line.TimeHistory('End GY-Force', ofx.Period(t_start, timeend), ofx.oeEndB);
            %fAZ = line.TimeHistory('End GZ-Force', ofx.Period(t_start, timeend), ofx.oeEndA);
            %fBZ = -line.TimeHistory('End GZ-Force', ofx.Period(t_start, timeend), ofx.oeEndB);
%             fAXr = fAX * cos((Wind.Dir-Res.yawfix)*pi/180) - fAY * sin((Wind.Dir-Res.yawfix)*pi/180);
%             fAYr = fAX * sin((Wind.Dir-yawfix)*pi/180) + fAY * cos((Wind.Dir-yawfix)*pi/180);
%             fBXr = fBX * cos((Wind.Dir-yawfix)*pi/180) - fBY * sin((Wind.Dir-yawfix)*pi/180);
%             fBYr = fBX * sin((Wind.Dir-yawfix)*pi/180) + fBY * cos((Wind.Dir-yawfix)*pi/180);
                    %res_ml1(:,2) = resh_moor1.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor1.TimeHistory('End A Y',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor1.TimeHistory('End B Y',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor1.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
                    %res_ml1(:,3) = resh_moor1.TimeHistory('Tension',ofx.Period(t_start,timeend), ofx.oeEndA) .* (resh_moor1.TimeHistory('End A Z',ofx.Period(t_start,timeend), ofx.oeEndA) - resh_moor1.TimeHistory('End B Z',ofx.Period(t_start,timeend), ofx.oeEndA))./resh_moor1.TimeHistory('Length',ofx.Period(t_start,timeend), ofx.oeEndA);
                    %res_ml1r(:,1:3) = Rotate2DMat(res_ml1(:,1:3), (Wind.Dir-Res.yawfix)*pi/180);
%    figure(1)
%     plot(Res.time,Res.motion(:,1),FAST.time,FAST.mot(:,1))
%     xlabel('time')
%     ylabel('Surge')
%     figure(2)
%     plot(Res.time,Res.motion(:,1),FAST.time,FAST.mot(:,2))
%     xlabel('time')
%     ylabel('Sway')               