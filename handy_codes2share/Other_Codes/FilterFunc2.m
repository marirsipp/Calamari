function [func_filt] = FilterFunc2(omega,tcutoff,func,ipass)

            Wn=1./tcutoff/(omega/2);
            n=5;                
            if (ipass==1) % Low Pass (filter out high frequencies)
                [b,a] = butter(n,Wn);
            else % High Pass (filter out low frequencies)
                [b,a] = butter(n,Wn,'high');
            end
            func_filt= filtfilt(b,a,func);