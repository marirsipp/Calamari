function linenames=setTurbineLineTypes(Model,Turbine,iRigid)
if iRigid
    linenames={'Tower drag' ,'Tower drag0'};
    % Geometry and Mass
    ODs=[10e-6 10e-6];
    IDs=[0 0];
    Ms= [10e-6 10e-6];
    EIs= [1e9 1e9];
    EAs=[1e-12 1e-12];
    Poisson=.5;
    GJs=[1e9 1e9];
    Cds=repmat([.7 ofx.OrcinaDefaultReal() 0],[2 1]);
    Cl=[0 0];
    if isfield(Turbine.Tower,'D')
        CdD=Turbine.Tower.D;
    else
        CdD= 5.806; % Vestas 8 MW for now...
    end
    Ca= repmat([0 ofx.OrcinaDefaultReal() 0],[2 1]);
    jcolor=[255*65536+0*256+0 255*65536+0*256+0];
else
    if ~isfield(Turbine.Tower,'D')
        error('Please define your turbine tower in getMyTurbine')
    end
    nSec=length(Turbine.Tower.D);
    for jj=1:nSec
       try
            linenames{jj}= Turbine.Tower.Name{jj};
       catch
           linenames{jj}= Turbine.Tower.Name(jj,:);
       end
       ODs = Turbine.Tower.D;
       IDs= Turbine.Tower.D - 2*Turbine.Tower.t;
       Ms = Turbine.Tower.M./Turbine.Tower.H ;% [kg/m]sort of close to pi*Turbine.Tower.t.*Turbine.Tower.D*Turbine.Tower.Density; %[kg/m] (don't include height of section)
       EIs=Turbine.Tower.E*Turbine.Tower.I; %[N-m^2]
       EAs=pi/4*(ODs.^2-IDs.^2).*Turbine.Tower.E; %[N]
       
       J=Turbine.Tower.I*2; % [m^4] polar moment of inertia 
       G=Turbine.Tower.E*.3845; % [N/m^2] shear modulus 
       GJs= G.*J; % [N-m^2] torsional stiffness
       Poisson= .293;
       Cds=repmat([.8 ofx.OrcinaDefaultReal() 0],[nSec 1]);
       Cl=zeros(nSec,3);
       CdD=ODs;
       Ca=repmat([0 ofx.OrcinaDefaultReal() 0], [nSec,1]);
       dc=round(255/nSec);
       jcolor(jj)=(dc*jj)*65536+0*256+255-dc*jj; %red->blue
    end
end
for jj=1:length(linenames)
   try 
        Line = Model(linenames{jj});
   catch
        Line = Model.CreateObject(ofx.otLineType,linenames{jj});
   end
    setLineType(Line,ODs(jj),IDs(jj),Ms(jj),[EIs(jj)  ofx.OrcinaDefaultReal()],EAs(jj),Poisson,GJs(jj),Cds(jj,:),CdD(jj),Ca(jj,:),{ ofx.OrcinaDefaultReal(), ofx.OrcinaDefaultReal(), ofx.OrcinaDefaultReal()},jcolor(jj)) 
end
end