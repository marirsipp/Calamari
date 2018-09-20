function [Damage1hr,Damage1hrF,ArcLength,LineType]=getMLdamage(infile,FatLife,standard,tcutoff,omega,specLines,varargin)
% taking in a .sim or an outputs.mat this function
% outputs an array with nNodes x nML with the calculated damage at each
% node
% tcutoff=3; %[s] 
% omega=10; %[rad/s]? 
iPrint=0;
if nargin>6
    iPrint=varargin{1};
end
Wn=1./tcutoff/(omega/2); % wtf is this freq Cyril?
[mypath,filename, ext] = fileparts(infile);
if strcmp(ext,'.sim')
    Ptfm=getMyPtfm('WFA');
    Turbine=getMyTurbine('Vestas_8MW');
    disp('extracting data. Why did you not use RunOF codes?')
    [Res,ResUnits]=extractSIM(FileData(ss).pathname(1:end-4),Ptfm,Turbine);
    
elseif strcmp(ext,'.mat')
    Res=load(infile);
    ResUnits=Res.Units;
end
slashes=strfind(infile,filesep);
PDir=infile( slashes(end-1)+1:slashes(end)-1  ); %usually the Runname
% find mooring line tensions at each node
headers=fieldnames(Res);
iML= find(~cellfun('isempty',strfind(headers,'EffT'))); %all mooring lines ~ CG: if the routine is slow, we might want to add an input line in the input file defining which line is to be analyzed 
EffTstr=headers(iML);
nML=length(iML);
% out =  regexp(EffTstr,'\d*','match'); % cell array with integers extracted from header lines
% mlnodenums=cellfun(@str2num,cat(1,out{:})); % 1st col corresponds to ML num, second col to node num
% [MLnums,~,idx] = unique(mlnodenums(:,1),'rows');
% nML=max(MLnums);
% maxNodes = accumarray(idx,mlnodenums(:,2),[],@max); % thank you internet
% make an array of the tensions: nML x nNodes
if isfield(Res,'CutInTime')
% else %this should not be here
%    tstrs=inputdlg({'Time to start truncation','Time to end truncation'}, 'Time Truncation',1,{num2str(round(min(Res.time))), num2str(round(max(Res.time)))});
%    Res.CutInTime= str2num(tstrs{1}); Res.CutInTime= str2num(tstrs{2});
     dT=Res.time(end)-Res.CutInTime; %CG: let's cut the build up automatically for scaling the samage to 1hour
     
else %but here
    dT=Res.time(end)-Res.time(1); %CG: if no buid up, no cut
end
iCut=Res.time >= Res.CutInTime & Res.time <= Res.CutOutTime;
time=Res.time(iCut);
nNodes2Use=20;
Damage1hr=nan(nNodes2Use,nML); % only grab about 20 nodes, make sure they are well distributed and are at the beginning and end of each section
Damage1hrF=nan(nNodes2Use,nML); % only grab about 20 nodes, make sure they are well distributed and are at the beginning and end of each section
ArcLength=nan(nNodes2Use,nML);
LineType=cell(nNodes2Use,nML);
for mm=1:nML
    if iPrint
        disp(['  ' sprintf('%d')]) 
        disp(['--Mooring Line ' sprintf('%d',mm) '--']) %CG: added a printf to show which line is being analyzed 
    end  
    effTname=EffTstr{mm};
    lineTname=sprintf('ml%dLineType',mm);
    arcLname=sprintf('ml%dArcL',mm);
    timeseriesmat=Res.(effTname);
    lineTypes=Res.(lineTname);
    arcLengths=Res.(arcLname);
    if isfield(Res,[arcLname 'TDP'])
        iTDP=1;
        arcLTDP=Res.([arcLname 'TDP']);
    else
        iTDP=0;
    end
    %% Artificially change the composition of the line to test a different configuration
%     iChange=find(arcLengths>= 75 & arcLengths<=200 & strcmp(lineTypes,'3.25" ORQ Chain'));
%     for ii=1:length(iChange)
%         lineTypes{iChange(ii)}='4.5" ORQ Chain';
%     end

    nNodes=size(timeseriesmat,2);
    nLT=size(lineTypes,2);
    if nLT<nNodes
        lineTypes=[lineTypes lineTypes(end)];
    end
    %get the nodes that correspond to changes in the linetypes
    iChange=find(~strcmp(lineTypes(1:end-1),lineTypes(2:end)));
    %[uLineTypes,iChange,foobar]=union(lineTypes(1:end-1),lineTypes(2:end),'stable'); % assume that you don't have a line type change on the very last node
    iChange=iChange'+1;
    iChange=[1; iChange; nNodes]; % add in the first and last nodes
    nChange=length(iChange);
    nFill=max([ 1 floor(nNodes2Use/nChange)]);
    nodes2use=nan(nNodes2Use,1);
    for ii=1:nChange-1
        iF=(ii-1)*nFill+1;
        nodes2use(iF:nFill+iF-1,1)=round(linspace(iChange(ii),iChange(ii+1)-1,nFill)); % make sure you get the first and last node of each line type
    end
    nodes2use(nFill+iF)=iChange(end);
    nodes2use=nodes2use(~isnan(nodes2use));
    nNodes2use=length(nodes2use);
    LineTypeOld='';
    for nn=1:nNodes2use
        nnode=nodes2use(nn);
        timeseries=timeseriesmat(iCut,nnode); % should I filter this? 
        LineType{nn,mm} = lineTypes{nnode};
        chainDcell=  regexp(LineType{nn,mm},'[-+]?\d*\.?\d*"','match');
        if ~isempty(chainDcell)
            chainDstr=chainDcell{1};
            chainD=str2num(chainDstr(1:end-1));
        else
            if iPrint
                warning(['Chain line type: ' LineType{nn,mm} ' does not have a number representing the diameter in its name. Just using 4" for now.'])
            end
            chainD=4;% in
        end
        ArcLength(nn,mm) = arcLengths(nnode);
        if iTDP
            if ArcLength(nn,mm)< max(arcLTDP) % A BETTER WAY TO DETERMINE TDP -> CORROSION RATE
                corrR=0.4; % you are above the TDP
            else
                corrR=0.2;
            end
        else
            if chainD>=4.5      %CG:took the limit from 6" down to 4.5" to be more conservative
                corrR=0.4;
            else
                corrR=0.2;
            end
        end
        %% VERY SPECIFC WAYS A MOORING LINE TYPE MUST BE NAMED IN ORCAFLEX
        %% IT MUST INCLUDE THE FOLLOWING WORDS
        % 'Chain' or 'Rope' or 'Dyneema'
        % IF 'Chain', then 'Studless' or 'Studlink'
        % IF 'Chain', the grade: 'R5', 'R4','R3', or 'ORQ'
        % IF 'Chain, then the diameter in inches, which should be written as #". (that is a
        % number, which could be a float with a " immediately following the number to represent inches)

        chaindiacell=  regexp(LineType{nn,mm},'[-+]?\d*\.?\d*"','match');
        if ~isempty(strfind(LineType{nn,mm},'Chain')) || ~isempty(strfind(LineType{nn,mm},'chain'))
            if length(chaindiacell)>1
                error('Please only include 1 number with a " after to describe chain in linetype name to represent diameter')
            elseif isempty(chaindiacell)
                error('Cannot find chain diameter in LineType name. Please include chain link diam in inches with a " after the number')
            end  
        end
        if ~isempty(chaindiacell)
            chaindiastr=chaindiacell{1};
            dia=str2num(chaindiastr(1:end-1));
        %% take into account corrosion in the interpolation
        else
            dia=4; % make something up. Diameter not taken into account for Dyneema, for example.
        end
        %% SPECIAL LineTypes!!
        iSp= find(~cellfun('isempty',strfind(specLines.Types,LineType{nn,mm})));
        if isempty(iSp)
             iMBL=-1;
        else
            if isfield(specLines,'iMBLs')
                iMBL=specLines.iMBLs(iSp);
            else
                warning('Must specify type of overwrite you would like')
                iMBL=1;
            end
        end
        if iMBL==2
            corrR = specLines.CorrRs(iSp); % overwrite corrosion rate
        end
        dia2use = dia*.0254*1e3 - .5*FatLife*corrR ; %% Need to have different Fatigue life coefficients per Standard
        if iMBL==1
            SNcurve.MBS = specLines.MBLs(iSp); % overwite MBL
        else
            SNcurve=SNlibrary(LineType{nn,mm},dia2use,standard);             
        end
        % overwrite lineType properties!!
        if iMBL>=0
            SNcurve.A = specLines.As(iSp); % overwrite K
            SNcurve.m = specLines.Ms(iSp); % overwrite m
        end
        %% Display what properties you are using and run RainflowExe (CG : for first bin, first seed)
        if iPrint            
            if ~strcmp(LineType{nn,mm},LineTypeOld)
                if iMBL>=0
                    disp(['Found special linetype: ' LineType{nn,mm} ' with special type ' sprintf('%d',iMBL)])
                end
                disp(['Using ' sprintf('MBS=%1.4E, K=%1.1f, m=%1.1f',SNcurve.MBS,SNcurve.A,SNcurve.m) ' for ' LineType{nn,mm}])
            end
            disp(['Running Rainflow counting for ' PDir ' on variable ' effTname ' Node #' num2str(nnode) ', with LineType ' LineType{nn,mm} ])
        else
            if nn==1 && mm==1 %(CG : rest of the time, only display general progress)
                disp([ 'Running Rainflow counting for ' PDir ])
            end
        end
        
        Damage1hr(nn,mm) = runRainflowExe(timeseries, SNcurve)*3600/dT;
        Damage1hrF(nn,mm) = runRainflowExe(FilterFunc(Wn,timeseries,1), SNcurve)*3600/dT;%Low pass filter, get rid of numerical
        
        if iPrint && nn==1 && mm==3 %CG: Let's add a plotting feature here to check the time series (could be improved)
              
             close all             
            figure('Name',['Check Timeseries and Cycles for ' PDir ])
            subplot(1,3,1)           
            hold on 
            grid on
            timeseries=timeseries/1000;
            plot(time, timeseries,'b');
            filttimeseries=FilterFunc(Wn,timeseries,1);
            plot(time(1:length(filttimeseries)),filttimeseries,'r');
            xlabel('Time (s)');
            ylabel('Tension (kN)');
            title(' TS of Tension at ML Top');
            legend('Raw TS','Filtered TS')
            
            subplot(1,3,2)
            [freq, energy] = SpecDen(time(1:length(timeseries)),timeseries);
            semilogy(freq,abs(energy),'b');
            hold on
            [freq, energy] = SpecDen(time(1:length(filttimeseries)),filttimeseries);
            semilogy(freq,abs(energy),'r');
            hold on 
            xlabel('Frequency (Hz)');
            ylabel('Energy');
            title(' Spectral Density of Tension at ML Top');
            grid on
            xlim([0 1]);
            legend('Raw TS','Filtered TS')

            
            [ NCHfilt,NCfilt ] = rainflowdotexe( filttimeseries );
            SLfilt=[ NCHfilt;NCfilt ];
            subplot(2,3,3)
            hold on
            grid on 
            plot(NCHfilt,'-or','LineWidth',1)
            xlabel('Half Cycle Count');
            ylabel('Amplitude (kN)');
            title('Half Cycles');
            legend('Filtered TS')

            subplot(2,3,6)
            hold on
            grid on
            plot(NCfilt,'-or','LineWidth',2)
            xlabel('Full Cycle Count');
            ylabel('Amplitude (kN)');
            title('Full Cycles');
            legend('Filtered TS')

                

            
        end
        
        LineTypeOld=LineType{nn,mm};
    end
end
emptyrow=sum(isnan(Damage1hr),2)==nML;
Damage1hr=Damage1hr(~emptyrow,:);
Damage1hrF=Damage1hrF(~emptyrow,:);
ArcLength=ArcLength(~emptyrow,:);
LineType=LineType(~emptyrow,:);
end
