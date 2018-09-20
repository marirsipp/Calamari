function [Aaz,Adec,Agam,varargout]=getAzInOF(Model,Line,GAX,GBX,CA,CB,varargin)
% Given a desired az, dec, gam and a connected object, get the relative
% values
% The 3 angles, Azimuth, Declination and Gamma, specify the orientation of Exyz relative to the local axes Lxyz of the object to which the end is connected, as follows. (If the line end is not connected to another object, then it is either Fixed, Anchored or Free. In these cases the angles define Exyz relative to the global axes GXYZ.)
% Start with Exyz aligned with Lxyz.
% Then rotate Exyz by Azimuth degrees about Ez (= Lz at this point).
% Now rotate by Declination degrees about the resulting Ey direction.
% Finally rotate by Gamma degrees about the resulting (and final) Ez direction.
% In all these rotations, a positive angle means rotation clockwise about the positive direction along the axis of rotation, and a negative angle means anti-clockwise.
% Three-dimensional rotations are notoriously difficult to describe and visualise.

%[GAX,GBX]= getAbsXinOF(Model,Line);

Laz=180/pi*mod(atan2(GBX(2)-GAX(2),GBX(1)-GAX(1)),2*pi); % X-Y plane
Ldec=180/pi*mod(atan2(GBX(3)-GAX(3),GBX(1)-GAX(1)),2*pi); % Z-X plane
Lphi=180/pi*mod(atan2(GBX(3)-GAX(3),GBX(2)-GAX(2)),2*pi); % Z-Y plane
%[CA,CB]=getConnectNames(Model(Line));
   
iAfree=amIfree(CA);
iBfree=amIfree(CB);
if ~iAfree
    [GCAX,GCBX]= getAbsXinOF(Model,CA);
end
if ~iBfree
    [GBAX,GBBX]= getAbsXinOF(Model,CB);
end
if nargin>6
    Lxstr=varargin{1};
else
    Lxstr='';
end
if nargin>7
    Lystr=varargin{2};
else
    Lystr='';
end
[Gaz,Gdec,Ggam]=getAbsAz(Laz,Ldec,Lphi,Lxstr,Lystr);
if iAfree
    Aaz=Gaz; Adec=Gdec; Agam = Ggam;
elseif isempty(GCBX)
    % connected to a buoy or vessel
    [RAXr,RBXr]=getRXinOF(Model(CA)); % RBXr is empty
    % hopefully your buoy or vessel coordinates point match Global
    Aaz=Gaz; Adec= Gdec; Agam= Ggam;
    %az=Gaz-RAXr(1); dec=Gdec-RAXr(2); gam=Ggam-RAXr(3);
else
    %it is connected to a line..
    if nargout>3
        if strcmp(Line,'Tower')
            [Gaz,Gdec,Ggam]
            [Laz,Ldec,Lphi]
            pause
        end
        Line=CA; % recurse
        [CA,CB]=getConnectNames(Model(Line));
        [GAX,GBX]= getAbsXinOF(Model,Line);
        [Laz,Ldec,Lgam]=getAzInOF(Model,Line,GAX,GBX,CA,CB,Lxstr,Lystr); % keep same orientation as initial
        Adec = mod(Gaz-Laz,360) ;
        if Adec>180
            Adec=abs(Adec-360);
            Dgam=180;
        else
            Dgam=0;
        end
        Aaz = Gdec - Ldec + Dgam;  
        Agam= Ggam - Lgam + Dgam;
    else
        % return the global
        Aaz=Gaz; Adec= Gdec; Agam= Ggam;
    end
end

if iBfree
    Baz=Gaz; Bdec=Gdec; Bgam=Ggam;
elseif isempty(GBBX)
    % hopefully your buoy or vessel coordinates point match Global
    Baz=Gaz; Bdec= Gdec; Bgam= Ggam;
else
    Line=CB; % recurse
    [CA,CB]=getConnectNames(Model(Line));
    [GAX,GBX]= getAbsXinOF(Model,Line);
    [Laz,Ldec,Lgam]=getAzInOF(Model,Line,GAX,GBX,CA,CB,Lxstr,Lystr); % keep same orientation as initial
    %[Laz,Ldec,Lgam]=getAzInOF(Model,CB,Lxstr,Lystr); % does this work?
    Bdec =  mod(Gaz-Laz,360); 
    if Bdec>180
        Bdec=abs(Bdec-360);
        Dgam=180;
    else
        Dgam=0;
    end
    Baz = Gdec - Ldec + Dgam; 
    Bgam= Ggam - Lgam + Dgam;
end
varargout{1} = Baz;
varargout{2} = Bdec;
varargout{3} = Bgam;
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

function [Gaz,Gdec,Ggam]=getAbsAz(Laz,Ldec,Lphi,Lxstr,Lystr)
% Always true for az
Gaz=Laz;
% keep Gdec between 0 and 180
if mod(Lphi,90)>0 || (mod(Lphi,90)==0 && Laz~=Ldec)
    dec2use=Lphi;
else
    dec2use=Ldec;
end
if 90-dec2use>=0
    Gdec=90-dec2use;
elseif 90-dec2use<=-180
    Gdec=90-dec2use+360;
else
    Gdec=abs(90-dec2use);
end
% gam is tough...
if ~isempty(Lxstr)
    if strcmp(Lxstr,'+Y')
        Dgam=90;
    elseif strcmp(Lxstr,'-Y')
        Dgam=270;
    elseif  strcmp(Lxstr,'-X')
        if Gaz==0 && Gdec==0
            Dgam=180;
        else
            Dgam=0; % this is not right for a vertical up line
        end
    elseif  strcmp(Lxstr,'+X')
        if Gaz==0 && Gdec==0
            Dgam=180; % total guess
        else
            Dgam=0; % total guess
        end
    end
    Ggam=mod(Gaz+Dgam,360);
    return
end
if ~isempty(Lystr)
    if strcmp(Lystr,'+Z')
        Dgam=90;
    elseif strcmp(Lystr,'-Z')
        Dgam=270;
    elseif  strcmp(Lystr,'+X')
        Dgam = Gaz-90;
    else
        Dgam=0;
    end
    Ggam=Dgam;
end
if isempty(Lxstr) &&  isempty(Lystr)
    % make something up
    Ggam=mod(Gaz+90,360);
end
end
function [RAXr,RBXr]=getRXinOF(CA)
    if strcmp(CA.typeName,'6D Buoy') || strcmp(CA.typeName,'Vessel')
        RAXr(1)= CA.InitialRotation1 ; RAXr(2)= CA.InitialRotation2 ; RAXr(3)= CA.InitialRotation3 ;
        RBXr=[];
    elseif strcmp(CA.typeName,'Line')
        RAXr(1)= CA.EndAAzimuth  ; RAXr(2)= CA.EndADeclination ; RAXr(3)= CA.EndAGamma ; 
        RBXr(1)= CA.EndBAzimuth  ; RBXr(2)= CA.EndBDeclination ; RBXr(3)= CA.EndBGamma ;
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
%     azrel=Laz-Caz;
%     if (azrel<0 && azrel>-180) || (azrel>180 && azrel<360)
%         pt=-1;
%     else
%         pt=1;
%     end
%     az=sign(azrel)*Cdec;
%     dec= mod( pt*azrel, 180);
%     gam=-az;