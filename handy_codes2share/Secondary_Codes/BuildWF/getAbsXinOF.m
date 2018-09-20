function [GAX,GBX,RAX,RBX]= getAbsXinOF(Model,Object)
OFobj = Model(Object);
[CA,CB]=getConnectNames(OFobj); %'Free', 'Anchored', ConnectedObj Name, or blank if buoy/vessel
iAfree=amIfree(CA);
iBfree=amIfree(CB);
[GAX, GBX] = getXinOF(OFobj); % return positions of main object (don't know if its relative or absolute)
[RAX, RBX] = getRXinOF(OFobj);
%
if iAfree
    % don't do anything. GAX is correct
    
    % Point z in axial direction
    
    RAX=pointZinAx(RAX);
else
    AXr=GAX; % we realize that the object has an A connection
    if iBfree
        BXr=[0 0 0];
    else
        BXr=GBX; % object has a non-free B connection. (could be empty) 
    end
    %recurse on CA
    [GAXin,GBXin]= getAbsXinOF(Model,CA);
    %we recursively believe that GAXin and GBXin are absolute
    [GAX,foo]=getAbsXFromRelX(GAXin,GBXin,AXr,BXr);
end

if ~isempty(CB)
    % object is line
    if iBfree
         % don't do anything. GBX is correct
    else
        BXr=GBX; % we realize that the object has a B connection
        %recurse on CB
        [GAXin,GBXin]= getAbsXinOF(Model,CB);
        %we recursively believe that GAXin and GBXin are absolute
        [foo,GBX]=getAbsXFromRelX(GAXin,GBXin,nan(1,3),BXr);
    end
else % object is a buoy or a vessel
    GBX=[];
end
varargout{1}=RAX;
varargout{2}=RBX;
end
function RAX=pointZinAx(RAX)
%% Azimuth
% leave unchanged
RAX(1)=mod(RAX(1),180);
%% Declination
RAX(2)=90-RAX(2);
%% Gamma
RAX(3)=90;
% Overwrite
if RAX(2)<0 && RAX(2)>-180
    RAX(3)=270;
    RAX(2)=RAX(2)+180;  
elseif RAX(2)<=-180
    RAX(3)=90;
    RAX(2)=RAX(2)+360; 
end
end
function [GAX,GBX]=getAbsXFromRelX(GAXin,GBXin,AXr,BXr)
% [GAXin,GBXin] is 'absolute' position of connected object
% [AXr,BXr] is relative position of object
if isempty(GBXin)
    %then connected object is a buoy or vessel
    GAX = GAXin+AXr;
    if isempty(BXr) % could be empty...
        GBX=[];
    else
        GBX = GAXin+BXr;
    end
else
    % connected object is a line
    L = sqrt( sum( (GAXin-GBXin).^2 ));
    uhat = (GBXin-GAXin)/L;
    if isempty(BXr)
         % object is a buoy
         GAX = GAXin+uhat.*AXr; GBX=[];%GBX = GBX+uhat.*BXr;
    else
        % object is a line
         GAX = GAXin+uhat.*AXr(3)+[AXr(1) AXr(2) 0]; GBX = GAXin+uhat.*BXr(3)+ [BXr(1) BXr(2) 0]; % always define relative to A!!
    end
end
end

function [GAX,GBX]=getAbsRXFromRelRX(RAXin,RBXin,RAXr,RBXr)
% [GAXin,GBXin] is 'absolute' position of connected object
% [AXr,BXr] is relative position of object
if isempty(RBXin)
    %then connected object is a buoy or vessel
    RAX = RAXin+RAXr;
    GBX = GAXin+BXr; % could empty...
else
    % connected object is a line
    L = sqrt( sum( (GAXin-GBXin).^2 ));
    uhat = (GBXin-GAXin)/L;
    if isempty(BXr)
         % object is a buoy
         GAX = GAXin+uhat.*AXr; GBX=[];%GBX = GBX+uhat.*BXr;
    else
        % object is a line
         GAX = GAXin+uhat.*AXr(3)+[AXr(1) AXr(2) 0]; GBX = GAXin+uhat.*BXr(3)+ [BXr(1) BXr(2) 0]; % always define relative to A!!
    end
end
end

function iFree=amIfree(C)
if isempty(C)
    iFree=[]; % an empty object...
else
    freenames={'Free','Fixed','Anchored'};
    if sum(~cellfun('isempty',strfind(freenames,C)))
        iFree=1;
    else
        iFree=0;
    end
end
end

function [CA,CB]=getConnectNames(OFobj)
if strcmp(OFobj.typeName,'6D Buoy')
    CA=OFobj.Connection;
    CB=[];
elseif strcmp(OFobj.typeName,'Line')   
    CA=OFobj.EndAConnection;
    CB=OFobj.EndBConnection;
elseif strcmp(OFobj.typeName,'Vessel')  
    CA='Free'; CB = [];
end
end

function [AXr,BXr]=getXinOF(CA)
    if strcmp(CA.typeName,'6D Buoy') || strcmp(CA.typeName,'Vessel')
        AXr(1)= CA.InitialX ; AXr(2)= CA.InitialY ; AXr(3)= CA.InitialZ ;
        BXr=[];
    elseif strcmp(CA.typeName,'Line')
        AXr(1)= CA.EndAX ; AXr(2)= CA.EndAY ; AXr(3)= CA.EndAZ ; 
        BXr(1)= CA.EndBX ; BXr(2)= CA.EndBY ; BXr(3)= CA.EndBZ ;
    end
end

function [RAXr,RBXr]=getRXinOF(CA)
    if strcmp(CA.typeName,'6D Buoy') 
        RAXr(1)= CA.InitialRotation1 ; RAXr(2)= CA.InitialRotation2 ; RAXr(3)= CA.InitialRotation3 ;
        RBXr=[];
    elseif strcmp(CA.typeName,'Vessel')
        RAXr(1)= CA.InitialHeel ; RAXr(2)= CA.InitialTrim; RAXr(3)= CA.InitialHeading ;
        RBXr=[];        
    elseif strcmp(CA.typeName,'Line')
        RAXr(1)= CA.EndAAzimuth  ; RAXr(2)= CA.EndADeclination ; RAXr(3)= CA.EndAGamma ; 
        RBXr(1)= CA.EndBAzimuth  ; RBXr(2)= CA.EndBDeclination ; RBXr(3)= CA.EndBGamma ;
    end
end