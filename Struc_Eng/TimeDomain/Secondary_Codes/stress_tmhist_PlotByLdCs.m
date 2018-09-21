function[] = stress_tmhist_PlotByLdCs(M,StrNm,theta)
%Generate stress time histories based on input load time history
%Input:
%M - Load time history
%StrNm - stress matrix per unit tower base loads

Fx=M(:,1)'; %kN
Fy=M(:,2)'; %kN
Fz=M(:,3)'; %kN

Mx=M(:,4)'; %kN.m
My=M(:,5)'; %kN.m
Mz=M(:,6)'; %kN.m

for jj = 1:size(StrNm,1) %Iterate for each hot spot
    Str_Fx = StrNm(jj,1:3)'*Fx;
    Str_Fy = StrNm(jj,4:6)'*Fy;
    Str_Fz = StrNm(jj,7:9)'*Fz;
    Str_Mx = StrNm(jj,10:12)'*Mx;
    Str_My = StrNm(jj,13:15)'*My;
    Str_Mz = StrNm(jj,16:18)'*Mz;
    
    SY = [Str_Fx(1,:);Str_Fy(1,:);Str_Fz(1,:);Str_Mx(1,:);Str_My(1,:);Str_Mz(1,:)]';
    SZ = [Str_Fx(2,:);Str_Fy(2,:);Str_Fz(2,:);Str_Mx(2,:);Str_My(2,:);Str_Mz(2,:)]';
    SYZ = [Str_Fx(3,:);Str_Fy(3,:);Str_Fz(3,:);Str_Mx(3,:);Str_My(3,:);Str_Mz(3,:)]';
    
    if nargin <3
        figure(jj)
        subplot(1,3,1)
        plot(SY);
        xlabel('Time step')
        ylabel('\sigma_y')
        subplot(1,3,2)
        plot(SZ);
        xlabel('Time step')
        ylabel('\sigma_z')
        subplot(1,3,3)
        plot(SYZ);
        xlabel('Time step')
        ylabel('\tau_{yz}')
        legend({'Fx','Fy','Fz','Mx','My','Mz'})
    else
        Tot_SY = reshape(SY,[],1);
        Tot_SZ = reshape(SZ,[],1);
        Tot_SYZ = reshape(SYZ,[],1);
        [Tot_S_rot, Tot_T_rot] = RotateStress(Tot_SY, Tot_SZ, Tot_SYZ, theta);
        S_rot = reshape(Tot_S_rot,[],6);
        figure(jj)
        plot(S_rot)
        legend({'Srot\_Fx','Srot\_Fy','Srot\_Fz','Srot\_Mx','Srot\_My','Srot\_Mz'})
        xlabel('Time step')
        ylabel(['Srot, theta=' num2str(theta)])
    end
end
end