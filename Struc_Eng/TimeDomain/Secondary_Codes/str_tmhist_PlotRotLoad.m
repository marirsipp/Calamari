function[]=str_tmhist_PlotRotLoad(M_orig, StrNm, Mtheta, Stheta)
%Plot rotated stress time history based on forces/moments projected onto a 
%rotated coordinate system

N_Mtheta = length(Mtheta);
sfname = ['theta' num2str(Stheta)];

for n=1:N_Mtheta
    Mrot = []; %Force and moments in rotated coordinate system
    Frot = [];
    theta = Mtheta(n)/180*pi; %Convert to radians
    Frot = ([cos(theta),sin(theta);-sin(theta),cos(theta)]* M_orig(:,1:2)')';
    Mrot = ([cos(theta),sin(theta);-sin(theta),cos(theta)]* M_orig(:,4:5)')';
    
    Load_Rot1 = zeros(size(M_orig));
    Load_Rot1(:,1) = Frot(:,1)*cos(theta);
    Load_Rot1(:,2) = Frot(:,1)*sin(theta);
    
    Load_Rot2 = zeros(size(M_orig));
    Load_Rot2(:,1) = Frot(:,2)*cos(theta+pi/2);
    Load_Rot2(:,2) = Frot(:,2)*sin(theta+pi/2); 
    
    Load_Rot3 = zeros(size(M_orig));
    Load_Rot3(:,3) = M_orig(:,3);
    
    Load_Rot4 = zeros(size(M_orig));
    Load_Rot4(:,4) = Mrot(:,1)*cos(theta);
    Load_Rot4(:,5) = Mrot(:,1)*sin(theta);
    
    Load_Rot5 = zeros(size(M_orig));
    Load_Rot5(:,4) = Mrot(:,2)*cos(theta+pi/2);
    Load_Rot5(:,5) = Mrot(:,2)*sin(theta+pi/2); 
    
    Load_Rot6 = zeros(size(M_orig));
    Load_Rot6(:,6) = M_orig(:,6);
    
    Str1 = stress_tmhist(Load_Rot1,StrNm,Stheta);
    Str2 = stress_tmhist(Load_Rot2,StrNm,Stheta);
    Str3 = stress_tmhist(Load_Rot3,StrNm,Stheta);
    Str4 = stress_tmhist(Load_Rot4,StrNm,Stheta);
    Str5 = stress_tmhist(Load_Rot5,StrNm,Stheta);
    Str6 = stress_tmhist(Load_Rot6,StrNm,Stheta);
    
    Str_F = [Str1.Srot.(sfname)',Str2.Srot.(sfname)',Str3.Srot.(sfname)'];
    Str_M = [Str4.Srot.(sfname)',Str5.Srot.(sfname)',Str6.Srot.(sfname)'];
    h=figure(n);
    set(h, 'Name', ['Mrot_' num2str(Mtheta(n))], 'NumberTitle', 'Off')
    subplot(1,2,1)
    plot(Str_F)
    legend({'Fx\_rot', 'Fy\_rot', 'Fz'})
    xlabel('Time step')
    ylabel('Srot (MPa)')
    
    subplot(1,2,2)
    plot(Str_M)
    legend({'Mx\_rot','My\_rot','Mz'})
    xlabel('Time step')
    ylabel('Srot (MPa)')
    h1=subplot(1,2,1);
    h2=subplot(1,2,2);
    title(h1,['Srot time history, force coordinate rotate ' num2str(Mtheta(n)) ' deg'])
    title(h2,['Moment coordinate rotate ' num2str(Mtheta(n)) ' deg'])
end

end