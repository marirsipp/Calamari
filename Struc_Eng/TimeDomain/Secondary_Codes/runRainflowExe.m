function DSL = runRainflowExe(timeseries, SNcurve,varargin) 
%% timeseries is obviously the tension, moment, etc you would like to perform rainflow counting on
%% SNcurve is a structure that can define a curve for a specific material.
% It consists of subfields:
% A = linear coeff in SN curve equation
% m = exponent in SN curve equation
% N0 = above this cycle limit a new equation is used (optional)
% C = linear coeff in modified SN curve equation
% r = exponent in modified SN curve equation
iExe=0;
%% use thickness if necessary
if nargin>2
    Thk=varargin{1};
end
%% Main code
if iExe
    myrainflowexe=which('rainflow.exe'); % only returns the first one it finds. Use '-all' to return multiple
    if isempty(myrainflowexe)
        error('Please put rainflow.exe on your matlab path')
    else
        [mydir,foo,exe]=fileparts(myrainflowexe);
        inpfile=[mydir filesep 'rainflow.inp'];
        fidrf=fopen(inpfile,'w');
        fprintf(fidrf,'%i\n',max(size(timeseries)));
        fprintf(fidrf,'%f\n',timeseries);
        fclose(fidrf);
        %disp('Running rainflow.exe. Thank you Exxon.')
        cdir=pwd;
        cd(mydir);
        if ispc 
            system(myrainflowexe);
        else
            %if you're on a mac try installing xcode (5GB!), homebrew and then wine
            % https://www.davidbaumgold.com/tutorials/wine-mac/
            %setenv('PATH', [getenv('PATH') ':/usr/local/bin']) % matlab's path does not line up with system's path
            runstr=['!wine ' myrainflowexe];
            eval(runstr)
        end
        cd(cdir);
    end
    optfile=[mydir filesep 'rainflow.out'];
    % try to open output from RainFlow counting
    fiddat=fopen(optfile);
    if fiddat>-1
        %you have successfully run rainflow.exe
        %disp('You successfully ran rainflow.exe. Removing input file.')
        delete(inpfile)
    end

     % read number of amplitudes (either HALF or FULL)
     count = 0;
     HorF_No = [];
     while ~feof(fiddat)
         line = fgetl(fiddat);
         if isempty(line) || ((~ strncmp(line,' HALF',5)) && (~ strncmp(line,' FULL',5)))
             continue
         end
         count = count + 1;
         HorF = line(2:5);
         if strcmp(HorF,'HALF') % you could use Cyril's fancy char(70) char(72) check if you want
             HorF_No(count) = 0.5;
         elseif strcmp(HorF,'FULL')
             HorF_No(count) = 1;
         end
      end
      %  disp(sprintf('%d lines',count));
      % move cursor to beginning of file
      status=fseek(fiddat,0,'bof');
    % READ OUTPUT

      % read stress range
      [SL,countl]=fscanf(fiddat,'%*s %*s %*s %f ',[1 count]); %Moment range
      inull=find(SL(1,:)==0);
      SL(:,inull)=[];
      HorF_No(:,inull)=[];
      fclose(fiddat);
      %delete(optfile) 
else
    [ NCH,NC ] = rainflowdotexe( timeseries );
    SL= [NC;NCH];
    HorF_No=[ones(length(NC),1);0.5*ones(length(NCH),1)];
end


% disp(['Maximum Stress Range is : ',num2str(max(SL))])
SL_corr=SL;
% thickness correction
if isfield(SNcurve,'t_ref') && exist('Thk','var')
  if Thk>SNcurve.t_ref
      SL_corr=SL*(Thk/SNcurve.t_ref)^SNcurve.kcorr;    
  end
elseif isfield(SNcurve,'MBS')
  SL_corr=SL/SNcurve.MBS;
end

% number of cycles to failure
NSL = SNcurve.A./(SL_corr).^SNcurve.m;  %Number to failure 
if isfield(SNcurve,'N0')
index_above=find(NSL>SNcurve.N0);
NSL(index_above)=SNcurve.C./(SL_corr(index_above)).^SNcurve.r; 
end
% total damage in the time series you gave it
DSL=1./NSL;
DSL=sum(HorF_No.*DSL);

end