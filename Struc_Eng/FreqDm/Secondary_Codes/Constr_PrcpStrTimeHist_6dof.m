function[Smax] = Constr_PrcpStrTimeHist_6dof(NormStr_amp,NormStr_phase,wave_phase, time, fr)
%Constr_PrcpStrTimeHist_6dof.m 
%calculates principal stress from 6 directional stresses time histories

%Input:
%NormStr_amp - Amplitude of normal stresses calculated from stress spectrum
%            - col1 to 6: Sx, Sy, Sz, Sxy, Syz, Sxz
%            - row1 to n: frequency 1 to frquency n
%NormStr_phase - Phase of normal stresses relative to input wave
%            - col1 to 6: Sx, Sy, Sz, Sxy, Syz, Sxz
%            - row1 to n: frequency 1 to frquency n
%wave_phase  - random input wave phase
%time        - sec, time for building the time series
%fr          - Hz, frequencies that wave spectrum are discretized at 

total_time_step = length(time);
random_phase = repmat(wave_phase',1,length(time));

phase_Sx = 2.*pi.*(fr'*time) + random_phase.*pi./180 + repmat(NormStr_phase(:,1),1,length(time));
amp_Sx = repmat(NormStr_amp(:,1),1,length(time));
response_Sx = sum(amp_Sx.*sin(phase_Sx));

phase_Sy = 2.*pi.*(fr'*time) + random_phase.*pi./180 + repmat(NormStr_phase(:,2),1,length(time));
amp_Sy = repmat(NormStr_amp(:,2),1,length(time));
response_Sy = sum(amp_Sy.*sin(phase_Sy));

phase_Sz = 2.*pi.*(fr'*time) + random_phase.*pi./180 + repmat(NormStr_phase(:,3),1,length(time));
amp_Sz = repmat(NormStr_amp(:,3),1,length(time));
response_Sz = sum(amp_Sz.*sin(phase_Sz));

phase_Sxy = 2.*pi.*(fr'*time) + random_phase.*pi./180 + repmat(NormStr_phase(:,4),1,length(time));
amp_Sxy = repmat(NormStr_amp(:,4),1,length(time));
response_Sxy = sum(amp_Sxy.*sin(phase_Sxy));

phase_Syz = 2.*pi.*(fr'*time) + random_phase.*pi./180 + repmat(NormStr_phase(:,5),1,length(time));
amp_Syz = repmat(NormStr_amp(:,5),1,length(time));
response_Syz = sum(amp_Syz.*sin(phase_Syz));

phase_Sxz = 2.*pi.*(fr'*time) + random_phase.*pi./180 + repmat(NormStr_phase(:,6),1,length(time));
amp_Sxz = repmat(NormStr_amp(:,6),1,length(time));
response_Sxz = sum(amp_Sxz.*sin(phase_Sxz));

for n=1:total_time_step
    S(n,:) = CalPrcpStr_6dof ([response_Sx(n),response_Sy(n),response_Sz(n),response_Sxy(n),response_Syz(n),response_Sxz(n)]);
end

Smax=real(S(:,1));
index=find(abs(S(:,3))>abs(S(:,1)));
Smax(index)=real(S(index,3));
end