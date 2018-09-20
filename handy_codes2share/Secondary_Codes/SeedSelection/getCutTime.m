function [t_in,t_out]=getCutTime(fstfile,t_temp)
    DataOut = Fast2Matlab(fstfile);
    runtime=cell2mat(DataOut.Val( logical(strcmp([DataOut.Label],'TMax')) )); % this value gets set to General.EndTime=runtime in PreOF, not sure what happens if run dies and you still want to analyze the data...
    t_offset=runtime-max(t_temp);
    pitch_time=cell2mat(DataOut.Val( logical(strcmp([DataOut.Label],'TPitManS(1)')) ));
    pitchE_time=cell2mat(DataOut.Val( logical(strcmp([DataOut.Label],'TPitManE(1)')) ));
    genon_time=cell2mat(DataOut.Val( logical(strcmp([DataOut.Label],'TimGenOn')) ));
    genoff_time=cell2mat(DataOut.Val( logical(strcmp([DataOut.Label],'TimGenOf')) ));
    if genoff_time <9999.8 && genon_time>=0
        %we are in shutdown (SDE)-emergency or (SDN)-normal 
        t_in=pitch_time-t_offset;
        t_out=max(t_temp);
    elseif genoff_time >9999.8 && genon_time>0 && genon_time<9999.8
        %we are in startup (STR)
        t_in=pitchE_time-t_offset;
        t_out=max(t_temp);
    elseif pitch_time<9999.8 && genon_time==0 && genoff_time >99999.8
        % we are in some pitch maneuver where the generator
        % is on the whole time. Choose a little bit after
        % the  pitch maneuver time (to remove the min)
        t_in=mean(pitch_time+10)-t_offset;
        t_out=max(t_temp);

    elseif genoff_time >9999.8 && genon_time==0
        %we are in POW
         t_out=max(t_temp); % 
         if max(t_temp)>10000
            t_in=300; % this is very arbitrary... 
         else
             t_in=0;
         end
    elseif genoff_time >9999.8 && genon_time>9999.8
        %we are in PAR
         t_out=max(t_temp); % 
         if max(t_temp)>10000
            t_in=300; % this is very arbitrary... 
         else
             t_in=0;
         end  
    else
        disp('Not in POW, SDE, SDN, STR, or PAR? Setting time truncation to default')
        t_in=0;
        t_out=max(t_temp);
    end
end