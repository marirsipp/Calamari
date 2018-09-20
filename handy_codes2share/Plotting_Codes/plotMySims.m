function plotMySims(varargin)
%% Description
%  Plots Results from user chosen *.out or *.outb or .sim file(s) from OrcaFAST or OrcaFlex. A plot is
%   created for each result chosen
% Written by Sam Kanner and Alan Lum
% Copyright Principle Power Inc., 2016
%% Variables2Define
%  Required: None -> the script will help you select a file(s)
%  Optional: You can input a cell of strings with the absolute locations of
%  the .sim or .outb's you want to plot
%% TODO:
% add COLtrack+WEPtrack to the plot. 

colorstr={[0 0 1], [1 0 1],[1 0 0],[1 1 0],[0 1 0],[0 1 1],[.6 .6 0],[0 .6 .6],[.3 0 .3],[.6 0 .6]};
colorstrL={'b','m','r','g','k','y'};
nSim=0;
iLoop=true;
nGroup=5;
lf=1;
scol='k';
motionNames={'Surge','Sway','Heave','Roll','Pitch','Yaw','Tower'};
xstr={'X','Y','Z','\theta_{roll}','\theta_{pitch}','\theta_{yaw}'};

iLikeLines=0;
if nargin>0
    % you have entered a list of input files
    if nargin==1
        if iscell(varargin{1})
            allsims=varargin{1};
            nuSim=length(allsims);
        else
            nuSim=1;
        end
    else
        nuSim=nargin; 
    end
    for jj=1:nuSim
        if iscell(varargin{1})
            %then we are inputing a cell array of strings
            fullfile=allsims{jj};                    
        else
            fullfile=varargin{jj};
        end 
        if exist(fullfile,'file')
            nSim=nSim+1;
            slashes=strfind(fullfile,filesep);
            out_name{nSim}=fullfile(slashes(end)+1:end);
            [mypath{nSim}, FileData(nSim).filename, FileData(nSim).ext] = fileparts(fullfile);
            mypath{nSim}=[mypath{nSim} filesep];
            
            FileData(nSim).pathname=[mypath{nSim}, out_name{nSim}];
        else
            warning([fullfile ' does not exist. Moving on...'])
        end
    end
else
    nSim=1;
    while iLoop
        %% Initialization and Parameters
        filetypes={'*.out;*.outb;*.elm;*.sim;*.mat;'};
        %what if you want to plot both .outb and .sim at once?!?
        [out_name_raw, mypath_raw]= uigetfile(filetypes,'Select output file (Dot Sims take 10x longer to load than Dot Outbs. Be careful!)','MultiSelect','on');        
        if ~iscell(out_name_raw)            
            out_name{nSim}=out_name_raw;
            mypath{nSim}=mypath_raw;
            [~, FileData(nSim).filename, FileData(nSim).ext] = fileparts(out_name{nSim});
            FileData(nSim).pathname=[mypath{nSim} out_name{nSim}];
            qstr='Plot Another Sim?';
        else
            qstr='Plot More Simulations?';
            nSim_raw=length(out_name_raw); % it is a cell of strings
            for pp=0:nSim_raw-1
               out_name{nSim+pp}=out_name_raw{pp+1};
               [~, FileData(nSim+pp).filename, FileData(nSim+pp).ext] = fileparts(out_name{nSim+pp});
               mypath{nSim+pp}=mypath_raw;
               FileData(nSim+pp).pathname=[mypath{nSim+pp} out_name{nSim+pp}];
            end
            nSim=nSim+nSim_raw-1;
        end        
        nstr = questdlg(qstr,'Compare Simulations');
        if strcmp(nstr, 'Yes')
            nSim=nSim+1;
        else
            iLoop=false;
        end
    end
end

% Get parent directory of file
for ss=1:nSim
    jpath=mypath{ss};
    slashes=strfind(jpath,filesep);
    FileData(ss).FullPath=jpath;
    FileData(ss).PDir=jpath( slashes(end-1)+1:end-1  ); %usually the Runname
    FileData(ss).PPDir=jpath( slashes(end-2)+1:slashes(end-1)-1  ); %usually the RunFolder name
    FileData(ss).HomeDir=jpath(1:slashes(end-1)-1  ); % usually the folder Runs, absolute path
%     if length(slashes)>4
%         FileData(ss).PHomeDir=jpath( slashes(end-3)+1:slashes(end-2)-1  ); % usually the folder for the project: e.g. 'Vestas_8MW'
%     end
end

if ~isempty(out_name)
    %% Get complimentary Force Excursion file
    FileData=findFExcrns(FileData);%); %assume that you are using outputs.mat 
    %% Initialize
    nSim=length(FileData); %rewrite number of simulations
    ss2use=1:nSim;
    nF=0;
    Fig{1,1}=nan; %poor memory storage!!
    Fig{1,2}='';
    iDOF=zeros(1,nSim);
    iSD=0; %logical for spectral density
    iFE=zeros(nSim,1);
    iFD=zeros(nSim,1);
    iSDE=zeros(nSim,1);
    for ss=1:nSim
        %%  get info from the user
        if strcmp(FileData(ss).ext,'.mat')
            FileData(ss).name=FileData(ss).PDir; %mydir
            iLikeLines=0;
        else
            if ss==1   
                % figure out the naming scheme
                fstr = questdlg('How are the simulation results files named?','Naming Scheme','Unique Filenames','Parent Directory','Neither (enter manually)','Parent Directory');
            else
                disp('Loading data...')
            end
            switch fstr
                case 'Parent Directory'          
                    % assume that the run name is the name of the upper directory
                    FileData(ss).name=FileData(ss).PDir; %mydir
                case 'Unique Filenames'
                    FileData(ss).name=FileData(ss).filename;
                case 'Neither (enter manually)'
                    jstr=inputdlg(['Enter name for ' FileData(ss).pathname] , ['File Dir: ' FileData(ss).PDir ],1,{'foo'});
                    FileData(ss).name=jstr{1};
            end
            iLikeLines=1;
        end
%         if ss==1 && nSim>1
%             linestr = questdlg('Do you want to plot results from line members?','Be careful - there will be lots of options');
%             if strcmp(linestr, 'Yes')
%                 iLikeLines=1;
%             end
%         end
        %% get all of the possible data from the file
        if strncmp(FileData(ss).ext, '.outb', 5) 
            %you want to plot a FAST out binary
            % use NREL's code to parse the data
            [data, headers, units] = ReadFASTbinary(FileData(ss).pathname);
            iTime=1;
        elseif strncmp(FileData(ss).ext, '.sim', 4)
            %display('Using WF geometry ')
            %you want to plot an orcaflex sim
            %SIMname=[mypath{ss}, out_name{ss}];
            %look in the the same folder for an opt file with the same
            %runname
            optfile=[FileData(ss).HomeDir filesep FileData(ss).PDir filesep FileData(ss).name '.opt'];
            if exist(optfile,'file')
                 %I could negate the use of needing an IPT file by using
                 %this function to generate Ptfm and Turbine structures
                 %from opt file (assuming that RunOF was used)
                 [Ptfm,Wind,Wave,Cur,General,Turbine,foo]=generateInputListfromOPT(optfile);
                 [Res,ResUnits]=extractSIM(FileData(ss).pathname(1:end-4),Ptfm,Turbine,General,Wind);
            else 
                %% Get project-specific 
                iptname=getIPTname(mfilename);
                run(iptname);
                % Import WF + Turbine Dimensions from ipt.m file
                Ptfm=getMyPtfm(PtfmName);
                Turbine=getMyTurbine(TurbineName);
                [Res,ResUnits]=extractSIM(FileData(ss).pathname(1:end-4),Ptfm,Turbine);
            end

            [data,headers,units]=readRes(Res,ResUnits,iLikeLines); % -> all data are 1D time series!!
            iTime=1;
        elseif strncmp(FileData(ss).ext, '.mat',4)
            if strcmp(FileData(ss).filename,'outputs')
                Res=load(FileData(ss).pathname);
                ResUnits=Res.Units;
                [data,headers,units]=readRes(Res,ResUnits,iLikeLines); % -> all data are 1D time series!!
                %[data,headers,units]=readOutputs([mypath{ss}, out_name{ss}]); %this is a time series
                iTime=1;
            elseif strcmp(FileData(ss).filename,'stats')
                Data(ss)=readStatsDotMat(FileData(ss).pathname); %this is a structure with 1-D subfields
                iTime=0;
                disp('Cannot choose a time truncation using "stats.mat", use "outputs.mat" or the .sim instead')
            else
                error('Can only read in "outputs.mat" or "stats.mat". Please select one of these')
            end
            
        elseif strncmp(FileData(ss).ext, '.elm', 4)  
            [data,headers,units]=readFASTtext(FileData(ss).pathname);
            iTime=1;
        else
            % you want to plot a FAST text file
            [data,headers,units]=readFASTtext([mypath{ss}, out_name{ss}]);
            iTime=1;
        end
        if iTime
             % get time and remove it from the data

            it= find(~cellfun('isempty',strfind(headers,'time')));
            if isempty(it)
                it= find(~cellfun('isempty',strfind(headers,'Time'))); % capitalized in outb
            end
            rawtime = data(:,it);
            rawdata=data(:,it+1:end);
            Data(ss).headers=headers(it+1:end);
            Data(ss).units=units(it+1:end); 
             ico=find(~cellfun('isempty',strfind(Data(ss).headers,'CutOutTime')));
             ici=find(~cellfun('isempty',strfind(Data(ss).headers,'CutInTime')));
            if ~isempty(ici)
                cutin=squeeze(rawdata(1,ici));
                cutout=squeeze(rawdata(1,ico));
            else                
                cutin=rawtime(1);
                cutout=rawtime(end);
            end
            % By default:
            tin=cutin;
            tout=cutout;

            if strfind(FileData(ss).name,'FDecay')%strncmp(FileData(ss).name,'FDecay',length('FDecay'))
                iFD(ss)=1;
                iType=1;
                FileData(ss).name=FileData(ss).PPDir; % use the run directory's name
            end
            if strfind(FileData(ss).name,'FExcrn')
                iFE(ss)=1;
                iType=3;
                FileData(ss).name=FileData(ss).PPDir; % use the run directory's name
            end
            if strfind(FileData(ss).name,'Shtdwn')%
                iSDE(ss)=1;
                iType=1;
            end
            iSpecial = iFD(ss) || iFE(ss) || iSDE(ss);
            if ~iSpecial
                if ss==1 % THIS ASSUMES THAT THE OUTPUTS OR THE STATS ARE ORDERED IN THE SAME WAY

                    typestr = questdlg('What type of plot would you like?','Plot Type (Use Stats if nSims>10)','Time Series','Statistics (bars)','Mooring Table','Time Series');
                    if strcmp(typestr,'Statistics (bars)')
                        iType=2;
                        tstrs=inputdlg({'Time to start truncation','Time to end truncation'}, 'Time Truncation',1,{num2str(round(cutin)), num2str(round(cutout))});
                    elseif strcmp(typestr,'Time Series')
                        iType=1;
                        SDstr = questdlg('Plot Spectral Density?','Spectral Density');
                        % if the user selects no data or cancels the spec density question 
                        if strcmp(SDstr, 'Cancel')
                            error('User Cancelled')
                        elseif strcmp(SDstr, 'Yes')
                            iSD=1;
                        elseif strcmp(SDstr, 'No')
                            %foo
                        end
                        tstrs=inputdlg({'Time to start truncation','Time to end truncation'}, 'Time Truncation',1,{num2str(round(cutin)), num2str(round(cutout))});                        
                    elseif strcmp(typestr,'Mooring Table')
                        iType=4;
                        tin=min(rawtime);
                        tout=max(rawtime);
                        tstrsMT=inputdlg({'Initial Time','Time to start truncation','Time to end truncation'}, 'Time Truncation: Only used for STD(Yaw) Critera',1,{num2str(0),num2str(round(cutin)), num2str(round(cutout))});
                    end
                    % ask the user what data to plot
                    if iType<3
                        [iChoice, isOK] = listdlg('PromptString','Select results to plot', 'Name', 'Variables available', 'ListString', Data(ss).headers,'SelectionMode', 'Multiple');
                        if ~isOK 
                            error('User Cancelled')
                        end  
                    elseif iType==4
                        % max(SURGE/SWAY)-SURGE/SWAY (t0), std(YAW), max(AnchorEffT),
                        % max(PreT), max(UpliftAngle),
                        % max(AnchorAngle)-min(AnchorAngle)
                        
                        iTable{1} =find(~cellfun('isempty',strfind(Data(ss).headers,'motionsXY'))); % <20 m
                        if isempty(iTable{1})
                            iTable{1} =find(~cellfun('isempty',strfind(Data(ss).headers,'motionXY'))); % <20 m
                        end
                        iTable{2} =find(~cellfun('isempty',strfind(Data(ss).headers,'motions6'))); %  < std of 3 deg 
                        if isempty(iTable{2})
                             iTable{2} =find(~cellfun('isempty',strfind(Data(ss).headers,'motion6'))); 
                        end
                        iallnodes= find(~cellfun('isempty',strfind(Data(ss).headers,'AnchorEffT'))); % < Bridle tension
%                         EffTstr=Data(ss).headers(iallnodes);
%                         out =  regexp(EffTstr,'\d*','match'); % cell array with integers extracted from header lines
%                         mlnodenums=cellfun(@str2num,cat(1,out{:})); % 1st col corresponds to ML num, second col to node num
%                         if size(mlnodenums,2)==1
%                             %backwards compatible
%                             iTable{3} = iallnodes;
%                         elseif size(mlnodenums,2)==2
%                             % for each mooring line, need to find the last
%                             % node (node with largest number)
%                             [MLnums,~,idx] = unique(mlnodenums(:,1),'rows');
%                             iendNodes = accumarray(idx,[1:size(mlnodenums,1)]',[],@(x) findmax(x,mlnodenums(:,2))); % look Mom, no for loop! thank you internet
%                             iTable{3}=iallnodes(iendNodes);
%                         end
                        iTable{3} = iallnodes;
                        nML=size(rawdata(:,iTable{3}),2);
                        Mls=1:nML;
                        isBr=0;
                        nBr=0;
                        iAn=1:nML; iBr=[]; iFL=iAn; % assume no bridles, all lines are fairlead->anchor
                        if nML>4
                            % then you have some bridles?
                            isBr=1;
                            iTable{isBr+3} = find(~cellfun('isempty',strfind(Data(ss).headers,'AnchorEffT'))); % < bollard pull
                            if isempty(iTable{isBr+3})
                                iTable{isBr+3} = iTable{3}; % < bollard pull
                            end
                            mlnames=cellfun(@(s) s(1:3),Data(ss).headers(iTable{3}), 'uni',false);
                            [iAn, isOK] = listdlg('PromptString','Select anchored lines', 'Name', 'Mooring Lines available', 'ListString', mlnames,'SelectionMode', 'Multiple','ListSize',[225 150]);
                            iFL=Mls(~ismember(Mls,iAn));
                            [iFL, isOK] = listdlg('PromptString','Select lines connected to platform', 'Name', 'Mooring Lines available', 'ListString', mlnames,'SelectionMode', 'Multiple','ListSize',[225 150],'InitialValue',iFL);

                            iBr=Mls(~ismember(Mls,iAn)); % lines that are connected to a bridle (are the ones that are not anchored)
                            %Brstrs=inputdlg({'Select Anchored '}, 'Number of Mooring Lines',1,{num2str(3)});
                            nFL=length(iFL);
                            nBr=length(iBr);
                        end
                        iTable{isBr+4} = find(~cellfun('isempty',strfind(Data(ss).headers,'PreT'))); % <MBL of top line
                        iTable{isBr+5} = find(~cellfun('isempty',strfind(Data(ss).headers,'UpliftAngle'))); % < 1  deg
                        iTable{isBr+6} = find(~cellfun('isempty',strfind(Data(ss).headers,'AnchorAngle'))); % < pm 30 deg  
                        %mdlg=text('string',{'Max surge/sway offset (m)','Max stdev of yaw (deg)','Max anchor chain T (N)','Max top tension (static, N)','Max uplift angle (deg)','Max anchor angle ($\pm$ deg)','interpreter','tex'})
                        if isBr
                            mstrs=inputdlg({'Max surge/sway offset (m)','Max stdev of yaw (deg)','Max bridle T (N)','Max anchor chain T (N)','Max top tension (static, N)','Max uplift angle (deg)','Max anchor angle (plus/min deg)'}, 'Mooring Design Criteria',1,{num2str(12), num2str(3),num2str(560*1e3*9.8,'%1.1E'),num2str(260*1e3*9.8,'%1.1E'),num2str(50*1e3*9.8,'%1.1E'),num2str(1e0,'%1.1E'),num2str(30)});
                        else
                            mstrs=inputdlg({'Max surge/sway offset (m)','Max stdev of yaw (deg)','Max anchor chain T (N)','Max top tension (static, N)','Max uplift angle (deg)','Max anchor angle (plus/min deg)'}, 'Mooring Design Criteria',1,{num2str(12), num2str(3),num2str(260*1e3*9.8,'%1.1E'),num2str(50*1e3*9.8,'%1.1E'),num2str(1e0,'%1.1E'),num2str(30)});
                        end                            
                        for pp=1:length(mstrs)
                            MLcrit(pp)=str2num(mstrs{pp}); 
                        end
                        %MLcrit(2)=str2num(mstrs{2}); MLcrit(3)=str2num(mstrs{3}); MLcrit(4)=str2num(mstrs{4}); MLcrit(5)=str2num(mstrs{5}); MLcrit(6)=str2num(mstrs{6});

                    end
                else
                    if iType==4
                        iallnodes= find(~cellfun('isempty',strfind(Data(ss).headers,'AnchorEffT'))); % < Bridle tension
                        %EffTstr=Data(ss).headers(iallnodes);
                        %out =  regexp(EffTstr,'\d*','match'); % cell array with integers extracted from header lines
                        %mlnodenums=cellfun(@str2num,cat(1,out{:})); % 1st col corresponds to ML num, second col to node num
%                         if size(mlnodenums,2)==1
%                             %backwards compatible
%                             iTable{3} = iallnodes;
%                         elseif size(mlnodenums,2)==2
%                             % for each mooring line, need to find the last
%                             % node (node with largest number)
% %                             [MLnums,~,idx] = unique(mlnodenums(:,1),'rows');
% %                             iendNodes = accumarray(idx,[1:size(mlnodenums,1)]',[],@(x) findmax(x,mlnodenums(:,2))); % look Mom, no for loop! thank you internet
% %                             iTable{3}=iallnodes(iendNodes);
%                         end
                        iTable{3} = iallnodes;
                        iTable{isBr+4} = find(~cellfun('isempty',strfind(Data(ss).headers,'PreT'))); % <MBL of top line
                        iTable{isBr+5} = find(~cellfun('isempty',strfind(Data(ss).headers,'UpliftAngle'))); % < 1  deg
                        iTable{isBr+6} = find(~cellfun('isempty',strfind(Data(ss).headers,'AnchorAngle'))); % < pm 30 deg  
                    end
                end
                if iType==4
                    nTable=length(iTable);
                    iChoice=[iTable{:}];
                    iNTable=cellfun('length',iTable);  
                end
                if exist('tstrs','var')
                    %then overwrite cutttime
                    tin=str2num(tstrs{1});
                    tout=str2num(tstrs{2});
                elseif exist('tstrsMT','var')
                    tin=str2num(tstrsMT{1});
                    tinT=str2num(tstrsMT{2});
                    tout=str2num(tstrsMT{3});                    
                end
                iTrunc=rawtime>=tin & rawtime<=tout;
            elseif iFD(ss)
                 istr=strfind(FileData(ss).PDir,'FDecay');
                 Runnum=str2double(regexp(FileData(ss).PDir,['\d+\.?\d*'],'match'));
                 iDOF(ss)=Runnum(end-1);%str2double(FileData(ss).PDir(istr+length('FDecay')));
                 iIter(ss)=Runnum(end);%str2double(FileData(ss).PDir(end));
                 if iDOF(ss)<7
                    iChoice=find(~cellfun('isempty',strfind(Data(ss).headers,['motions' num2str(iDOF(ss))])));
                 elseif iDOF(ss)==7
                     iSD=1;
                     iChoice=find(~cellfun('isempty',strfind(Data(ss).headers,['accelRNA' num2str(iIter(ss))])));
                     if isempty(iChoice)
                         % you ran FAST
                         iChoice=find(~cellfun('isempty',strfind(Data(ss).headers,['naccel' num2str(iIter(ss))])));
                     end
                 end
                 iTrunc=rawtime>=tin & rawtime<=tout;
            elseif iFE(ss)
                istr=strfind(FileData(ss).PDir,'FExcrn');
                iDOF(ss)=str2double(FileData(ss).PDir(istr+length('FExcrn')));
                i2=find(~cellfun('isempty',strfind(Data(ss).headers,['motions' num2str(iDOF(ss))])));
                if isnan(iDOF(ss))
                    error(['Naming convention incorrect. Use FDecay# or FExcrn# where # is the DOF.'])
                else
                    i1=find(~cellfun('isempty',strfind(Data(ss).headers,'DecayForceTime')));%cellfun(@(s) strfind(s,'DecayForceTime'),Data(ss).headers);
                    i3=find(~cellfun('isempty',strfind(Data(ss).headers,'DecayForce')));%cellfun(@(s) strfind(s,'DecayForce'),Data(ss).headers);%strfind(Data(ss).headers,'DecayForce');
                    i3=i3(~ismember(i3,i1));
%                 elseif iDOF(ss)>3
%                     i1=find(~cellfun('isempty',strfind(Data(ss).headers,'DecayMomentTime')));%cellfun(@(s) strfind(s,'DecayMomentTime'),Data(ss).headers);%
%                     i3=find(~cellfun('isempty',strfind(Data(ss).headers,'DecayMoment')));%cellfun(@(s) strfind(s,'DecayMoment'),Data(ss).headers);          
%                     i3=i3(~ismember(i3,i1));
                end
                if length(i3)>1
                    error(['DecayForce should be a vector nSteps*2 x 1. It currently has length ' num2str(length(i3))])
                end
                iChoice=[i1 i2 i3];
                iTrunc=rawtime>=0 & rawtime<=max(rawtime); % we want the whole simulation (just in case the user messes up with CutTime)
            elseif iSDE(ss)
                 istr=strfind(FileData(1).name,'Shtdwn');
                 iWind(ss)=str2double(regexp(FileData(ss).name,'\d+','match'));
                 iDOF(ss)=5*abs(cosd(iWind(ss))) + 4*abs(sind(iWind(ss)));
                 iDOFt(ss)=1*abs(cosd(iWind(ss))) + 2*abs(sind(iWind(ss)));
                 if (iWind(ss)>=0 && iWind(ss)<90 )
                   nColNum=2; nColWEP=1;% iColTrack = 6; % or 10
                 elseif (iWind(ss)>=90 && iWind(ss)<180 )
                    nColNum=3; nColWEP=2;% iColTrack = 10;
                 elseif (iWind(ss)>=180 && iWind(ss)<270 )
                   nColNum=1; nColWEP=2;% or 3%  iColTrack =2;
                 elseif (iWind(ss)>=270 && iWind(ss)<360 )
                   nColNum=2; nColWEP=3; %iColTrack = 6;   
                 end
                 iChoice=[find(~cellfun('isempty',strfind(Data(ss).headers,['motions' num2str(iDOF(ss))])))...
                     find(~cellfun('isempty',strfind(Data(ss).headers,['accelRNA' num2str(iDOFt(ss))]))) ...
                     find(~cellfun('isempty',strfind(Data(ss).headers,['TwrBsMtRNA' num2str(iDOF(ss))]))) ...
                     find(~cellfun('isempty',strfind(Data(ss).headers,['motions6' ]))) ...
                     find(~cellfun('isempty',strfind(Data(ss).headers,['COLtrack' ]))) ... %num2str(iColTrack)
                     find(~cellfun('isempty',strfind(Data(ss).headers,['WEPtrack' ]))) ...
                     %num2str(iColTrack)
                     %find(~cellfun('isempty',strfind(Data(ss).headers,['accelRNA' num2str(iDOFt(ss))]))) ...
                     %find(~cellfun('isempty',strfind(Data(ss).headers,['COLtrack6']))) ... %
                     %find(~cellfun('isempty',strfind(Data(ss).headers,['COLtrack10']))) ...
                     ];
                 iTrunc=rawtime>=tin & rawtime<=tout;
            end
            Data(ss).time = rawtime(iTrunc);

            allmydata=rawdata(iTrunc,iChoice);  
            if iSDE(ss)
                nCol=3;
                nProbeCOL=4;
                nProbeWEP=5;
                nOthData=4;
                outputdatacol=mean(allmydata(:,nOthData+nProbeCOL*(nColNum-1)+1:nOthData+nProbeCOL*(nColNum-1)+nProbeCOL),2);
                allmydata=[allmydata(:,1:nOthData) outputdatacol allmydata(:,nOthData+nProbeCOL*nCol+1:end)];
                iChoice=[iChoice(1:nOthData) iChoice(nOthData+nColNum) iChoice(nOthData+nProbeCOL*nCol+1:end)];
                nOthData=nOthData+1;
                outputdatawep=max(allmydata(:,nOthData+nProbeWEP*(nColWEP-1)+1:nOthData+nProbeWEP*(nColWEP-1)+nProbeWEP),[],2);
                allmydata=[allmydata(:,1:nOthData) outputdatawep];
                iChoice=[iChoice(1:nOthData) iChoice(nOthData+nColWEP)];
            end
            %recover data that are not timeseries
            notTimeSeries=find(sum(isnan(allmydata),1));
            iT=iChoice(notTimeSeries);
            for tt=1:length(notTimeSeries)
                allTdata=rawdata(:,iT(tt));
                notTdata=allTdata(~isnan(allTdata));
                NnotT=length(notTdata);
                allmydata(1:NnotT,notTimeSeries(tt))=notTdata;
            end
        else
            if ss==1
            % ask the user what stats data to plot
                [iChoice, isOK] = listdlg('PromptString','Select results to plot', 'Name', 'Variables available', 'ListString', Data(ss).headers,'SelectionMode', 'Multiple');
                if ~isOK 
                    error('User Cancelled')
                end
            end
            %Data(ss).units=Data(ss).units{iChoice};
            Data(ss).Mean=[Data(ss).Mean{iChoice}];
            Data(ss).Min=[Data(ss).Min{iChoice}];
            Data(ss).Max=[Data(ss).Max{iChoice}];
            Data(ss).Std=[Data(ss).Std{iChoice}];
            iType=2;
        end
        switch iType
            case 1
                Data(ss).data=allmydata;
            case 2
               %mydata=Data(ss).data(:,jj); %-> Do not save time series if
               %you are just plotting stats!
               if iTime
                   Data(ss).Min=min(allmydata,[],1);
                   Data(ss).Max=max(allmydata,[],1);
                   Data(ss).Mean=mean(allmydata,1);
                   Data(ss).Std=std(allmydata,[],1); 
               else

               end
            case 3
                Data(ss).data=allmydata;
            case 4
                Data(ss).data=allmydata;
        end
        DataS=whos('Data');
            

    end
    % check the simulations loaded
    if iFD
        if sum(diff(iDOF))>0
            error('Why are you trying to plot Free-Decay tests with different Degrees of Freedom??')
        end
    elseif iFE
        uDOF=unique(iDOF);
        dirstrs = {FileData(:).PPDir};
        [uDirs,iDirs]=unique(dirstrs);
        nDirs=length(uDirs);
        %     ss=iDirs(ff);
%         fdir=dirstrs{ss};
%         fDirRuns={Data(strcmp(dirstrs,fdir)).PDir};
%         files = dir(Data(ss).HomeDir);
%         dirFlags = [files.isdir];
%         subFolders = files(dirFlags);
%         allrunstrs=cellfun(@(x) x(1:end-1),{subFolders(:).name},'UniformOutput',false);
%         nDirRuns=length(fDirRuns);
    end
    %% Plot the data!
    nChoices=length(iChoice);
    dSim=1;
    if iType==1 
            nFigs=nChoices*(iSD+1);
    elseif iType==2
        nFigs=nChoices;
    elseif iType==3
        %nFigs=floor(nSim/2);
        nFigs=length(uDOF);
        dSim=2;

    elseif iType==4
        nFigs=1;
    end
    %% Plot Time Series
    %for dd=0:iSD 
    for ff=1:nFigs
        nF=nF+1;
        if iType<3 
            figend='';

            if iSD
                dd=~mod(ff,2);
                jj=ceil(ff/2);
            else
                dd=0;
                jj=ff;
            end
            if dd
                figend='_SD';
            end
            imin=0;
            imax=-9999;
            tstr=Data(1).headers{iChoice(jj)}; 
            figname=[tstr, figend];
            ustr=Data(1).units{iChoice(jj)};
            %create a new figure
            if iFD(1)
                jDOF=iDOF(jj);
                if nSim>1
                    Fig{nF}=figure('name', sprintf('%s Free-Decay',motionNames{jDOF}));
                else
                    Fig{nF}=figure('name', sprintf('%s Free-Decay, No. %d',motionNames{jDOF},iIter(1)));
                end
                ystr=[motionNames{jDOF} ' motion [' ustr ']'];

            else
                Fig{nF}=figure('name', figname);
                ystr=[tstr,' ', '[' ustr ']'];
            end
            hold on
        elseif iType==3
            jDOF=iDOF(jj);
            Fig{nF}=figure('name', sprintf('Force Excursion Curve %d',jDOF));
            if jDOF<4
                if jDOF<3
                    ustr='kN';
                    toff=-5;
                    yrm=.65;
                else
                    yrm=.7;
                    toff=-2;
                    ustr='MN';
                end
                uxstr='[m]'; % HARD-CODED!!!
                fstr=sprintf('Applied Force [%s]',ustr);
            else
                if jDOF<6
                    yrm=1;
                    toff=-10;
                else
                    yrm=.8;
                    toff=-20;
                end

                ustr='MN-m';
                uxstr='[deg]'; % HARD-CODED!!!
                fstr=sprintf('Applied Moment [%s]',ustr); 
            end  
            if nSim>2
                hold on
            end
        elseif iType==4
            nF=1; % only 1 figure for mooring table
            %create a new figure
            Fig{nF}=figure('name', 'Mooring Design Criteria Table');
            bins1=0:nSim; %x-edges of the grid
            bins2=0:nTable:nTable^2; %y-edges of the grid
            dx=1; dy=mean(diff(bins2(2:end-1))); Dy=dy;
            set(Fig{nF},'position',2.5*[.5 .5 6 3],'units','inches','paperposition', 2.5*[.01 .01 6 3],'papersize',2*[6 3]); %,'units','inches'
            set(Fig{nF},'position',2.5*[.5 .5 6 3],'units','inches'); % have to repeat bc stupid windows does not get it right
            h1=gca;
            set(h1,'position',6.5*[.25 .2 2 .8],'units', 'inches');
            set(h1,'position',6.5*[.25 .2 2 .8],'units', 'inches'); % have to repeat bc stupid windows does not get it right
            xmin=bins1(2)-dx; xmax=bins1(end-1)+dx; ymin=bins2(2)-dy; ymax=bins2(end-1)+dy;
            yticky= mean([bins2(1:end-1)' bins2(2:end)'],2);
            xtickx= mean([bins1(1:end-1)' bins1(2:end)'],2);
            
            d1s=bins1; d1s(1)=bins1(2)-dx; d1s(end)=bins1(end-1)+dx; 
            d2s=bins2; d2s(1)=bins2(2)-dy; d2s(end)=bins2(end-1)+dy;

        end
        ns=0;
        for ss=1:dSim:nSim
            % Antoine - change underscores to dashes for label or legend
            % legibility
            ns=ns+1;
            runstr{ns}=strrep(FileData(ss).name,'_','-');
            if iType==1
                mytime=Data(ss).time;
                mydata=Data(ss).data(:,jj);
                if dd
                    timeseries=mydata(~isnan(mydata));
                    if iSD(ss)
                        navg=1;
                    else
                        navg=floor(length(timeseries)/100); %smooth over 1% of points
                    end   
                    [freq, energy] = SpecDen(mytime(~isnan(mydata)),mydata(~isnan(mydata)),navg);
                    plot(freq,abs(energy),'color',colorstr{ss} )
                    % grab the top 3 peaks
                    nfreq=3;
                    [eamp,ifreq]=lmax(abs(energy),1);
                    freqe= freq(ifreq);
                    [eamp,iea]=sort(eamp,'descend');
                    freqe=freqe(iea);
                     plot(freqe(1:nfreq),eamp(1:nfreq),'rv','markersize',4,'markerfacecolor','r')
                     for ii=1:nfreq
                        text( freqe(ii)+.05,eamp(ii),sprintf('f = %1.3f Hz, T = %1.2f s',freqe(ii),1/freqe(ii)))
                     end
                    xlabel('Frequency (Hz)');
                    ylabel('Energy');
                    xlim([0 2]); % do we want any higher freq stuff?
                else
                    if iFD(ss)
                        mytime=mytime-mytime(1);
                        if jDOF<7
                            nfilt=100;
                        else
                            nfilt=1;
                        end
                        % get the log decrement data
                        [SpecData(ss).amp,SpecData(ss).dec,SpecData(ss).dampratio,...
                            SpecData(ss).T,SpecData(ss).Xm,SpecData(ss).iM,...
                            SpecData(ss).Xn,SpecData(ss).iN]=...
                            getFDecayStats(mytime,mydata,nfilt);
                        plot(mytime(SpecData(ss).iM),SpecData(ss).Xm,[colorstrL{ss+1} 'v'],mytime(SpecData(ss).iN),SpecData(ss).Xn,[colorstrL{ss+1} '^'],'markersize',4,'markerfacecolor',colorstrL{ss+1})

                    end
                    % PLOT YOUR TIMESERIES!!!!
                    hF=plot(mytime, mydata,'color',colorstr{ss} );
                    xlabel('Time (sec)');
                    ylabel(ystr) 

                      
                end
            elseif iType==2
                   mymin=Data(ss).Min(jj);
                   mymax=Data(ss).Max(jj);
                   mymean=Data(ss).Mean(jj);
                   mystd=Data(ss).Std(jj);
                %% USE PLOTLIKESAM    
                   imin=min([imin mymin]); %track the min
                   imax =max([imax mymax]); %track the min
                   line([ss-.3*lf ss+.3*lf],[mymin mymin],'linewidth',3,'color',scol)
                   line([ss-.25*lf ss+.25*lf],[mymean mymean],'linewidth',6,'color',scol)
                   line([ss-.3*lf ss+.3*lf],[mymax mymax],'linewidth',3,'color',scol)
                   line([ss ss],[mymean mymean+mystd],'linewidth',4,'color',scol)
                   line([ss ss],[mymean mymean-mystd],'linewidth',4,'color',scol)
                   line([ss ss],[mymean mymax],'linewidth',2,'color',scol)
                   line([ss ss],[mymean mymin],'linewidth',2,'color',scol)
                   % Antoine -added labels with Std values
                   text(ss-.2*lf,mymax*1.01,['$\sigma$=' num2str(round(mystd*100)/100)],'VerticalAlignment','top','interpreter','latex')
                   %% end Antoine
            elseif iType==3
                    % FORCE EXCURSION!!
                    % how to tell the difference between Force-Excursions? -> Put them
                    % in different run folders
                    xs=[];
                    ys=[];
                    for is=0:1
                        % Remember Data(ss).data(:,[1,2,3]) -> [DecayTime, MotionX  ,
                        % DecayForce]
                        nT=length(Data(ss+is).time);
                        nTs=length(Data(ss+is).data(~isnan(Data(ss+is).data(:,3)),3));
                        istepi=find(abs(diff(Data(ss+is).data(~isnan(Data(ss+is).data(:,3)),3)))==0);
                        istepf=[find(abs(diff(Data(ss+is).data(~isnan(Data(ss+is).data(:,3)),3)))>0); nTs];
                        nStep=length(istepi);
                        tstepi=Data(ss+is).data(istepi,1);
                        tstepf=Data(ss+is).data(istepf,1);
                        iTstep=repmat(Data(ss+is).time',[length(tstepi) 1]) >=repmat(tstepi,[1 nT]) & repmat(Data(ss+is).time',[length(tstepi) 1])<=repmat(tstepf,[1 nT]);
                        xstepm=nan(nStep,1);
                        for pp=1:nStep  
                            xstepm(pp)=mean(Data(ss+is).data(iTstep(pp,:),2),1);
                        end
                        xstepi=interp1(Data(ss+is).time,Data(ss+is).data(:,2),Data(ss+is).data(istepi,1),'linear','extrap');
                        xstepf=interp1(Data(ss+is).time,Data(ss+is).data(:,2),Data(ss+is).data(istepf,1),'linear','extrap');
                        xs=[xs; xstepm];
                        ys=[ys;Data(ss+is).data(istepf,3)];
                    end
                        [ys,iSortY]=sort(ys,'ascend');
                        xs=xs(iSortY);
                    if jDOF<3
                        SInorm=1e3;
                    else
                        SInorm=1e6;
                    end
                    if nSim==2
                        P=polyfit(xs,ys,1);
                        P3=polyfit(xs,ys,3);
                        xi=linspace(min(xs),max(xs),100);
                        yi=P(1).*xi+P(2);
                        y3i=P3(1).*xi.^3+P3(2)*xi.^2 + P3(3)*xi + P3(4);
                        if jDOF==1 || jDOF==2 || jDOF==6        
                            plot(xs,ys/SInorm,'ko',xi,yi/SInorm,'b-',xi,y3i/SInorm,'r-')
                        else
                            plot(xs,ys/SInorm,'ko',xi,yi/SInorm,'b-')
                        end
                    else
                        if jDOF==1 || jDOF==2 || jDOF==6        
                            plot(xs,ys/SInorm,[colorstrL{ss} '-o'])
                        else
                            plot(xs,ys/SInorm,[colorstrL{ss} '-o'])
                        end
                    end
            elseif iType ==4
                % Plot mooring Table
                % 6 rows for each of the criteria, as many columns as sims
                % chosen:
                % max(SURGE/SWAY)-init(SURGE/SWAY), std(YAW), max(AnchorEffT), % max(TopEffT(t=0)), max(UpliftAngle), % max(AnchorAngle)-min(AnchorAngle)
                nColors=100;
                gyomap=getcmap(nColors,{'dgreen','green','yellow','orange'});
                mydata=Data(ss).data;
                mytime=Data(ss).time;
                iCol=1;
                for pp=1:nTable
                    iTruncMT=mytime>=tinT & mytime<=tout; %truncated time series based on cut-in / cut-out
                     pData=mydata(:,iCol:iCol+iNTable(pp)-1);
                     pDataT=mydata(iTruncMT,iCol:iCol+iNTable(pp)-1);

                     [nTp,nML]=size(pData);
                     % do some data cleaning
                     if pp==5
                         for qq=1:nML
                             if max(pData(:,qq))>85 && max(pData(:,qq))<95 
                                 pData(:,qq)=90*ones(size(pData,1),1)-pData(:,qq);
                             end
                         end
                     end
                     iCol=iCol+iNTable(pp);
                     initData=pData(1,:); 
                     %endData= pData(:,end); % take the last node
                     maxData=max(pData,[],1); % take max over entire time, including all lines 
                     maxDataT=max(pDataT,[],1); % take max over truncated time, including all lines 
                     minData=min(pData,[],1); % take min over entire time 
                     minDataT=min(pDataT,[],1); % take min over truncated time 
                     meanData=mean(pData,1);  %only use truncated time series for mean (unused right now)
                     
                     [maxDataML,iML]=sort(maxDataT,'descend'); % sort in descending order use the entire time series
                     if nML>1
                        maxAn=find(ismember(iML,iAn)); % only choose anchored lines
                        maxFL=find(ismember(iML,iFL)); % only choose Bridle lines from Fairlead 
                        maxBr=find(ismember(iML,iBr)); % only choose Bridle lines from Fairlead 
                     %[MLminData,jML]= min(minData);
                       [delData,dML]=max(maxDataT(iAn)-minDataT(iAn)); % only use anchored lines for truncated time, since you can get some weird motion initially
                     end
                     %dML=dML+nBr;
                     % Platform Data
                     [offData,oML]=max(maxData-initData); %assume that the platform is at (0,0) equilibrium , entire time series
                     stdData=std(pDataT,[],1); %only use truncated time series for yaw stdev
                     if pp==1 % max SURGE/SWAY
                         pass(pp)=offData/MLcrit(pp);
                         passML(pp)=NaN;                        
                     elseif pp==2 % std YAW
                         pass(pp)=stdData/MLcrit(pp);
                         passML(pp)=NaN;
                     elseif ~isBr && pp==3 % max Anchor T
                         pass(pp)=maxDataML(1)/MLcrit(pp); % choose the worst ML
                         passML(pp)=iML(1);
                     elseif isBr && pp==3
                        % only choose Bridle lines from Fairlead
                         pass(pp)=maxDataML(maxBr(1))/MLcrit(pp);
                         passML(pp)=iML(maxBr(1));
                     elseif isBr && pp==4     
                         pass(pp)=maxDataML(maxAn(1))/MLcrit(pp);
                         passML(pp)=iML(maxAn(1));                        
                     elseif pp==isBr+4
                         [MLinitData,initML]=max(initData(maxFL)); % only choose lines coming from the fairlead
                         pass(pp)=MLinitData/MLcrit(pp);
                         passML(pp)=initML; 
                     elseif pp==isBr+5 || pp==isBr+6 % only need anchored lines
                         pass(pp)=delData/MLcrit(pp);
                         passML(pp)=iAn(dML);                           
                     end
                     if isnan(pass(pp))
                     else
                         if pass(pp)>1
                             pColor = [175, 0 , 0]/255; % dark red!
                         else
                             pColor=interp1(transpose(linspace(0,1,nColors)),gyomap,pass(pp),'linear');
                         end
                         r1=rectangle('Position',[d1s(ss),d2s(pp),dx,dy],'facecolor',pColor);
                         MLstr='';
                         if ~isnan(passML(pp))
                            ml1str='$ML_{';
                            ml2str='}$';
                            MLstr=sprintf('%s%d%s',ml1str,passML(pp),ml2str);
                         end
                     
                         % ML number
                         text(xtickx(ss)-.2*dx,yticky(pp)+.08*dy, MLstr,'interpreter','latex')
                         % Value
                         if pp==1 
                              Vstr='%1.1f';
                              Vval=round(10*pass(pp)*MLcrit(pp))/10;
                              Ustr=' m';
                         elseif pp==2 || pp==isBr+5 || pp==isBr+6
                             Vstr='%1.1f';
                             Vval=round(10*pass(pp)*MLcrit(pp))/10;
                             Ustr='$^\circ$';
                         else
                             Vstr='%1.1E';
                             Vval=round(100*pass(pp)*MLcrit(pp))/100;
                             Ustr=' N';
                         end                         
                         text(xtickx(ss)-.2*dx,yticky(pp)-.08*dy, sprintf([Vstr '%s'],Vval,Ustr),'interpreter','latex')
                     end
                end
            end
        end

        if iType==1
            %we're on the final plot, do the finishing touches
            if nSim==1
                title(tstr);
            end
            if dd
                title([tstr, ' Spectral Density']);
            else
                %no title
            end
            hleg=legend(runstr);
            grid minor
            if iFD(1)
                legchild=get(hleg,'children');
                for qq=1:nSim
                    set(legchild(3*nSim-2-3*(qq-1)),'marker','none')
                    set(legchild(3*nSim-1-3*(qq-1)),'linestyle','-','color',colorstr{qq})
                end
            end
        elseif iType==3
            hleg=legend(runstr);
            grid minor
        elseif iType==2 || iType==4
            %we're on the final plot
            if iType==2
                nmax = floor(log(abs(imax))./log(10)); %order of magnitude of max val
                xmin=0; xmax=ss+.5; 
                ymin=floor( (imin-abs(imin)*.1)/10^nmax)*10^nmax ;
                ymax=ceil( (imax+abs(imax)*.1)/10^nmax)*10^nmax;
                yint=round(ymax/10^nmax);
                Dy=(ymax-ymin)/yint; %how to ensure I go through 0??!
                divs=[2 5 10];
                dyint= divs- (10-yint);
                dyint(dyint<0)=nan;
                [foo,idiv]=min(dyint);
                dy=Dy/divs(idiv);
                xtickx=ss2use(~isnan(ss2use));
            elseif iType==4
                ystr=''; %
                cstr='\makebox[.2in][c]';
                maxstr='$\max$';
                mustr= '$\mu$';
                t0str='$t_0$';
                stdstr='$\sigma$';
                minstr='$\min$';
                degstr='$^\circ$';
                leqstr='$\leq$';
                if isBr
                    ystrs={'X/Y', 'Yaw','$T_{Bridle}$','$T_{Anchor}$','$T_{Pretension}$','$\phi_{Anc}$','$\Theta_{Anc}$'};
                    ytickstr={ 
                    {sprintf('%s {%s(%s) - %s(%s)}' ,cstr,maxstr,ystrs{1},ystrs{1}, t0str), sprintf('%s {%s %d m}', cstr,leqstr,round(MLcrit(1)))},...
                    {sprintf('%s {%s(%s)}', cstr,stdstr,ystrs{2}), sprintf('%s {%s %d%s}',cstr,leqstr,MLcrit(2),degstr)},...
                    {sprintf('%s {%s(%s)}',cstr,maxstr,ystrs{3})  ,sprintf('%s {%s %1.1E N}',cstr,leqstr,MLcrit(3))  }, ...
                    {sprintf('%s {%s(%s)}',cstr,maxstr,ystrs{4})  ,sprintf('%s {%s %1.1E N}',cstr,leqstr,MLcrit(4))  }, ...
                    {sprintf('%s {%s}',cstr,ystrs{5}) , sprintf('%s {%s %1.1E N}',cstr,leqstr,MLcrit(5)) },...
                    {sprintf('%s{%s(%s)-%s(%s)}',cstr,maxstr,ystrs{6},minstr, ystrs{6}), sprintf('%s{%s %d%s}',cstr,  leqstr,round(MLcrit(6)),degstr)},...
                    {sprintf('%s{%s(%s)-%s(%s)}', cstr,maxstr,ystrs{7},minstr,ystrs{7}), sprintf('%s{%s %d%s}',cstr,   leqstr,round(MLcrit(7)),degstr)}
                    };
                else
                    ystrs={'X/Y', 'Yaw','$T_{Anchor}$','$T_{Pretension}$','$\phi_{Anc}$','$\Theta_{Anc}$'};
                    ytickstr={ 
                    {sprintf('%s {%s(%s) - %s(%s)}' ,cstr,maxstr,ystrs{1},ystrs{1}, t0str), sprintf('%s {%s %d m}', cstr,leqstr,round(MLcrit(1)))},...
                    {sprintf('%s {%s(%s)}', cstr,stdstr,ystrs{2}), sprintf('%s {%s %d%s}',cstr,leqstr,MLcrit(2),degstr)},...
                    {sprintf('%s {%s(%s)}',cstr,maxstr,ystrs{3})  ,sprintf('%s {%s %1.1E N}',cstr,leqstr,MLcrit(3))  }, ...
                    {sprintf('%s {%s}',cstr,ystrs{4}) , sprintf('%s {%s %1.1E N}',cstr,leqstr,MLcrit(4)) },...
                    {sprintf('%s{%s(%s)-%s(%s)}',cstr,maxstr,ystrs{5},minstr, ystrs{5}), sprintf('%s{%s %d%s}',cstr,  leqstr,round(MLcrit(5)),degstr)},...
                    {sprintf('%s{%s(%s)-%s(%s)}', cstr,maxstr,ystrs{6},minstr,ystrs{6}), sprintf('%s{%s %d%s}',cstr,   leqstr,round(MLcrit(6)),degstr)}
                    };
                end
                set(gca,'ytick',[],'yticklabel','')
                for yy=1:length(yticky)
                    xoff=nSim/15;
                    ht=text(0-xoff,yticky(yy),ytickstr{yy},'interpreter','latex');%,'horizontalalignment','left');%,'horizontalalignment','right')
                    
                end
                title('Mooring Design Criteria Pass/Fail Table')
            end
            axis([xmin xmax ymin ymax])
            newgrps=.5:nGroup:ss;
            allgrps=setdiff(.5:.5:ss,newgrps);
            gridxy(allgrps,ymin:dy:ymax,'linestyle',':','linewidth',.5)
            gridxy(newgrps,ymin:Dy:ymax,'linestyle','--','linewidth',.5)
            set(gca,'xtick', xtickx, 'XtickLabel', runstr,'fontsize',9)
            rotateXLabels(gca, 60)
            ylabel(ystr)  
            
            
        end
        hold off
    end
    if nSim==1 && iFD(1)
        if ~exist('iIter','var')
            iIter=1;
        end
        %make Free Decay curve + log decrement plot -> only functionality for 1 datfile       
        ndec=length(SpecData(1).dec);
        xistr='$\xi$';
        for dd=1:ndec/2-1
            text(mytime(SpecData(1).iM(dd))*1.02,SpecData(1).Xm(dd), sprintf('T=%2.1f',SpecData(1).T(dd)),'interpreter','latex')
            if iDOF<7
                text(mytime(SpecData(1).iN(dd))*1.02,SpecData(1).Xn(dd), sprintf('%s=%1.2f',xistr,100*SpecData(1).dampratio(dd)),'interpreter','latex')
            end
        end
        dT=max(mytime)-min(mytime);
        dX=max(mydata)-min(mydata);
        rectangle('position',[mean(mytime)-.05*dT,max(SpecData(1).Xm)-.02*dX,.2*dT,.05*dX],'facecolor','w','edgecolor','k')
        text(mean(mytime),max(SpecData(1).Xm),sprintf('$T_{%d}$=%2.2f s',iDOF(1),mean(SpecData(1).T)),'interpreter','latex')
        grid on
        hold off
        if iDOF<7
        % Decrement figure
        %MpI=4.82078119422768E6+22.41817475E6;
        wn=2*pi/mean(SpecData(1).T);
        Fig{nF+1}=figure('name', sprintf('%s Decrement, No. %d',motionNames{iDOF},iIter));
        P=polyfit(abs(SpecData(1).amp),SpecData(1).dampratio,1);
        ampX=0:.01:max(abs(SpecData(1).amp));
        Y=P(1)*ampX+P(2);
        %linear damping
        %B1=P(2)*2*MpI*wn
        %quadratic damping
        %B2=P(1)*3*pi*MpI/4
        
        plot(abs(SpecData(1).amp),100*SpecData(1).dampratio,'kx',ampX,Y*100,'b-')
        hold on
        xlabel([motionNames{iDOF}  ' amplitude' '[' ustr ']']);
        ylabel('damping (% of critical)');
        grid on
        minY=min([floor(min(100*SpecData(1).dampratio)) floor(P(2))]);
        maxY=ceil(max(100*SpecData(1).dampratio));
        dY=maxY-minY;

        decaxis=[-.01 ceil(max(abs(SpecData(1).amp))) minY-.01*dY maxY];
        dX=decaxis(2);
        axis(decaxis)
        plot(0,P(2)*100,'rx','markersize',8)
        rectangle('position',[0.05,P(2)*100-dY*.03,dX*.5,dY*.06],'facecolor','w','edgecolor','k')
        text(0.1,P(2)*100,sprintf('Zero-Amplitude Damping = %2.1f',P(2)*100));
        hold off
        end
    elseif iType==3 && nSim==2
        %make Force Excursion curve -> only functionality for 1 datfile
        uDOF=unique(iDOF);
        for uu=uDOF
            %create a new figure
            
            is=find(iDOF==uu);

            xa=get(gca,'xlim');
            rectangle('position',[toff+.001*min(xs) (max(ys)/2-max(ys)*.1)/SInorm max(abs(xa))*yrm max(ys)*.2/SInorm],'edgecolor','k','facecolor','w')
            mystr=sprintf('$F_{lin} = %1.2f',P(1)/SInorm);
            mystr2=sprintf(' %s %+1.1f$ %s',xstr{uu},P(2)/SInorm,ustr);
            text(toff,max(ys)/2/SInorm,[mystr '\cdot' mystr2],'interpreter','latex')
            xlabel(sprintf('Displacement in %s %s',xstr{uu},uxstr))
            ylabel(fstr)
            grid on
            if uu==1 || uu==2 || uu==6
                legend('Displacement','Fit (linear)','Fit (cubic)','location','southeast')
            else
                legend('Displacement','Fit (linear)','location','southeast')
            end
        end
    end
    %end
    
else
    error('User Cancelled')
end 
end

function [data,headers,units]=readFASTtext(FASTfile)
    % from PFFR (by Alan Lum)
    [foo,bar,ext]=fileparts(FASTfile);
    if strcmp(ext,'.elm')
        HeaderRows=1;
    else
        HeaderRows=6;
    end
    fid = fopen(FASTfile);
    for i = 1:HeaderRows
        fgets(fid);
    end
    headers = textscan(fgets(fid), '%s');
    headers = headers{1}';
    ncol = length(headers);
    units = textscan(fgets(fid), '%s');
    units = units{1}';
    data = fscanf(fid, '%f', [ncol inf])';
    fclose(fid);
end
function [data,headers,units]=readRes(Res,Units,iLikeLines)
    nOrigT = length(Res.time);
    nT = nOrigT;
    if nT<=20000
        data=nan(nT,2000);
        ns=1;
    else
        ns=10;
        warning('long time series found. downsampling by factor of 10 to ensure matrix data can be created. Your SD plots will be truncated due to reducing Nyquist freq')
        nT = length([1:ns:nT]); % length of downsampled time series
        data=nan(ceil(length(Res.time)/ns),200);
    end
    %if line_table exist, add it to Res
    if isfield(Res,'line_table')
        nlines=size(Res.line_table,1);
        for ll=1:nlines
            linename=Res.line_table{ll,1};
            linedata=Res.line_table{ll,2};
            lineunit=Res.line_table{ll,3};
            Res.(linename) = linedata;
            Units.(linename) = lineunit;
        end
    end
    % add the mooring data to Res by stripping fieldname
    try
    MLnames={'TopT','AnchorT','PreT','EffT','ArcL','LineType','TopAngle','UpliftAngle','AnchorAngle'};
    nMLn=length(MLnames);
    resheaders=fieldnames(Res);
    iallnodes= find(~cellfun('isempty',strfind(resheaders,'EffT'))); % < Bridle tension
    EffTstr=resheaders(iallnodes);
    out =  regexp(EffTstr,'\d*','match');
    MLnodenums=cellfun(@str2num,cat(1,out{:}));
    MLnums = unique(MLnodenums(:,1),'rows');
    Res.nML=length(MLnums);
    for jj=1:Res.nML
        mls=sprintf('ml%d',jj);
        for pp=1:nMLn
            if isfield(Res,'ml1')
                %you've just run extractSIM since you ran an OrcaFlex model
                Res.([mls MLnames{pp}])= Res.(mls).(MLnames{pp});
                Units.([mls MLnames{pp}])=Units.(mls).(MLnames{pp}); % would this work for cell arrays of strings?
            end
            mldata=Res.([mls MLnames{pp}]);
            if strcmp(MLnames{pp},'LineType')  || strcmp(MLnames{pp},'EffT') || strcmp(MLnames{pp},'ArcL')
                if ~isempty(strcmp(MLnames{pp},'LineType') )
                    Res.([mls 'Top' MLnames{pp} ]) = mldata(:,1);
                    Res.([mls 'Anchor' MLnames{pp} ]) = mldata(:,end);                          
                else
                    Res.([mls 'Top' MLnames{pp}]) = mldata{1};
                    Res.([mls 'Anchor' MLnames{pp}]) = mldata{end};
                end
                Res=rmfield(Res,[mls MLnames{pp}]); %save data!
                Units.([mls 'Top' MLnames{pp}]) = Units.(mls).(MLnames{pp});
                Units.([mls 'Anchor' MLnames{pp} ]) = Units.(mls).(MLnames{pp});   
            end
            %only keep the first and last ml#EffT to save space (other
            %nodes are for calculating fatigue)
        end
    end 
    catch
        disp('Cannot find mooring data')
    end
    resignore={'wavecomp','Units','LineType','line_table','ArcL','LineType'}; %,
    reskeep = {'DecayForce','DecayForceTime','CutOutTime','CutInTime'}; % Sensors that are not hte same length as the timeseries that we want to keep
    ndata=0;
    resheaders=fieldnames(Res);

    for kk=1:length(resheaders)
        try
            eval(['datak=Res.' resheaders{kk} ';'])
            if size(datak,1)==nOrigT
                datak=datak(1:ns:end,:);
            end
        catch
            warning(['Could not use ' resheaders{kk}])
        end
        [nTk,nD]=size(datak);
        jstr='';
        %kunit=ResUnits{kk};
        khead=resheaders{kk};
        khead(strfind(khead,'.'))=[] ;%so that ml1.EffT -> ml1EffT
        if iLikeLines
            iIgnore1=0;
        else
            iIgnore1=strncmp('line',khead,4);  % don't want to plot lines
        end
        iIgnore2= any(~cellfun('isempty',strfind(resignore,khead)));
        %% UNITS 
        if iIgnore1 || iIgnore2
            %ignore the 
        else
            % find the units for the current run variable
            % if there are no units defined for the current variable, set
            % as dashes
            if isfield(Units,khead)
                kunit=Units.(khead);
                if isfield(Units.(khead),'Force')
                    kunit=Units.(khead).Force;
                end
            else
                kunit=repmat({'-'},[1 nD]);
            end
            % if there is a mismatch between the length of variable and the
            % length of unit
            if length(kunit)<nD
                for jj=1:nD
                    if jj>3
                        %for rotations
                        if ~isempty(strfind(kunit(1),'m'))
                            kunit(jj)=strrep(kunit(1),'m','deg');
                        elseif ~isempty(strfind(kunit(1),'N'))
                            % for moments
                            kunit(jj)=strrep(kunit(1),'N','N-m');                
                        % wtf to do about added mass
                        end
                    else
                        kunit(jj)=kunit(1);
                    end
                end
            end
            ikeep= any(~cellfun('isempty',strfind(reskeep,khead)));                
            for jj=1:nD                   
                if nD>1
                    jstr=sprintf('%d',jj);
                end                
                if ~iscell(datak(1:nTk,jj)) && (nTk == nT || ikeep )
                    ndata=ndata+1;
                    data(1:nTk,ndata)=datak(1:nTk,jj);   
                    headers{ndata} = [khead,jstr];
                    units{ndata}=kunit{jj};

                    % units for XY and RXY
                    if jj==3 && (nD==3 || nD==6)
                        ndata=ndata+1;
                        data(:,ndata)=sqrt(datak(:,1).^2 + datak(:,2).^2);     
                        headers{ndata} = [khead,'XY'];
                        units{ndata}=kunit{3};
                    elseif jj==6 && (nD==3 || nD==6)
                        ndata=ndata+1;
                        data(:,ndata)=sqrt(datak(:,4).^2 + datak(:,5).^2);     
                        headers{ndata} = [khead,'RXY']; 
                        units{ndata}=kunit{6};
                    end
                end
            end 
        end
    end
    data=data(:,1:ndata);
end

function NewData=findFExcrns(Data)
NewData=Data;
runstrs={Data(:).PDir};
nRuns=length(runstrs);
% dirstrs = {Data(:).PPDir};
% [uDirs,iDirs]=unique(dirstrs);
% nDirs=length(uDirs);
% for ff=1:nDirs

%keepRuns={}; %bad memory allocation

%keepi=0;
%RunRange=[]; % %bad memory allocation
    for kk=1:nRuns %runstrs is the length of original Data
        rundir= Data(kk).HomeDir;
        runstr=runstrs{kk};
        fdir=Data(kk).PPDir;
        files = dir(rundir);
        dirFlags = [files.isdir];
        subFolders = files(dirFlags);
        allrunstrs=cellfun(@(x) x(1:end-1),{subFolders(:).name},'UniformOutput',false);
        runi=find(~cellfun('isempty',strfind(allrunstrs,runstr(1:end-1))));
        ni=length(runi);
        iFExcrn=regexpi(runstr,'FExcrn');
        if ni>1 && ~isempty(iFExcrn)
            %then we need to add to the data
            %first find the exact matching folder
            runk=find(~cellfun('isempty',strfind({subFolders(:).name},runstr)));
            inrun=runi( ~ismember(runi,runk) );
            nnew=length(inrun);
            %split Data
            %PreData=Data(1:runk);
            %make space for new data
            %update runs to reflect new Data
            icut=find(~cellfun('isempty',strfind({NewData(:).FullPath},[fdir filesep runstr])));
            if icut+nnew<=length(NewData)
                NewData(icut+nnew+1:end+nnew)=NewData(icut+1:end); %3:end+1 -> 2:end
            end
            for ii=1:nnew
                NewData(icut+ii)=NewData(icut);
                dirstr=subFolders(inrun(ii)).name;
                pathstr=[rundir filesep dirstr filesep 'outputs.mat'];
                NewData(icut+ii).pathname=pathstr;
                NewData(icut+ii).PDir=dirstr;
                NewData(icut+ii).FullPath=[rundir filesep dirstr];
                %keepi=keepi+1;
                %seedNum=subFolders(ii).name(seedi+mainL:end);
                %keepRuns{keepi}=[rundir filesep subFolders(ii).name];
                %RunRange(keepi)=str2num( [mainDLC seedNum] );
               % end
            end
        end

        %checkstrs{kk}=[rundir filesep runstr];
    end
% end
%newstrs=union(keepRuns,checkstrs);

end

function ix = findmax(indx, s)
[m,ix] = max(s(indx));
ix = indx(ix);
end