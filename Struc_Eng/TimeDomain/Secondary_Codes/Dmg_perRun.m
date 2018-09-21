function[Sum_D_year] = Dmg_perRun(tstep, M, StrNm, Thk, SNcurve, StrChoice)
% Calculation of fatigue damage based on time history of maximum principal
% stress (S1) or minimum principal stress (S3)
% SNcurve is a structure that can define a curve for a specific material.
% It consists of subfields:
% A = linear coeff in SN curve equation
% m = exponent in SN curve equation
% N0 = above this cycle limit a new equation is used (optional)
% C = linear coeff in modified SN curve equation
% r = exponent in modified SN curve equation

% SNcurve.t_ref = if you want to use a thickness correction:
%     SL_corr=SL*(Thk/t_ref)^kcorr (Thk and t_ref should be in the same
%     units)
% SNcurve.kcorr = some coeff in the thickness correction

% The number of cycles to failure is given by:
%       NSL = SNcurve.A./(SL_corr).^SNcurve.m; 

%---------------------------Calculate Fatigue Damage-----------------------
oneyear=24*365.25; %hours
dt = max(size(M))*tstep/3600; % length of run - convert in hours
Str = stress_tmhist(M,StrNm,StrChoice.theta);
Ntheta = length(StrChoice.theta);

if ~strcmp(StrChoice.name,'Srot')
    
    for j = 1:size(StrNm,1) %Iterate for each hot spot
          DSL = runRainflowExe(Str(j).(StrChoice.name), SNcurve,Thk(j)) ;
          Sum_D_year(j,1)=DSL*oneyear/dt;
    end    
        
else
    for j = 1:size(StrNm,1) %Iterate for each hot spot
        for k = 1:Ntheta %Iterate for each stress direction           
            fdname = ['theta' num2str(StrChoice.theta(k))];
            StrRot = Str(j).Srot.(fdname);
   
            DSL = runRainflowExe(StrRot, SNcurve,Thk(j)) ;
            Sum_D_year(j,k)=DSL*oneyear/dt;
        end

    end            
        
end

end