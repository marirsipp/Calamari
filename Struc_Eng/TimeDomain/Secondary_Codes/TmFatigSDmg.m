function[Sum_D_year] = TmFatigSDmg(tstep, imat, filedat, proba, nrun, StrNm, Thk, SN, StrChoice)
% Calculation of fatigue damage based on time history of maximum principal
% stress (S1)

%--------------------------------Input-------------------------------------
% Input data of S-N curves
% ABS-E curve - [1] Section 2
t_ref_1=22; %mm
kcorr_1=0.25;
A_1=1.04e12; %For S in MPa
C_1=2.30e15; %For S in MPa
% A_1=1.52e12; %For S in MPa ***ABS-D curve***
% C_1=4.33e15; %For S in MPa ***ABS-D curve***
m_1=3;
r_1=5;
N0_1=10^7;
S0_1=47; %MPa
% S0_1=53.4; %MPa  ***ABS-D curve***

% API 
t_ref_2=16; %mm
kcorr_2=0.25;
log10k1_a=12.48; %MPa
log10k1_b=16.13; %MPa
m_a=3;
m_b=5;
N0_2=10^7;

%3 - ABS-E Seawater with Cathodic Protection
t_ref_3 = 22; %mm
kcorr_3 = 0.25;
A_3 = 4.16e11; %For S in MPa
C_3 = 2.30e15; %For S in MPa
m_3 = 3;
r_3 = 5;
N0_3 = 1.01e6;
S0_3 = 74.4; %MPa

%4 - API-WJ Seawater with Cathodic Protection
t_ref_4 = 16; %mm
kcorr_4 = 0.25;
A_4 = 1.51e12; %For S in MPa
C_4 = 1.35e16; %For S in MPa
m_4 = 3;
r_4 = 5;
N0_4 = 1.8e6;
S0_4 = 94; %MPa

%----------------Read load bin probability and stress matrix --------------
%S-N curve calculation 
%If S-N curve selection is the same for the current connection
if SN(1) == 1              %ABS-E curve
    t_ref = t_ref_1;
    kcorr = kcorr_1;
    A = A_1; %For S in MPa
    C = C_1; %For S in MPa
    m = m_1;
    r = r_1;
    N0 = N0_1;
elseif SN(1) == 2                        %API RP-2A curve
    t_ref = t_ref_2;
    kcorr = kcorr_2;
    A = 10^log10k1_a; %For S in MPa
    C = 10^log10k1_b; %For S in MPa
    m = m_a;
    r = m_b;
    N0 = N0_2;
elseif SN(1) == 3 %ABS-E CP
    t_ref = t_ref_3;
    kcorr = kcorr_3;
    A = A_3; %For S in MPa
    C = C_3; %For S in MPa
    m = m_3;
    r = r_3;
    N0 = N0_3;
elseif SN(1) == 4 %API CP
    t_ref = t_ref_4;
    kcorr = kcorr_4;
    A = A_4; %For S in MPa
    C = C_4; %For S in MPa
    m = m_4;
    r = r_4;
    N0 = N0_4;
end

%---------------------------Calculate Fatigue Damage-----------------------
oneyear=24*365.25; %hours
Tot_D_year = zeros(size(StrNm,1),1); %Total fatigue damage per year for each hot spot

for i= 1:nrun

    % Read time series in binary format
    M=[];
    if i<10
        strnum=['00',num2str(i)];
    elseif i<100
        strnum=['0',num2str(i)];
    else
        strnum=num2str(i);
    end
    if imat == 0
        a1=strcat([path1,strnum,'.dat']);
        fid=fopen(a1);
        M = fread(fid,'double');
        fclose(fid);
        M = reshape(M,6,length(M)/6);
    else
        % Read mat file
        expr = ['run',strnum];
        expr1 = ['^', expr];
        Maddress = load(filedat,'-regexp',expr1); 
        M=(Maddress.(expr))';
    end
    
    Fx = [];
    Fy = [];
    Fz = [];
    Mx = [];
    My = [];
    Mz = [];
    
    dt = max(size(M))*tstep/3600; % length of run - convert in hours
    Fx=M(1,:)/1000; %kN
    Fy=M(2,:)/1000; %kN
    Fz=M(3,:)/1000; %kN
    
    Mx=M(4,:)/1000; %kN.m
    My=M(5,:)/1000; %kN.m
    Mz=M(6,:)/1000; %kN.m
   
    clear M;
    clear index;
        
    for j = 1:size(StrNm,1) %Iterate for each hot spot
        
        %Normal stress time history for each hot spot, Tot_Str_Nm=[SY; SZ; SYZ]
        Tot_Str_Nm = (StrNm(j,1:3)'*Fx/100 + StrNm(j,4:6)'*Fy/100 + StrNm(j,7:9)'*Fz/100 + StrNm(j,10:12)'*Mx/1000 + StrNm(j,13:15)'*My/1000 + StrNm(j,16:18)'*Mz/1000 );
        
        %Tot_Str_Nm = StrNm(j,1:3)'*Fx/100;
        %Tot_Str_Nm = StrNm(j,4:6)'*Fy/100;
        %Tot_Str_Nm = StrNm(j,10:12)'*Mx/1000;
        %Tot_Str_Nm = StrNm(j,13:15)'*My/1000; 
        %Tot_Str_Nm = StrNm(j,1:3)'*Fx/100 + StrNm(j,13:15)'*My/1000; 
        %Tot_Str_Nm = StrNm(j,4:6)'*Fy/100 + StrNm(j,10:12)'*Mx/1000;
        %Tot_Str_Nm = StrNm(j,10:12)'*Mx/1000 + StrNm(j,13:15)'*My/1000;
        %Tot_Str_Nm = StrNm(j,1:3)'*Fx/100 + StrNm(j,4:6)'*Fy/100+ StrNm(j,10:12)'*Mx/1000 + StrNm(j,13:15)'*My/1000;
        
        Tot_SY = Tot_Str_Nm(1,:);
        Tot_SZ = Tot_Str_Nm(2,:);
        Tot_SYZ = Tot_Str_Nm(3,:);
        clear Tot_Str_Nm;
        clear index;
        
        Tot_S1 = ((Tot_SY+Tot_SZ)/2 + ( ((Tot_SY-Tot_SZ)/2).^2 + Tot_SYZ.^2 ).^0.5);
        Tot_S2 = ((Tot_SY+Tot_SZ)/2 - ( ((Tot_SY-Tot_SZ)/2).^2 + Tot_SYZ.^2 ).^0.5);
        
        Tot_Smax = Tot_S1;
        index_S2lgr = find (abs(Tot_S2)>abs(Tot_S1));
        Tot_Smax(index_S2lgr) = Tot_S2(index_S2lgr);
        
        if StrChoice == 1
            fidrf=fopen('rainflow.inp','w');
            fprintf(fidrf,'%i\n',max(size(Tot_S1)));
            fprintf(fidrf,'%f\n',Tot_S1);
            fclose(fidrf);
        elseif StrChoice == 2
            fidrf=fopen('rainflow.inp','w');
            fprintf(fidrf,'%i\n',max(size(Tot_S2)));
            fprintf(fidrf,'%f\n',Tot_S2);
            fclose(fidrf);
        elseif StrChoice == 3
            fidrf=fopen('rainflow.inp','w');
            fprintf(fidrf,'%i\n',max(size(Tot_Smax)));
            fprintf(fidrf,'%f\n',Tot_Smax);
            fclose(fidrf);
        else
            disp('Choice of principal stress can only be 1 to 3');
        end
        
        clear Tot_S1
        clear Tot_S2
        clear Tot_Smax
        clear Tot_SY
        clear Tot_SZ
        clear Tot_SYZ
    
        !rainflow.exe
    
         % READ OUTPUT
         SL=[]; %Moment range
         NSL=[]; %Number to failure
         DSL=[]; %Fatigue damage
            
         % open output from RainFlow counting
         filename=['rainflow.out'];
         a1=[ filename ];
         fiddat=fopen(a1);
         % read number of lines with Force/Moment range
         count = 0;
         while ~feof(fiddat)
             line = fgetl(fiddat);
             if isempty(line) || ((~ strncmp(line,' HALF',5)) && (~ strncmp(line,' FULL',5)))
                 continue
             end
             count = count + 1;
          end
          %  disp(sprintf('%d lines',count));
          % move cursor to beginning of file
          status=fseek(fiddat,0,'bof');
          % read stress range
          [SL,countl]=fscanf(fiddat,'%*s %*s %*s %f ',[1 count]);
          inull=find(SL(1,:)==0);
          SL(:,inull)=[];
          fclose(fiddat);
          % disp(['Maximum Stress Range is : ',num2str(max(SL))])
            
          % thickness correction
          if Thk(j)>t_ref
              SL_corr=SL*(Thk(j)/t_ref)^kcorr;    
          else
              SL_corr=SL;
          end

          % number of cycles to failure
          NSL = A./(SL_corr).^m;
          index_above=find(NSL>N0);
          NSL(index_above)=C./(SL_corr(index_above)).^r;
          % damage
          DSL=1./NSL;
          Sum_DSL=sum(DSL);
          Sum_D_year(i,j)=Sum_DSL*oneyear/dt;
          Tot_D_year(j)=Tot_D_year(j)+proba(i)*Sum_D_year(i,j);
    end    
    disp(['..... Run ' num2str(i) ': damage/year [' num2str(Sum_D_year(i,j)) ']'])
end

%---------------------------Calculate Fatigue Life-------------------------
FatigueLife=1./Tot_D_year;
end