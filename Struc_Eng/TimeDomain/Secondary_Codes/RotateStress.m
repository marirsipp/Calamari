function[Srot,Trot] = RotateStress(Sx,Sy,Sxy,theta)
%Calculates normal and shear stress in a plane with theta degree angle from
%the normal x-plane in local coordinate system
%Based on 3 dof plane stress state
%Input:
%Sx    - MPa/Pa, normal stress in x direction in local x-y coordinate
%Sy    - MPa/Pa, normal stress in y direction in local x-y coordinate
%Sxy   - MPa/Pa, shear stress in local x-y coordinate
%theta - Degree, angle between rotated plane normal and positive x
%direction

theta_rad = theta/180*pi;
Srot = 0.5*(Sx+Sy)+0.5*(Sx-Sy)*cos(2*theta_rad)+Sxy*sin(2*theta_rad);
Trot = -0.5*(Sx-Sy)*sin(2*theta_rad)+Sxy*cos(2*theta_rad);

end
