function iptFile=GenerateIPTfromInputList(Platform,Wind,Wave,Current,General,Turbine,varargin)
if nargin<6
    Turbine=getBlankTurbine();
end
preamble{1}='!Principle Power Input Script for Running in-house OrcaFAST software v0';
rundir='Runs\';
headers={'!General Run Properties', '!Current Properties','!Platform Properties','!Turbine Properties','!Wave Properties','!Wind Properties'};
%% Write IPT File:
ipt_fname=['Run' General.RunName '.ipt'];
iptFile=[General.TempDir ipt_fname];
fid=fopen(iptFile,'w+');
for jj=1:length(preamble)
    fprintf(fid,'%s\n',preamble{jj});
end
irow=0;
for jj=1:length(headers)
    headerj=headers{jj};
    Data_IPT{irow+1,1}=headerj;
    fprintf(fid,'\n%s\n',Data_IPT{irow+1,1});
    
    Proptype1=strfind(headerj,'!');
    Proptype2=strfind(headerj,' ');
    proptype=headerj(Proptype1+1:Proptype2(1)-1);
    irow1=size(Data_IPT,1)+1;
    eval(['Data_IPT=get' proptype 'Props(' proptype ',Data_IPT);']);
%     try
%         eval(['Data_IPT=get' proptype 'Props(' proptype ',Data_IPT);']);
%     catch
%         error(['Please define the appropriate strings for Property Type: ' proptype])
%     end
    irow2=size(Data_IPT,1);
    for kk=irow1:irow2
        fprintf(fid,'% -50s%-100s\n',Data_IPT{kk,1},Data_IPT{kk,2});
    end
end
% for jj=1:size(Data_IPT,1)
%     fprintf(fid,'%-15s%-100s\n',Data_IPT{jj,1},Data_IPT{jj,2});
% end
fclose(fid);
end

function Data_IPT=getPlatformProps(Ptfm,Data_IPT)
%%%%%%%%%-------------------------------------------------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INSTRUCTIONS FOR NEW LABELS:

% labels must be a dash followed by a tab!!
%%%%%%%%%-------------------------------------------------------------------------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% How did I make a tab in the string? I forget, but just copy the 'space'
% from the existing strings...
%% On with the code..
%Include variable names in the datastr that you set in the next chunk of
%code so that you can include a little comment/description. Otherwise the
%code will look for everything that is a subfield in the structure and if
%it is 'short enough' it will write it to the IPT. 
datastr={'Col.D','Col.Draft','Col.H','Col.Lh', 'Col.L','datfile','iFAST'};
irow=size(Data_IPT,1);
PtfmCDStr='-	Ptfm.Col.D; Column Diameters [m] (float)';
Data_IPT{irow+1,1}=sprintf('%2.1f, %2.1f, %2.1f',Ptfm.Col.D); Data_IPT{irow+1,2}=PtfmCDStr;
PtfmCDrStr='-	Ptfm.Col.Draft; Platform Draft (<0) [m] (float)';
Data_IPT{irow+2,1}=sprintf('%2.1f',Ptfm.Col.Draft); Data_IPT{irow+2,2}=PtfmCDrStr;
PtfmCHStr='-	Ptfm.Col.H; Column Height [m] (float)';
Data_IPT{irow+3,1}=sprintf('%2.1f',Ptfm.Col.H); Data_IPT{irow+3,2}=PtfmCHStr;
PtfmTHStr='-	Ptfm.Col.Lh; Height of Triangle of platform (constrained by equilateral triangle) [m] (float)';
Data_IPT{irow+4,1}=sprintf('%2.1f',Ptfm.Col.Lh); Data_IPT{irow+4,2}=PtfmTHStr;
PtfmTLStr='-	Ptfm.Col.L; Column-to-column spacing, equilateral triangle [m] (float)';
Data_IPT{irow+5,1}=sprintf('%2.1f, %2.1f, %2.1f',Ptfm.Col.L); Data_IPT{irow+5,2}=PtfmTLStr;
PtfmStr='-	Ptfm.datfile; OrcaFlex file used for simulation (string)';
slashes=strfind(Ptfm.datfile,filesep);
if length(slashes)>3
    datfilestr=Ptfm.datfile(slashes(end-2)+1:end);
else
    datfilestr=Ptfm.datfile;
end
Data_IPT{irow+6,1}=datfilestr; Data_IPT{irow+6,2}=PtfmStr;
FastStr='-	Ptfm.iFAST; 1= OrcaFAST, 0 = OrcaFlex (logical)';
Data_IPT{irow+7,1}=sprintf('%d',Ptfm.iFAST); Data_IPT{irow+7,2}=FastStr;


Data_IPT=writeAStructProps(Data_IPT,Ptfm,datastr);

end

function Data_IPT=getCurrentProps(Cur,Data_IPT)
irow=size(Data_IPT,1);
datastr={'Dir','Speed'};
CurDirStr='-	Cur.Dir; Current Direction, used in OrcaFlex model [deg] (float)';
Data_IPT{irow+1,1}=sprintf('%2.1f',Cur.Dir); Data_IPT{irow+1,2}=CurDirStr;
CurSpeedStr='-	Cur.Speed; Current Speed, used in OrcaFlex model [m/s] (float)';
Data_IPT{irow+2,1}=sprintf('%2.3f',Cur.Speed); Data_IPT{irow+2,2}=CurSpeedStr;

Data_IPT=writeAStructProps(Data_IPT,Cur,datastr);

end

function Data_IPT=getWaveProps(Wave,Data_IPT)
datastr={'Dir','Hs','Tp','Seed','Swell.Dir','Swell.Hs','Swell.Tp'};
irow=size(Data_IPT,1);
WaveDirStr='-	Wave.Dir; Wave Direction relative to wind direction [deg] (float)';
Data_IPT{irow+1,1}=sprintf('%3.1f',round(Wave.Dir*10)/10); Data_IPT{irow+1,2}=WaveDirStr;
if isfield(Wave,'Hs')
    WaveHsStr='-	Wave.Hs; Significant Wave Height, used in OrcaFlex model [m] (float)';
    Data_IPT{irow+2,1}=sprintf('%2.2f',Wave.Hs); Data_IPT{irow+2,2}=WaveHsStr;
    WaveTpStr='-	Wave.Tp; Peak Wave Period, used in OrcaFlex model [s] (float)';
    Data_IPT{irow+3,1}=sprintf('%2.2f',Wave.Tp); Data_IPT{irow+3,2}=WaveTpStr;
end
WaveSeedStr='-	Wave.Seed; Type of wave: 0 = regular wave, >0 random seed for JONSWAP (integer)';
Data_IPT{irow+4,1}=sprintf('%d',Wave.Seed); Data_IPT{irow+4,2}=WaveSeedStr;
if Wave.Swell.Hs
    SwellDirStr='-	Wave.Swell.Dir; Wave Direction relative to wind direction [deg] (float)';
    Data_IPT{irow+5,1}=sprintf('%3.1f',round(Wave.Swell.Dir*10)/10); Data_IPT{irow+5,2}=SwellDirStr;
    SwellHsStr='-	Wave.Swell.Hs; Significant Swell Height, used in OrcaFlex model [m] (float)';
    Data_IPT{irow+6,1}=sprintf('%2.2f',Wave.Swell.Hs); Data_IPT{irow+6,2}=SwellHsStr;
    SwellTpStr='-	Wave.Swell.Tp; Peak Swell Period, used in OrcaFlex model [s] (float)';
    Data_IPT{irow+7,1}=sprintf('%2.2f',Wave.Swell.Tp); Data_IPT{irow+7,2}=SwellTpStr;
end

Data_IPT=writeAStructProps(Data_IPT,Wave,datastr);

end

function Data_IPT=getTurbineProps(Turbine,Data_IPT)
datastr={'Code','Overhang','Tilt','Yaw','Weight','Tower.Z','Tower.Drag','Tower.CoP','HubH','Tower.Cd','AirDensity','Name'};
irow=size(Data_IPT,1);
TurbCodeStr='-	Turbine.Code; String referring to .fst file: PAR, POW, SDN, STA (unquoted string)';
Data_IPT{irow+1,1}=Turbine.Code; Data_IPT{irow+1,2}=TurbCodeStr;
TurbOHangStr='-	Turbine.Overhang; Rotor overhang (dist btw hub ctr and rotor axis) [m] (float)';
Data_IPT{irow+2,1}=sprintf('%2.2f',Turbine.Overhang); Data_IPT{irow+2,2}=TurbOHangStr;
TurbTiltStr='-	Turbine.Tilt; Nacelle tilt angle (angle between the horizontal axis and the rotor shaft) [deg] (float)';
Data_IPT{irow+3,1}=sprintf('%1.1f',Turbine.Tilt); Data_IPT{irow+3,2}=TurbTiltStr;
TurbYawStr='-	Turbine.Yaw;  Yaw Misalignment, changes NacYaw variable in .fst file [deg] (float)';
Data_IPT{irow+4,1}=sprintf('%d',Turbine.Yaw); Data_IPT{irow+4,2}=TurbYawStr;
TurbLBStr='-	Turbine.Weight;  Turbine Weight, used in post-process analysis [N] (float)';
Data_IPT{irow+5,1}=sprintf('%1.6G',Turbine.Weight); Data_IPT{irow+5,2}=TurbLBStr;
TwrBStr='-	Turbine.Tower.Z(1);  Turbine Tower, used for motionsTwrB [m] (float)';
Data_IPT{irow+6,1}=sprintf('%2.2f',Turbine.Tower.Z(1)); Data_IPT{irow+6,2}=TwrBStr;
TwrDragStr='-	Turbine.Tower.Drag;  Total drag force on tower [N] (float)';
Data_IPT{irow+7,1}=sprintf('%1.6G',Turbine.Tower.Drag); Data_IPT{irow+7,2}=TwrDragStr;
TwrCoPStr='-	Turbine.Tower.CoP;  Center of Pressure of turbine, from MWL [m] (float)';
Data_IPT{irow+8,1}=sprintf('%3.2f',Turbine.Tower.CoP); Data_IPT{irow+8,2}=TwrCoPStr;
HubHStr='-	Turbine.HubH;  Turbine Hub Height, used for motionsHubH [m] (float)';
Data_IPT{irow+9,1}=sprintf('%3.2f',Turbine.HubH); Data_IPT{irow+9,2}=HubHStr;
CdStr='-	Turbine.Tower.Cd;  Turbine drag coefficient, used for calculating tower drag [-] (float)';
Data_IPT{irow+10,1}=sprintf('%1.2f',Turbine.Tower.Cd); Data_IPT{irow+10,2}=CdStr;
RhoStr='-	Turbine.AirDensity;  Air density, used for calculating tower drag [kg/m^3] (float)';
Data_IPT{irow+11,1}=sprintf('%1.3f',Turbine.AirDensity); Data_IPT{irow+11,2}=RhoStr;
TurbStr='-	Turbine.Name;  Turbine name, used for final naming of outputs (string)';
Data_IPT{irow+12,1}=Turbine.Name; Data_IPT{irow+12,2}=TurbStr;


Data_IPT=writeAStructProps(Data_IPT,Turbine,datastr);

end

function Data_IPT=getWindProps(Wind,Data_IPT)
datastr={'Dir','Seed','Speed','Type'};
irow=size(Data_IPT,1);
%from alan: Wind.Type: %0 for steady, 1 for turbulent, 2+ for other stuff
WindDirStr='-	Wind.Dir; Wind Direction, taken into account by rotating OrcaFlex model [deg] (float)';
Data_IPT{irow+1,1}=sprintf('%3.1f',round(Wind.Dir*10)/10); Data_IPT{irow+1,2}=WindDirStr;
WindSeedStr='-	Wind.Seed; Wind Seed: EWM, NTM,NTM##, EWM, ECD? (unquoted string)';
if isnumeric(Wind.Seed)
    Data_IPT{irow+2,1}=sprintf('%d',Wind.Seed);
else
    Data_IPT{irow+2,1}=Wind.Seed; 
end
Data_IPT{irow+2,2}=WindSeedStr;
WindSpeedStr='-	Wind.Speed; Wind Speed, calls on different .wnd file [m/s] (float)';
Data_IPT{irow+3,1}=sprintf('%2.1f',round(Wind.Speed*10)/10); Data_IPT{irow+3,2}=WindSpeedStr;
switch Wind.Type
    case 0
        WTstr='Steady';
    case 1
        WTstr='Turbulent';
    case 2
        WTstr='Other Stuff';
end
WindTypeStr='-	Wind.Type; Wind Type: Steady, Turb, ... (unquoted string)';
Data_IPT{irow+4,1}=WTstr; Data_IPT{irow+4,2}=WindTypeStr;

Data_IPT=writeAStructProps(Data_IPT,Wind,datastr);

end

function Data_IPT=getGeneralProps(General,Data_IPT)
datastr={'RunName','RunType','StartTime','EndTime','CutInTime','CutOutTime','OutputFlag','OutputStatsFlag','MainFolder','RunFolder'};
runname=General.RunName;
start=General.StartTime;
finish=General.EndTime;
cutintime=General.CutInTime;
cutouttime=General.CutOutTime;
if isempty(strfind(runname,'RAO'))
    numstrc=regexp(runname,'-?\d+\.?\d*|-?\d*\.?\d+','match');
    charstrc=regexp(runname,'-?\D+\.?\D*|-?\D*\.?\D+','match');
    if ~isempty(numstrc)
        numstr1=numstrc{1};
    end
    if ~isempty(charstrc)
        charstr1=charstrc{1};
    end
    if isempty(numstrc) % all characters
        RunType='foo';
        RunNum=runname;
    elseif length(numstr1)==length(runname) % all numbers
        RunType= sprintf('%2.1f', str2double(runname(1:2))/10);
        RunNum=runname;
    else %mix of characters and numbers
        if length(numstr1)>1
            RunType=sprintf('%2.1f', str2double(numstr1(1:2))/10);
        else
            RunType=numstr1(1);
        end
        RunNum=runname;
    end
else
    RunType= 'RAO';
    RunNum= runname;
end
irow=size(Data_IPT,1);
RunNumStr='-	General.RunName; Used in file naming';
Data_IPT{irow+1,1}=runname; Data_IPT{irow+1,2}=RunNumStr;%sprintf('%s%10s',RunNum,RunNumStr);
RunTypeStr='-	General.RunType; RAO or DLC number (unquoted string or float for DLC)';
Data_IPT{irow+2,1}=RunType; Data_IPT{irow+2,2}=RunTypeStr;
TimeStartStr=  '-	General.StartTime; Time to start simulation, set OrcaFlex [s] (float)';
TimeFinishStr='-	General.EndTime; Time to finish simulation, set in .fst file [s] (float)';
Data_IPT{irow+3,1}=sprintf('%d',start); Data_IPT{irow+3,2}=TimeStartStr;
Data_IPT{irow+4,1}=sprintf('%d',finish); Data_IPT{irow+4,2}=TimeFinishStr;
CutInTimeStr=  '-	General.CutInTime; Transient cut-in time, which is cut from yawfix and stats.m [s] (float)';
Data_IPT{irow+5,1}=sprintf('%4.2f',cutintime); Data_IPT{irow+5,2}=CutInTimeStr;
CutOutTimeStr=  '-	General.CutOutTime; Transient cut-out time, which is cut from yawfix and stats.m [s] (float)';
Data_IPT{irow+6,1}=sprintf('%4.2f',cutouttime); Data_IPT{irow+6,2}=CutOutTimeStr;
iOFStr=  '-	General.OutputFlag; [-] (logical)';
Data_IPT{irow+7,1}=sprintf('%d',General.OutputFlag); Data_IPT{irow+7,2}=iOFStr; %has to be 
iOSFStr=  '-	General.OutputStatsFlag; [-] (logical)';
Data_IPT{irow+8,1}=sprintf('%d',General.OutputFlag); Data_IPT{irow+8,2}=iOSFStr;
MFStr=  '-	General.MainFolder; [-] (string)';
Data_IPT{irow+9,1}=sprintf('%s',General.MainFolder); Data_IPT{irow+9,2}=MFStr;

% MainDirStr='-	General.MainFolder; Used in file naming';
% Data_IPT{irow+6,1}=General.MainFolder; Data_IPT{irow+6,2}=MainDirStr;
% PrefixStr='-	General.RunPrefix; Word to put in front of RunNumber for naming (string)';
FolderStr='-	General.RunFolder; Directory where results are saved (string)';
Data_IPT{irow+10,1}=sprintf('%s',General.RunFolder); Data_IPT{irow+10,2}=FolderStr;
% Data_IPT{irow+6,1}=FolderStr; Data_IPT{irow+6,2}=FolderStr;

Data_IPT=writeAStructProps(Data_IPT,General,datastr);
end

function Turbine=getBlankTurbine()
Turbine.Code='N/A';
Turbine.Overhang=9999;
Turbine.Tilt=9999;
Turbine.Yaw=9999;
end

function Data=writeAStructProps(Data,AStruct,datastr)
irow=size(Data,1);
%check all fields and subfields of Astruct
f1names=fieldnames(AStruct);
nf1=length(f1names);
nrow=1;
for ii=1:nf1
    try
        f2names=fieldnames(AStruct.(f1names{ii}));
    catch
        f2names='';
    end
    nf2=length(f2names);
    % try not to store anything more than 2 structures deep!   
    myvar=AStruct.(f1names{ii});
    istr=ischar(myvar);
   if ~sum(strncmpi(datastr,f1names{ii},length(f1names{ii}))) && ~nf2 && (~iscell(myvar)  || istr)
       % try not to store an array that is more than 3 
       
       if ischar(AStruct.(f1names{ii})) || length(AStruct.(f1names{ii}))<4
            fmtstr=getfmt(myvar);
            Data{irow+nrow,1}=sprintf(fmtstr,myvar); Data{irow+nrow,2}=sprintf('-	%s.%s;',inputname(2),f1names{ii} ) ;%
            nrow=nrow+1;
       end
   elseif nf2>0
       for jj=1:nf2   
            myvar=AStruct.(f1names{ii}).(f2names{jj});
            istr=ischar(myvar);
            [nrows,ncols]=size(myvar);
            try
                f3names=fieldnames(AStruct.(f1names{ii}).(f2names{jj}));
            catch
                f3names='';
            end
            if (nrows<2 && ncols<4) && (~iscell(myvar)  || istr) 
                varstr=[f1names{ii} '.' f2names{jj}];
                if isempty(f3names) && ~sum(strncmpi(datastr,varstr,length(varstr)))
                    fmtstr=getfmt(myvar);
                    Data{irow+nrow,1}=sprintf(fmtstr',myvar); Data{irow+nrow,2}=sprintf('-	%s.%s.%s;',inputname(2),f1names{ii},f2names{jj}) ;%
                    nrow=nrow+1;
                end
            end
       end
                    
           
   end
    
end

function str=getfmt(input)
if ischar(input)
    str='%s';
elseif mod(input,1)==0
    nd=length(input);
    if nd==1
        str='%d';
    else
        str=repmat('%1.6G,',[1 nd]);
        str=str(1:end-1);
    end
else
    nd=length(input);
    if input>1e3
        nstr='%1.4G';
    else
        nstr='%4.2f';
    end
    if nd==1
        str=nstr;
    else
        str=repmat([nstr ','],[1 nd]);
        str=str(1:end-1);
    end
end
end

end