function[S] = stress_tmhist(M,StrNm,theta)

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

for j = 1:size(StrNm,1) %Iterate for each hot spot
    %Normal stress time history for each hot spot, Tot_Str_Nm=[SY; SZ; SYZ]
%     Tot_Str_Nm = (StrNm(j,1:3)'*Fx/100 + StrNm(j,4:6)'*Fy/100 + StrNm(j,7:9)'*Fz/100 + StrNm(j,10:12)'*Mx/1000 + StrNm(j,13:15)'*My/1000 + StrNm(j,16:18)'*Mz/1000 );
    Tot_Str_Nm = (StrNm(j,1:3)'*Fx + StrNm(j,4:6)'*Fy + StrNm(j,7:9)'*Fz + StrNm(j,10:12)'*Mx + StrNm(j,13:15)'*My + StrNm(j,16:18)'*Mz );

    Tot_SY = Tot_Str_Nm(1,:);
    Tot_SZ = Tot_Str_Nm(2,:);
    Tot_SYZ = Tot_Str_Nm(3,:);
    
    Tot_S1 = ((Tot_SY+Tot_SZ)/2 + ( ((Tot_SY-Tot_SZ)/2).^2 + Tot_SYZ.^2 ).^0.5);
    Tot_S2 = ((Tot_SY+Tot_SZ)/2 - ( ((Tot_SY-Tot_SZ)/2).^2 + Tot_SYZ.^2 ).^0.5);

    Tot_Smax = Tot_S1;
    index_S2lgr = find (abs(Tot_S2)>abs(Tot_S1));
    Tot_Smax(index_S2lgr) = Tot_S2(index_S2lgr);
    
    Tot_taomax = 0.5*(Tot_S1-Tot_S2);
    Tot_taomin = -0.5*(Tot_S1-Tot_S2);
    
    %theta = 0:10:180;
    if ~isempty(theta)
        for n = 1:length(theta)
            [S_rot, T_rot] = RotateStress(Tot_SY, Tot_SZ, Tot_SYZ, theta(n));
            %theta_rad = theta(n)/180*pi;
            %S_rot = 0.5*(Tot_SY+Tot_SZ)+0.5*(Tot_SY-Tot_SZ)*cos(2*theta_rad)+Tot_SYZ*sin(2*theta_rad);
            %T_rot = -0.5*(Tot_SY-Tot_SZ)*sin(2*theta_rad)+Tot_SYZ*cos(2*theta_rad);
            fdname = ['theta' num2str(theta(n))];
            S(j).Srot.(fdname) = S_rot;
            S(j).Trot.(fdname) = T_rot;
        end
    end
    
    S(j).SY = Tot_SY;
    S(j).SZ = Tot_SZ;
    S(j).SYZ = Tot_SYZ;
    S(j).S1 = Tot_S1;
    S(j).S2 = Tot_S2;
    S(j).Smax = Tot_Smax;
    S(j).TaoMax = Tot_taomax;
    S(j).TaoMin = Tot_taomin;
    
end

end