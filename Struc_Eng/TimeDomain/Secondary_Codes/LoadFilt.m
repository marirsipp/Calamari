function [Tot_M_filt] = LoadFilt (M,Tfilt,Tfilt2,k,tstep,n)
%Filter load time history
%Input: a,b low pass; a2, b2: high pass

Wn=tstep/(Tfilt(k)/2);
[b,a] = butter(n,Wn); %Low pass 
Wn2=tstep/(Tfilt2(k)/2);
[b2,a2] = butter(n,Wn2,'high');

My_filt = filtfilt(b,a,M); 
My_filt2= filtfilt(b2,a2,My_filt);
My_filth = filtfilt(b2,a2,M);

if k == 1
    Tot_M_filt = My_filth; %high pass, final signal has period smaller than Tfilt2(1)
elseif k == size(Tfilt,2)
    Tot_M_filt = My_filt; %low pass, final signal has period larger than Tfilt(k)
else
    Tot_M_filt  = My_filt2; %final signal has period between Tfilt(k) and Tfilt2(k)
end

end