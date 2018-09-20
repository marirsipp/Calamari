function [V1,V2,V3]=CalBallastWeight(M, r1, r2,r3,Wta)
%% JDN written to calculate the ballast weight given the corrective moment 
% Wta=W1+W2+W3;Wta=WtotalActive
% My=W1*r1x+W2*r2x+W3*r2x;
% Mx=W1*r1y+W2*r2y+W3*r2y;
% Wta = 711372.66 * 9.80655;
% colc2c = 52.7;
% triheight = sqrt(3)/2*colc2c;
% % (Rotate2DMat([FAST_Ballast(i,1), FAST_Ballast(i,2)],(Wind_Dir-yawfix)*pi/180)
% M = Rotate2DMat([-5.65E6,-2.7E+07], 180*pi/180);
% r1 = [triheight*2/3 0];
% r2 = [-triheight*1/3 colc2c/2];
% r3 = [-triheight*1/3 -colc2c/2];


%assign values
Mx=M(1,1);My=M(1,2);
r1x=r1(1,1);r1y=r1(1,2);
r2x=r2(1,1);r2y=r2(1,2);
r3x=r3(1,1);r3y=r3(1,2);

b=[Wta My Mx]';
a=[1    1   1
   r1x r2x r3x
   r1y r2y r3y];

W=inv(a)*b;

V1=W(1)/(9.81);%kg
V2=W(2)/(9.81);%kg
V3=W(3)/(9.81);%kg
mass = [V1, V2, V3];

end

