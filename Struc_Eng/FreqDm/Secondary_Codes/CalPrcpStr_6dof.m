function [S] = CalPrcpStr_6dof (NormStr)
% CalPrcpStr_6dof.m calculates principal stress from input of 6 normal
% stresses

% Input:
% NormStr - normal stress vector (1-by-6), column 1 to 6: Sx, Sy, Sz, Mx,
%           My, Mz

Sx = NormStr(1);
Sy = NormStr(2);
Sz = NormStr(3);
Sxy = NormStr(4);
Syz = NormStr(5);
Sxz = NormStr(6);

I1 = Sx + Sy + Sz;
I2 = Sx*Sy + Sy*Sz + Sz*Sx - Sxy^2 - Syz^2 - Sxz^2;
I3 = Sx*Sy*Sz - Sx*Sxy^2 - Sy*Sxz^2 - Sz*Sxy^2 + 2* Sxy*Syz*Sxz;

theta = 1/3* acos( (2*I1^3 - 9*I1*I2 + 27*I3) / (2*(I1^2 - 3*I2)^(3/2)) );

S1 = I1/3 + 2/3 * sqrt(I1^2-3*I2) * cos(theta);
S2 = I1/3 + 2/3 * sqrt(I1^2-3*I2) * cos(theta-2*pi/3);
S3 = I1/3 + 2/3 * sqrt(I1^2-3*I2) * cos(theta-4*pi/3);
% 
% flag = isreal(S1);
% if flag ==0
%     Sx
% end

S =[S1 S2 S3];
end