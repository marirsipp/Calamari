function setLineType(LT,OD,ID,MPUL,EI,EA,Poisson,GJ,Cd,CdD,Ca,Cm,pcolor,varargin)
if nargin<13
    pcolor= 0*65536+255*256+255; %=yellow
end
    % Geometry and Mass
    LT.OD =OD; % [m]
    LT.ID= ID; % [m]
    LT.MassPerUnitLength= MPUL;  % [kg/m]
    % Structure
    LT.EIx = EI(1) ; %[N-m^2] 
    LT.EIy = EI(2);
    LT.EA = EA; 
    LT.PoissonRatio = Poisson;
    LT.GJ=GJ; 
    % Drag + Lift
    LT.Cdx = Cd(1);
    LT.Cdy = Cd(2);
    LT.Cdz = Cd(3);
    LT.NormalDragLiftDiameter = CdD;
    % Added Mass + Inertia
    LT.Cax= Ca(1); %[-] 
    LT.Cay= Ca(2); %[-]
    LT.Caz= Ca(3); %[-]
    try
        LT.Cmx=Cm{1}; 
    catch
        error('set your Cms using {} (curly brackets)')
    end
    LT.Cmy=Cm{2}; 
    LT.Cmz=Cm{3}; 
%         else
%             %leave unset LT.Cmy=Cm{2}; LT.Cmz=Cm{3};
%         end
    LT.PenColour=pcolor;
end

