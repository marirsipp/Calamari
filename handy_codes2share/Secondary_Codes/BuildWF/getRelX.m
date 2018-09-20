function AXr=getRelX(Model,CA,AX)
% CA is the object you want to connect to
% AX is the coordinates of the object you are building in the global
% coordinates
if strcmp(CA,'Free')
    AXr=AX;
else
    [GAX,GBX]= getAbsXinOF(Model,CA);
    if isempty(GBX)
        AXr=AX-GAX;
    else
        L = sqrt( sum( (GBX-GAX).^2 ));
        uvec = (GBX-GAX)/L;
        AXr=[0 0 sqrt( sum( (AX-GAX).^2 )) ]; %z is the axial direction
    end
end
%         
%     aa=0;
%     while ~strcmp(CA,'Free')
%         myColA=Model(CA);      
%         aa=aa+1;
%         CAs{aa}=CA; %build list of relative 
%         if strcmp(myColA.typeName,'6D Buoy')
%             CA=myColA.Connection;
%         elseif strcmp(myColA.typeName,'Line')   
%             CA=myColA.EndAConnection;
%         elseif strcmp(myColA.typeName,'Vessel')  
%             CA='Free';
%         end
%     end
%     % get absolute position
%     if aa>0
%         if strcmp(myColA.typeName,'6D Buoy') || strcmp(myColA.typeName,'Vessel')
%             Xabs(1)= myColA.InitialX ; Xabs(2)= myColA.InitialY ; Xabs(3)= myColA.InitialZ ;
%             AXr=AX-Xabs;
%         elseif strcmp(myColA.typeName,'Line')
%             Xabs(1)= myColA.EndAX ; Xabs(2)= myColA.EndAY ; Xabs(3)= myColA.EndAZ ; %always work relative line End A
%             Yabs(1)= myColA.EndBX ; Yabs(2)= myColA.EndBY ; Yabs(3)= myColA.EndBZ ; % End B
%             L = sqrt( sum( (Xabs-Yabs).^2 ));
%             uvec = (Yabs-Xabs)/L;
%             AXr=[0 0 sqrt( sum( (AX-Xabs).^2 )) ]; %z is the axial direction
%         end
%         %Xabs-AX; % it is the free one
%     else
%         AXr=AX; % it is already free
%     end
%     if aa==0
%         AXr=AX;% it is already free
%         return
%     else
%         myConnect=myColA; % initialize
%         for ia=aa-1:-1:1
%             myColA=Model(CAs{ia}); % get the object that is closest to free object
% %             if strcmp(myConnect.typeName,'6D Buoy') || strcmp(myConnect.typeName,'Vessel')
% %                 uvec=[1 1 1]; L=1;
% %             elseif strcmp(myConnect.typeName,'Line')
% %                 L = sqrt( sum( (Xr-Yr).^2 ));
% %                 uvec = (Yr-Xr)/L;
% %             end
%             % Get relative position of item
%             if strcmp(myColA.typeName,'6D Buoy') || strcmp(myColA.typeName,'Vessel')
%                 Xr(1)= myColA.InitialX ; Xr(2)= myColA.InitialY ; Xr(3)= myColA.InitialZ ; Yr = [0 0 0];
%             elseif strcmp(myColA.typeName,'Line')
%                 Xr(1)= myColA.EndAX ; Xr(2)= myColA.EndAY ; Xr(3)= myColA.EndAZ ; %always work relative line End A
%                 Yr(1)= myColA.EndBX ; Yr(2)= myColA.EndBY ; Yr(3)= myColA.EndBZ ; % End B
%                 
%             end
%             if strcmp(myColA.typeName,'Line') && strcmp(myConnect.typeName,'Line')
%                 Xr= sqrt( sum( (Xr).^2 )).*uvec;
%             %elseif (strcmp(myColA.typeName,'6D Buoy') || strcmp(myColA.typeName,'Vessel')) && strcmp(myConnect.typeName,'Line')
%             else 
%                 Xr=Xr.*uvec;
%             end
%             % Get absolute position of item
%             %Xr
%             Xabs=Xabs+Xr;
%             %Xabs
%             if ia==1 % when exiting
%                 if strcmp(myColA.typeName,'Line')
%                       dX=AX-Xabs;%.*uvec;%AX is global, Xabs is global[0 0 sqrt( sum( (AX-Xabs).^2 )) ]; % z is the axial direction
%                       dL =sqrt( sum( (dX).^2 )); 
%                       uvec=(Yr-Xabs)/L; % assuming Yr is free!!!
%                       nuvec=dX/L;
%                       duvec=[uvec-nuvec];
%                       AXr =[0 0 dL]; % this only works if AX lies on the line
%                 else
%                       AXr=AX-Xabs;
%                 end
%             end
%             myConnect = myColA;
%             if strcmp(myConnect.typeName,'Line')
%                 uvec = (Yr-Xabs)/sqrt( sum( (Yr-Xabs).^2 ));% assuming Yr is free!!!
%             else
%                 uvec = [ 1 1 1];
%             end
%         end
% 
%     end
% %     % get relative positiosn
% %     for ia=aa-1:-1:1
% %         myColA=Model(CAs{ia});
% %         if strcmp(myColA.typeName,'6D Buoy') || strcmp(myColA.typeName,'Vessel')
% %             Xr(1)= myColA.InitialX ; Xr(2)= myColA.InitialY ; Xr(3)= myColA.InitialZ ;
% %         elseif strcmp(myColA.typeName,'Line')
% %             Xr(1)= myColA.EndAX ; Xr(2)= myColA.EndAY ; Xr(3)= myColA.EndAZ ; %always work relative line End A
% %             Yr(1)= myColA.EndBX ; Yr(2)= myColA.EndBY ; Yr(3)= myColA.EndBZ ; % End B
% %         end
% %         %Xabs = getRelX(Model,CAs{ia},Xr);
% %         myColA
% %         Xr
% %         Xabs=Xabs-Xr; %gets the absolute position of the ia'th end A
% %         if strcmp(myColA.typeName,'Line') && ia==1
% %             AXr=[0 0 sqrt( sum( (AX-Xabs).^2 )) ]; % z is the axial direction
% %         else
% %             AXr=AX-Xabs;
% %         end
% %         
% %         AXr
% %         pause
% %     end
end