function linenames=setCOLLineTypes(Model,Ptfm,iRigid,CaCOL)
colnames={'Col 1','Col 23'};
if iRigid
    Poisson = .5;
else
    Poisson = .3;
end 
    

for jj=1:2
    %% Column 1 or 2/3
    iIS=1;
    if isfield(Ptfm.iCol,'t')
        tmpt=Ptfm.iCol.t(:,jj);
        nSec=length(tmpt(tmpt~=0));
        if nSec==0
            iIS=0;
            nSec = 1;
        end
    else
        nSec=1;
    end
        % Structure     
    for kk=1:nSec
        
        if isfield(Ptfm.iCol,'t')
            if iIS
                lname=sprintf('%s_%dmm',colnames{jj},round(1000*Ptfm.iCol.t(kk,jj))); 
            else
                lname=sprintf('%s_%dmm',colnames{jj},round(1000*Ptfm.Col.t(kk,jj)));
            end
        else
            lname=colnames{jj};
            pcolor=0*65536+round(128)*256+255; % b, g, r
        end

        linenames{nSec*(jj-1)+kk}=lname;
        try 
            Col1LT = Model(lname);
        catch
            Col1LT = Model.CreateObject(ofx.otLineType,lname);
        end
        if ~iRigid
            if ~isfield(Ptfm.Col,'t')
                ODt=0;
            else
                ODt=Ptfm.Col.t(jj);
            end
            OD = Ptfm.Col.D(jj) + 2*ODt; % [m] buoyancy properties of outer shaft, yes, it is weird we define the cols by ID and thickness
            maxt=.125; % 125mm is a lot!
            mint=.01; % 10 mm is very thin!

            ID=Ptfm.Col.D(jj);% [m] yes, it is weird we define the cols by ID
            if Ptfm.iCol.D(jj)>0
                iColD=Ptfm.iCol.D(jj);
                iColt=Ptfm.iCol.t(kk,jj);
            else
                iColD=Ptfm.Col.D(jj);
                iColt=Ptfm.Col.t(jj);
            end
            pout=linmap( [mint maxt], [255 0],iColt);
            pcolor=0*65536+round(pout)*256+255; % b, g, r
            EI(1)= Ptfm.E * pi/4*((iColD/2).^4 - ((iColD-2*iColt)/2) .^4);
            EI(2) = ofx.OrcinaDefaultReal();
            A= pi*((iColD/2).^2 - ((iColD-2*iColt)/2) .^2); % area properties of inner shaft
            EA=Ptfm.E*A; % axial stiffness properties of inner shaft
            MPUL=Ptfm.Density*A; %[kg/m]
            GJ=2*EI(1)*.3845; % % [N-m^2]
            % Drag + Lift
            Cd(1) = .65;
            Cd(2) = ofx.OrcinaDefaultReal();
            Cd(3) = 0;
            CdD = OD;
            % Added Mass + Inertia
            Ca(1)= CaCOL;%.9;%.62, .8; %[-] 
            Ca(2)= ofx.OrcinaDefaultReal(); %[-]
            Ca(3)=0; %[m]
            Cm{1}=ofx.OrcinaDefaultReal(); Cm{2}=ofx.OrcinaDefaultReal(); Cm{3}=ofx.OrcinaDefaultReal();
            %Cm={0, 0, 0};
            setLineType(Col1LT,OD,ID,MPUL,EI,EA,Poisson,GJ,Cd,CdD,Ca,Cm,pcolor);
        else
            %  buoyancy is taken into account in the vessel (WAMIT import)
            % mass taken into account in WAMIT import
            %           linetype, OD, ID,Mass, EIx EIy, EA,  Poisson, GJ,
            setLineType(Col1LT,10e-6,0,10e-6,[1e9 1e9],1e-12,Poisson,1e9,[.65 .65 0],Ptfm.Col.D(jj),[0 0 0],{ofx.OrcinaDefaultReal(),ofx.OrcinaDefaultReal(),ofx.OrcinaDefaultReal()});
        end
    end
end
end
