function [func_filt] = FilterFunc(Wn,func,ipass)
            %% REQUIRES SIGNAL PROCESSING TOOLBOX!! Nooo.....
            n=5;                
            if (ipass==1) % Low Pass (filter out high frequencies)
                [b,a] = butter(n,Wn);
            else % High Pass (filter out low frequencies)
                [b,a] = butter(n,Wn,'high');
            end
            func_filt= filtfilt(b,a,func);
end