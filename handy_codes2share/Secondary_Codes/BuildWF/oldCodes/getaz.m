function [az,dec,gam]=getaz(azdes,decdes,gamdes,azold,decold,gamold)
% The 3 angles, Azimuth, Declination and Gamma, specify the orientation of Exyz relative to the local axes Lxyz of the object to which the end is connected, as follows. (If the line end is not connected to another object, then it is either Fixed, Anchored or Free. In these cases the angles define Exyz relative to the global axes GXYZ.)
% Start with Exyz aligned with Lxyz.
% Then rotate Exyz by Azimuth degrees about Ez (= Lz at this point).
% Now rotate by Declination degrees about the resulting Ey direction.
% Finally rotate by Gamma degrees about the resulting (and final) Ez direction.
% In all these rotations, a positive angle means rotation clockwise about the positive direction along the axis of rotation, and a negative angle means anti-clockwise.
% Three-dimensional rotations are notoriously difficult to describe and visualise.

%probably only works for decdes=90 deg
azrel=azdes-azold;
ht=1;
if abs(azrel)>180
    ht=-1;
end
pt=1;
if (azrel<0 && azrel>-180) || (azrel>180 && azrel<360)
    pt=-1;
    decold=mod(decold+180,360);
end
az=ht*sign(azrel)*decold;
dec=mod( pt*azrel, 180);
gam=-az;
end