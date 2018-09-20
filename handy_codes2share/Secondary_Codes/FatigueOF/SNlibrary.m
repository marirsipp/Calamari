function SNcurve=SNlibrary(linetype,dia,standard)
%corrR=.4;% [mm/yr] 
% supposed 0.4mm/yr*.5FatLife
if ~isempty(strfind(linetype,'Chain')) || ~isempty(strfind(linetype,'chain'))
    %% Get MBL from Chain Library  
     % from Vicinay
    libraryfile=which('VicinayMooringChainLibrary.txt');
    fid=fopen(libraryfile,'r');
    headers=fgetl(fid);
    A=textscan(fid,repmat('%d ',[1 16]));
    fclose(fid);
    % Convert whole array to numeric array
    A = double([A{:}]);
    diaV= A(:,1); MBL_R5=A(:,2); MBL_R4=A(:,4); MBL_R3=A(:,6); MBL_ORQ=A(:,7);
    if ~isempty(strfind(linetype,'R5')) &&  isempty(strfind(standard,'ABS'))
        MBL=MBL_R5;
    elseif ~isempty(strfind(linetype,'R4')) && isempty(strfind(standard,'ABS'))
        MBL=MBL_R4;
    elseif ~isempty(strfind(linetype,'R3')) && isempty(strfind(standard,'ABS'))
        MBL=MBL_R3;
    elseif~isempty(strfind(linetype,'ORQ')) || ~isempty(strfind(standard,'ABS'))
        MBL=MBL_ORQ;
%     elseif strcmp(standard,'DNV')
%          % F it, use R5..
%         MBL=MBL_R5;
    else
       % use ORQ?
        MBL=MBL_ORQ;
    end
    SNcurve.MBS=interp1(diaV,MBL,dia)*1e3;
    %% Get T-N from Standard

    if ~isempty(strfind(standard,'ABS'))
        % Taken from Design and Analysis of Stationkeeping Systems for Floating Structures
        % API RECOMMENDED PRACTICE 2SK THIRD EDITION, OCTOBER 2005
        % TABLE 3
        if ~isempty(strfind(linetype,'Studlink')) || ~isempty( strfind(linetype,'studlink') )
            SNcurve.A= 1e3; % this is called K in the table
            SNcurve.m= 3;
        elseif ~isempty( strfind(linetype,'Studless') ) || ~isempty(strfind(linetype,'studless') )
            %% ADD in if statements regarding R3/R4/R5
            SNcurve.A= 316; % this is called K in the table
            SNcurve.m= 3;     
        else
            %disp('In your Orca model, please specify Studless/Studlink in your chain Line Type name')
            % going to assume its Studless
            SNcurve.A= 316; % this is called K in the table
            SNcurve.m= 3; 
        end 
%-----------------------------------------DNV Chain--------------------------------------------    
    elseif ~isempty(strfind(standard,'DNV'))       
        if ~isempty(strfind(linetype,'Studlink')) ||  ~isempty(strfind(linetype,'studlink') )
            SNcurve.A= 1e3; % this is called K in the table
            SNcurve.m= 3;
        elseif ~isempty( strfind(linetype,'Studless') )||~isempty( strfind(linetype,'studless'))
            SNcurve.A= 316; % this is called K in the table
            SNcurve.m= 3;     
        else
            disp('In your Orca model, please specify Studless/Studlink in your chain Line Type name')
            % going to assume its Studless
            SNcurve.A= 316; % this is called K in the table
            SNcurve.m= 3; 
        end
    end
    elseif ~isempty(strfind(linetype,'Rope')) || ~isempty(strfind(linetype,'rope'))
        switch standard
            case 'ABS'
                Lm=0.3; %ratio of mean load to reference breaking strength of wire rope 
                % should update somehow to input this ratio...
                SNcurve=6550e3; % this is a made-up number
                if ~isempty(strfind(linetype,'Multi')) || ~isempty(strfind(linetype,'multi'))
                    % going to assume its Studless
                    SNcurve.A= 10^(3.20-2.79*Lm); % this is called K in the table
                    SNcurve.m= 4.09;
                elseif ~isempty(strfind(linetype,'Spiral')) || ~isempty(strfind(linetype,'spiral'))
                    % going to assume its Studless
                    SNcurve.A= 10^(3.25-3.43*Lm); % this is called K in the table
                    SNcurve.m= 5.05;
                end
                case 'DNV'
                    %add section on T-N curve DNV
        end
    elseif ~isempty(strfind(linetype,'Dyneema')) || ~isempty( strfind(linetype,'dyneema'))
        SNcurve.MBS=6550e3; % numbers comes from Cyril's @$$
        SNcurve.A = 5809;
        SNcurve.m = 9.62;
    else
        SNcurve.MBS=inf; % set damage due to 0
        SNcurve.A = 1;
        SNcurve.m = 1;
        warning('Cannot find keywords "Chain", "Rope" or "Dyneema" in your linetype name. Please fix or add your linetype to the library.')
end


end