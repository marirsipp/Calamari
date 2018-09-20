function linenames=setTrussLineTypes(Model,Ptfm,mult,iRigid)
%% TODO: add knee braces!
%% 
linetypes= {'LMB', 'UMB', 'VBr'};
linenames= {'Lower Main Beam','Upper Main Beam','V-Brace'};
if iRigid
%     MPUL=repmat(10e-6, [1 3]) ; % [kg/m] taken into account in WAMIT import
%     EIxs=repmat(1e9, [1 3]); %[N-m^2] 
%     EAs=repmat(1e-12, [1 3]); %[N] doesn't matter since it follows the vessel
%     GJs=repmat(1e9 , [1 3]); % [N-m^2] 
     Cds=repmat(1.2, [1 3]); % [-] 
     Cas= [1., 1., 1.]; % [-] 
     Poisson = .3;
else
     Cds=[1.2 1.2 1.2];%[-]
     Cas = [1 1 1];%[-] 
     Poisson = .3;
end 
nTypes=1;
for jj = 1:length(linetypes)   
    if ~iRigid
        [tu,it]= unique( Ptfm.(linetypes{jj}).t);
        nTypes=length(tu);
    end
    for kk=1:nTypes
        if ~iRigid
            maxt=max(tu);
            mint=min(tu);
            if mint~=maxt
                pout=linmap( [mint maxt], [255 0],tu(kk));
            else
                pout=0;
            end
            pcolor=0*65536+round(pout)*256+255; % b, g, r
            
            lnamef=sprintf('_%dmm',round(1000*tu(kk)));
            OD = Ptfm.(linetypes{jj}).D(kk);
            ID= Ptfm.(linetypes{jj}).D(kk)-2*tu(kk);
            EI(1)= Ptfm.E * pi/4*((OD/2).^4 - (ID/2).^4);
            EI(2) = ofx.OrcinaDefaultReal();
            A= pi*((OD/2).^2 - (ID/2).^2);
            EA=Ptfm.E*A;
            MPUL=Ptfm.Density*A; %[kg/m]
            GJ=2*EI(1)*.3845; % % [N-m^2]
            lname=[linetypes{jj} lnamef];
        else
            % set rigid line properties
            pcolor= 0*65536+255*256+255; %
            lname= linenames{jj};
            OD = Ptfm.(linetypes{jj}).D(1); % shouldn't they all be the same?
            
            ID=0; %set it to something, I don't think it matters
            EI(1)=1e9; %[N-m^2] 
            EI(2) = ofx.OrcinaDefaultReal();
            EA=1e-12;
            MPUL=10e-6;
            GJ=1e9;           
        end
        
        Cd=[Cds(jj) ofx.OrcinaDefaultReal() 0];
        CdD =  OD;
        Ca=[Cas(jj) ofx.OrcinaDefaultReal() 0];
        Cm={ofx.OrcinaDefaultReal(),ofx.OrcinaDefaultReal(),ofx.OrcinaDefaultReal()};
        %Cm={0, 0, 0};
        try 
            Truss = Model(lname);
        catch
            Truss = Model.CreateObject(ofx.otLineType,lname);
        end
        setLineType(Truss,OD,ID,MPUL,EI,EA,Poisson,GJ,Cd,CdD,Ca,Cm,pcolor);
    end 
    if ~iRigid
       % add another linetype for the beams inside of other beams (rigidity
       % is defined by mult)
       p1=[153 255];
        for mm=1:length(mult)
            mx=mult(mm);
            pcolor= p1(mm)*65536+0*256+p1(mm); % purple
            lnamef=sprintf('_%dE',mx);
            OD = 1e-2; % need to have a little bit so that Modal Analysis still works!
            ID= 0 ; %set it to something, I don't think it matters
            ODreal=Ptfm.(linetypes{jj}).D(1);
            IDreal=Ptfm.(linetypes{jj}).D(1)-2*Ptfm.(linetypes{jj}).t(1,jj) ; % which thickness should I use?!?
            EI(1)= mx* Ptfm.E * pi/4*((ODreal/2).^4 - (IDreal/2).^4);
            EI(2) = ofx.OrcinaDefaultReal();
            A= pi*((ODreal/2).^2 - (IDreal/2).^2);
            EA=mx*Ptfm.E*A;        
            MPUL=1e-1; % need to have a little bit so that Modal Analysis still works!
            GJ=2*EI(1)*.3845; % % [N-m^2]
            lname=[linetypes{jj} lnamef];
            Cd=[0 0 0];
            CdD=ODreal;
            Ca=[0 0 0];
            Cm={0 0 0};%{ofx.OrcinaDefaultReal(),ofx.OrcinaDefaultReal(),ofx.OrcinaDefaultReal()};
            try 
                Truss = Model(lname);
            catch
                Truss = Model.CreateObject(ofx.otLineType,lname);
            end        
            setLineType(Truss,OD,ID,MPUL,EI,EA,Poisson,GJ,Cd,CdD,Ca,Cm,pcolor);
        end
    end

end
end