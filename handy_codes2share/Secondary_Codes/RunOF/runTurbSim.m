function WndFileAbs = runTurbSim(RunTime,Wind,Turbine)
    WndFileAbs='';
    %%  IEC 61400-1 Design Requirements
    % Table 1
    switch Turbine.Class
        case 1
            Wind.SpeedRef=50; % [m/s]
        case 2
            Wind.SpeedRef=42.5; % [m/s]
        case 3
            Wind.SpeedRef=37.5; % [m/s]
    end
%    if strcmp(Wind.IECType,'NTM') || strcmp(Wind.IECType,'ETM') 
%        WindTypeStr= Wind.IECType;
%    else
%        WindTypeStr=sprintf('%d%s',Turbine.Class,Wind.IECType);
%    end
    WindTypeStr= 'NTM'; %When the turbulence intensity is entered as a percent, the IEC wind type must be "NTM". 
    %% TURBULENCE INTENSITY
%     FROM IEC: Turbulence intensity, I  is the ratio of the wind speed standard deviation to the mean wind speed.

    if Wind.stdTI==-1 || isnan(Wind.stdTI)   %If user does not specify TI use IEC standard formulas
        if strcmp(Wind.TIchar,'A') % 'higher turbulence intensity characteristics
            TI15 = .16;
        elseif strcmp(Wind.TIchar,'B')
            TI15= .14;
        elseif strcmp(Wind.TIchar,'C')
            TI15= .12;
        end
        bNTM=5.6;% NTM char %3.8; % see footnote
        cETM=2;
        if strcmp(Wind.IECType,'NTM')
            % NORMAL TURBULENCE MODEL
            stdTI=TI15*(0.75*Wind.Speed + bNTM); % Eq 11 %stdwind = Intensity15*(15+a_coeff*Wind.Speed)/(a_coeff+1); a_coeff = 3;
        elseif strncmp(Wind.IECType,'EWM',3)
            stdTI=0.11*Wind.Speed; % Eq 16
        elseif strcmp(Wind.IECType,'ETM')
            stdTI= cETM * TI15* (0.072*(Wind.SpeedRef/cETM + 3)*(Wind.Speed/cETM -4) + 10 );
        end
    else
        stdTI=Wind.stdTI;
    end
    %% SET THE TURBULENCE LEVEL
    TL = stdTI/Wind.Speed*100;
    %% WRITE TO .INP
    inputfile=[ Wind.TSDir Wind.INPname];
    if ~exist(inputfile, 'file')
        error(['Please create a template file called ' inputfile '. A sample is in the Repo if you are confused.'])
    end
        FP = Fast2Matlab(inputfile,3); %FP are Fast Parameters, specify 4 lines of header

        %----------------------------------------------------------------------
        % USE Turbsim to create a new wnd file:
        %---------------------------------------------------------------------  
        WindSeedNum=max(uint8(Wind.Seed)-64,1);
        if length(WindSeedNum)~=1
            error('Wind Seed should be 1 letter long (could be capitalized or not)')
        end
        FP.Val(1)={WindSeedNum};
        FP.Val(13)={Wind.Grid};
        FP.Val(14)={Wind.Grid};
        FP.Val(16)={RunTime};
        FP.Val(17)={RunTime};
        FP.Val(18)={Turbine.HubH};
        FP.Val(19)={Turbine.HubH*2-1};
        FP.Val(20)={Turbine.D+2*Turbine.ShaftL};
        if Wind.stdTI==-1 || isnan(Wind.stdTI) % if stdTI is specified, then print to more digits, otherwise round to nearest integer (backward-compatibility)
            FP.Val(25)={sprintf('%d',round(TL))};
        else
            FP.Val(25)={sprintf('%2.4f',TL)}; % could also be "A","B", or "C"
        end
        FP.Val(26)={sprintf('"%s" ',WindTypeStr)};
        FP.Val(29)={sprintf('%3.2f',Turbine.HubH)};
        FP.Val(30)={sprintf('%2.1f',Wind.Speed)};
        FP.Val(32)={sprintf('%1.3f',Wind.Shear)};
%         if isnan(Wind.stdTI)
%             newfile=['turbwind' Wind.ResName '_' sprintf('%02g',round(Wind.Speed)) Wind.SeedStr];
%         else
%             newfile = ['turbwind' Wind.ResName '_' num2str(round(Wind.Speed),'%02d') '_' num2str(round(WindTL*10),'%03d')  Wind.SeedStr];
%         end
        outputFile = [Wind.TSDir  Wind.FileName '.inp'];
        Matlab2FAST(FP,inputfile,outputFile, 3); %contains 2 header lines        
        homedir = cd(Wind.TSDir);
        [status,result] = dos( [Wind.TSExe ' ' Wind.FileName '.inp'],'-echo') ;
        cd(homedir)
    if ~status
        disp(['TurbSim successfully run. Using ' Wind.FileName ' for current run.'])
        WndFileAbs = [Wind.TSDir Wind.FileName Wind.FileExt];
    end

    

end