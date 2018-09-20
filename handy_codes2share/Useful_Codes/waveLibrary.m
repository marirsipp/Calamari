function S = waveLibrary(w,Wave,WaveType)
% w defined in rad/sec
% S defined in m^2/(rad/sec)
isZero=0;
    if isfield(Wave,'Tp')
        if Wave.Tp==0 || Wave.Hs==0
            
            S=zeros(size(w));
            isZero=1;
        end
    end
if ~isZero
    if strcmp(WaveType,'JONSWAP')
        % need Hs, Tp, Gam
      S=JONSWAP(w,Wave.Hs,Wave.Tp,Wave.Gam);
    
    elseif ~isempty(strfind(WaveType,'Pierson')) || ~isempty(strfind(WaveType,'PM')) || strcmp(WaveType,'Bretschneider')
        % need Hs, Tp,
        if isfield(Wave,'Tp')
            S=PM(w,Wave.Hs,Wave.Tp);
        else
            S=PM(w,Wave.Hs,NaN);
            disp('Using One-Parameter Pierson-Moskowitz Wave Spectrum')
        end
    end
end
end


function S=PM(w,H,T)
% https://ocw.tudelft.nl/wp-content/uploads/OffshoreHydromechanics_Journee_Massie.pdf
% (Eq 5.123), 5-44
% w defined in rad/sec
% S defined in m^2-sec/rad
if isnan(T)
    T1=3.86*sqrt(H);
else
    T1=0.772*T;
end
Y = exp(-692./(T1^4.*w.^4));
S = 173*H^2./(T^4*w.^5).*Y;
end
function S=JONSWAP(w,H,T,gam)
% https://ocw.tudelft.nl/wp-content/uploads/OffshoreHydromechanics_Journee_Massie.pdf
% (Eq 5.126), 5-44
% w defined in rad/sec
wp=2*pi/T;
  sig=.07*(w<=wp)+.09*(w>wp);
  A=exp(- ((w/wp -1)./(sqrt(2).*sig)).^2);
  Y=exp(-1950./(T^4.*w.^4));
  S = 320*H^2./(T^4*w.^5).*Y.*gam.^A;
end