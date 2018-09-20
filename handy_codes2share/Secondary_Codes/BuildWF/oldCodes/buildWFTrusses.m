function Model=buildWFTrusses(Model,Ptfm,WEPtype,mult,TRpts,TRlabels,WFangles,vname,iRigid,OFver)
%% Function used to build Truss lines: COLs, UMBs, LMBs, VBs in OrcaFlex
% Inputs:
% Model = Orcaflex model, loaded using ofxModel
% Ptfm = structure defined in getMyPtfm
% mult = 1x2 vector hardcoded in for stiffness multipliers for stiffness
% between inner shaft and outer shell, and inside inner shaft
% TRpts, TRlabels = outputs of getMyTruss 
% WFangles are angles used when heading from one column to another (but
% flipped?)
% vname =string for the vessel name to be used only when rigid model is being built
% iRigid is 0 or 1 depending on whether to build a rigid model or a
% flexible model
% OFver is the version of OrcaFlex (whether you can connect lines to lines)
%% Output
% Model = new model with your new WindFloat!
    nCol=3;
    nTRs=length(TRpts)/2; %number of line segments ( 2 endpts per line )
    nTRc=nTRs/nCol; % number of lines per column
    nVB=length(strfind([TRlabels{:}],'VB'))/nCol; % number of V-Braces in-between columns
    %% Define baseline end stiffness properties
    if iRigid
        TRStiff.AX=0; % [N-m/deg] 
        TRStiff.BX=0; % [N-m/deg] 
        % By default set angles to 0
        TROrient.az=0;
        TROrient.dec=0; %[deg],
        TROrient.gam=0; %[deg] 
    else
        TRStiff.AX=ofx.OrcinaInfinity(); % [N-m/deg] 
        TRStiff.BX=ofx.OrcinaInfinity(); % [N-m/deg] 
        TRStiff.EndATwistingStiffness=ofx.OrcinaInfinity(); % 
        TRStiff.EndBTwistingStiffness=ofx.OrcinaInfinity(); % 
    end
    %% Loop through each of the line segments, build each one individually
    for kk=1:nTRs
        iendA=2*(kk-1)+1; % EndA index
        iendB=2*(kk-1)+2; % EndB index
        lname=TRlabels{iendA}; % line name
        lnum=str2double(regexp(lname,['\d+'],'match')); % assume that only number in line name refers to column number!! (ie Col1, or LMB1a)
        jlensT=sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2) ); %total length between points
        if strcmp(lname(1:2),'VB')
            % VB numbering goes from 1,2,.. nCol*nVB
            iC=ceil(lnum/nVB); % overwrite iC definition
            iCn=mod(iC,nCol)+1;
        else
            iC=lnum;  % default column number of EndA
            iCn=mod(iC,nCol)+1; % default column number of EndB (gets overwritten for V-brace)
        end
        Ra=Ptfm.iCol.D(iC)*.5;
        Rb=Ptfm.iCol.D(iCn)*.5;
        ODID=.5*(Ptfm.Col.D(iC)-Ptfm.iCol.D(iC));  % distance between outershell and inner shaft of ColA
        ODIDn=.5*(Ptfm.Col.D(iCn)-Ptfm.iCol.D(iCn)); % distance between outershell and inner shaft of ColB
        %% Build the Columns!
        if strcmp(lname(1:3),'COL')
            colname{iC}=lname;
            if iC==1
                linename=sprintf('Col %d',iC); % name of LineType for Col1 that is set in function setCOLLineTypes (should make this an input?)
                % col 1 inner shaft extends 1 m above rest of columns
            else
                linename='Col 23'; % name of LineType that is set in function setCOLLineTypes (should make this an input?)
            end
            if ~iRigid
                %TLS=.5; %[m]
                TROrient.az=0;
                TROrient.dec=180; %[deg], line is built going from top to bottom
                TROrient.gam=0; %[deg] 
                if OFver>9
                    ConnectA='Free'; % line ends are free, in line-to-line connection
                    ConnectB='Free'; %
                else
                    ConnectA=sprintf('Col%d U',iC); % line ends are connected to free 6D buoys
                    ConnectB=sprintf('Col%d L',iC);
                end
                % Length of line segments with different properties
                % (jlens)
                dL=[Ptfm.iCol.dL+Ptfm.UMB.dL Ptfm.UMB.dL Ptfm.UMB.dL]; %[Col1 Col2 Col3]
                AirGap=Ptfm.Col.H-abs(Ptfm.Col.Draft)+[Ptfm.iCol.dL 0 0];
                % NEED TO PLACE LINE SECTIONS (NODES) WHERE YOU WANT
                % LINES/BUOYS
                % TO INTERSECT
                ntype=size(Ptfm.iCol.H,1);
                % Sections of Cols (different thicknesses) are define in
                % the inner shaft                 
                if ntype>2
                    jlens=[dL(iC) Ptfm.iCol.H(1,iC)-dL(iC) AirGap(iC)-Ptfm.iCol.H(1,iC) Ptfm.iCol.H(2,iC)-(AirGap(iC)-Ptfm.iCol.H(1,iC)) Ptfm.iCol.H(3:end-1,iC) (Ptfm.iCol.H(end,iC)-Ptfm.LMB.dL) Ptfm.LMB.dL];
                    % Define index of which thickness to use
                    jtype=[1 1  2 2:1+ntype-2 ntype ntype];
                    discret=[2 2 2 6 2 2];
                else
                    jlens=[dL(iC) Ptfm.iCol.H(1,iC)-dL(iC)-Ptfm.LMB.dL Ptfm.LMB.dL];
                    jtype=[ntype ntype ntype];
                    discret=[2 6 2];
                end

                nSec=length(jlens);
                % Target Segment Length (some arbitrary number of segments
                % per line section)
                TLS=jlens./discret; % need high discretization in order to get the clumpweights (point masses) placed in the appropriate location
                for ss=1:nSec
                    if Ptfm.iCol.t(jtype(ss),iC)>0
                        js{ss}=sprintf('_%dmm',round(1000*Ptfm.iCol.t(jtype(ss),iC)) ); % name of LineType of Col sections, hardcoded from getCOLLineTypes
                    else
                        js{ss}=sprintf('_%dmm',round(1000*Ptfm.Col.t(jtype(ss),iC)) );
                    end
                end
            else
                 %build the COLs for the rigid model
                % NEED TO ADD SECTION FOR RIGID MODEL (do we want same
                % level of detail?)
                js={''};   
                jlens=jlensT;
                ConnectA=vname;
                ConnectB=vname; 
                TLS=jlens; % 1 segment for simplicity
            end
            ibuild=true; % boolean to determine if TRlabels are properly defined
        elseif strcmp(lname(1:3),'UMB')
            %% Build the UMBs!

            
            if ~iRigid
                linename='UMB';
                %TLS=1; %[m]
                if OFver>9
                    TROrient.az=mod(WFangles(iC)*180/pi,360); %[deg] azimuthal angle is defined based on heading (had to fliplr WFangles as defined in buildWF)
                else
                    TROrient.az=mod(WFangles(iC)*180/pi,360);
                end
                TROrient.dec=90;
                TROrient.gam=0;

                if OFver>9
                    ConnectA=colname{iC}; %  UMBs are connected to COL
                    ConnectB=colname{iCn}; 
                else
                    ConnectA=sprintf('Col%d %s',iC,lname(1));  %  UMBs are connected to 6D buoys: 'ColX U'
                    ConnectB=sprintf('Col%d %s',iCn,lname(1));  
                end
         
                [nSec,~]=size(Ptfm.UMB.t);
                iss=0;
                jlens=[];
                if Ra>0
                    iss=iss+1;
                    js{iss}=sprintf('_%dE',mult(2)); % from Col axis to inner shaft, added stiffness (like SAP model) 
                    jlens(iss) = Ra;  TLS(iss)=Ra;
                end
                iss=iss+1;
                js{iss}=sprintf('_%dE',mult(1)); % from inner shaft to outer shaft, same stiffness no buoyancy
                jlens(iss)=ODID; TLS(iss)= ODID;
                for ss=1:nSec
                    iss=iss+1;
                    js{iss}=sprintf('_%dmm',round(1000*Ptfm.UMB.t(ss,iC)) ); % name of LineType of UMB sections, hardcoded from getTrussLineTypes
                end
                jlens(iss)=Ptfm.Col.L(iC)-Ra-Rb-ODID-ODIDn; TLS(iss) = (Ptfm.Col.L(iC)-Ra-Rb-ODID-ODIDn)*.1;
                iss=iss+1;
                js{iss}=sprintf('_%dE',mult(1));%js{1}; % from outer shaft to inner shaft
                jlens(iss)=ODIDn; TLS(iss)= ODIDn;
                if Rb>0
                    iss=iss+1;
                    js{iss}=sprintf('_%dE',mult(2));%;js{2};  % from inner shaft to Col axis
                    jlens(iss)=Rb; TLS(iss) = Rb;
                end
                % define lengths of line sections
                % IS OS Can1 UMB 
                if isfield(Ptfm.UMB,'L')
                    jlens=[Ra, ODID, Ptfm.UMB.L(1,iC)-ODID, Ptfm.UMB.L(2:end-1,iC)',Ptfm.UMB.L(end,iC)-ODIDn, ODIDn,  Rb];
                    TLS=[Ra*.5, ODID, Ptfm.UMB.L(1,iC)-ODID, .1*Ptfm.UMB.L(2:end-1,iC)', Ptfm.UMB.L(end,iC)-ODIDn, ODIDn, Rb*.5];
                end
                % define target segment lengths of each section (only
                % discretize middle portion of line more...)
                

            else
                linename='Upper Main Beam';
                js={''};     
                jlens=jlensT;
                ConnectA=vname;
                ConnectB=vname; 
                TLS=jlens; % 1 segment for simplicity
                %build the UMB for the rigid model
            end
            ibuild=true;
        elseif strcmp(lname(1:3),'LMB')
            %% build the LMBs
            if ~iRigid
                linename='LMB';
                [nSec2,~]=size(Ptfm.LMB.t);
                if nSec2>1
                    nSec=nSec2/2;
                else
                    nSec=nSec2;
                end
                for ss=1:nSec2
                    jss{ss}=sprintf('_%dmm',round(1000*Ptfm.LMB.t(ss,iC)) );% name of LineType of LMB sections, hardcoded from getTrussLineTypes
                end
                % Define helpful lengths to use when defining length of
                % sections
                if isfield(Ptfm.LMB,'L')
                    CAN1L=Ptfm.LMB.L(1,iC)-ODID;
                    NODEL=Ptfm.LMB.(WEPtype).L(iC)-CAN1L;

                    CAN1nL=Ptfm.LMB.L(end,iC)-ODIDn; 
                    NODEnL=Ptfm.LMB.(WEPtype).L(iCn)-CAN1nL;
                end
                % HARD-CODED to use nLevel ==2 for LMB!!
                if strcmp(lname(end),'a')
                    % End orientation angles!!
                    if OFver>9
                        TROrient.az.A=mod(WFangles(iC)*180/pi,360); %[deg] 
                        TROrient.dec.A=90;
                        TROrient.gam.A=0; %[deg]

                        TROrient.az.B=180-mod(WFangles(iC)*180/pi,360); %[deg] 
                        TROrient.dec.B=90;
                        TROrient.gam.B=180; %[deg]
                    else
                        TROrient.az=mod(WFangles(iC)*180/pi,360);
                        TROrient.dec=90;
                        TROrient.gam=0;
                    end
                    if OFver>9
                        % IS, OS, CAN1, WEB-NODE, LMB, CAN2
                        % names of LineTypes, for each of the sectoins
                        if isfield(Ptfm.LMB,'L')
                            js={sprintf('_%dE',mult(2)), sprintf('_%dE',mult(1)), jss{1}, jss{2}, jss{2}, jss{3:nSec}}; 
                            % lengths of sections
                            jlens=[Ptfm.iCol.D(iC)*.5, ODID, CAN1L,NODEL,Ptfm.LMB.L(2,iC)-NODEL, Ptfm.LMB.L(3:nSec,iC)'];
                            %target segment lengths for each section
                            TLS=[Ptfm.iCol.D(iC)*.5, ODID, CAN1L,.2*NODEL,(Ptfm.LMB.L(2,iC)-NODEL), .5*Ptfm.LMB.L(3:nSec,iC)'];%[Ptfm.iCol.D(iC)*.5, ODID, Ptfm.LMB.L(1,iC)-ODID .5*Ptfm.LMB.L(2:nSec,iC)'];
                        else
                            if Ra>0
                                js={sprintf('_%dE',mult(2)), sprintf('_%dE',mult(1)), jss{1}}; 
                                jlens=[Ra, ODID, jlensT-Ra-ODID];
                                TLS=[Ra, ODID, (jlensT-Ra-ODID)*.25];
                            else
                                js={sprintf('_%dE',mult(1)), jss{1}}; 
                                jlens=[ODID, jlensT-Ra-ODID];
                                TLS=[ODID, (jlensT-Ra-ODID)*.25];
                            end
                        end
                        ConnectA=colname{iC}; 
                        ConnectB='Free';
                    else
                        % never figured out a way to connect WEB to LMB
                        % with OFver<10
                         % IS, OS, CAN1, LMB, CAN2
                        js={sprintf('_%dE',mult(2)), sprintf('_%dE',mult(1)), jss{1}, jss{2}, jss{3:nSec}}; 
                        jlens=[Ptfm.iCol.D(iC)*.5, ODID, CAN1L,Ptfm.LMB.L(2,iC), Ptfm.LMB.L(3:nSec,iC)'];
                        TLS=[Ptfm.iCol.D(iC)*.5, ODID, CAN1L,.5*Ptfm.LMB.L(2,iC), Ptfm.LMB.L(3:nSec,iC)'];
                        ConnectA=sprintf('Col%d %s',iC,lname(1)); 
                        ConnectB=sprintf('LMB%d%d',iC,iCn); %6D buoy representing K-joint
                    end
                elseif strcmp(lname(end),'b')
                    % End Orientation angles!!
                    if OFver>9
                        TROrient.az.A=0;%mod(WFangles(iC)*180/pi,360); %[deg] 
                        TROrient.dec.A=0;%90;
                        TROrient.gam.A=0; %[deg]
                        TROrient.az.B=mod(WFangles(iC)*180/pi,360); %[deg] 
                        TROrient.dec.B=90;
                        TROrient.gam.B=0; %[deg]
                    else
                        TROrient.az=mod(WFangles(iC)*180/pi,360);
                        TROrient.dec=90;
                        TROrient.gam=0;
                    end
                    if OFver>9
                        % CAN2,WEB-NODE, LMB, CAN1, OS, IS
                        if isfield(Ptfm.LMB,'L')
                            js={jss{nSec+1}, jss{nSec+2}, jss{nSec+2}, jss{nSec+3:end}, sprintf('_%dE',mult(1)), sprintf('_%dE',mult(2))};
                    
                            jlens=[Ptfm.LMB.L(nSec+1,iC) Ptfm.LMB.L(nSec+2,iC)-NODEnL, NODEnL, Ptfm.LMB.L(nSec+3:end-1,iC)' CAN1nL ODIDn Rb];
                            TLS=[.5*Ptfm.LMB.L(nSec+1,iC) (Ptfm.LMB.L(nSec+2,iC)-NODEnL), .2*NODEnL, Ptfm.LMB.L(nSec+3:end-1,iC)' CAN1nL ODIDn Rb];%[.5*Ptfm.LMB.L(nSec+1:end-1,iC)' Ptfm.LMB.L(end,iC)-ODIDn ODIDn Ptfm.iCol.D(iCn)*.5];
                        else
                            if Rb>0
                                js=fliplr({sprintf('_%dE',mult(2)), sprintf('_%dE',mult(1)), jss{1}}); 
                                jlens=fliplr([Rb, ODIDn, jlensT-Rb-ODIDn]);
                                TLS=fliplr([Rb, ODIDn, (jlensT-Rb-ODIDn)*.25]);
                            else
                                js=fliplr({ sprintf('_%dE',mult(1)), jss{1}}); 
                                jlens=fliplr([ODIDn, jlensT-Rb-ODIDn]);
                                TLS=fliplr([ODIDn, (jlensT-Rb-ODIDn)*.25]);
                            end
                        end
                        ConnectA=sprintf('LMB%da',iC);%sprintf('LMB%d%d',iC,iCn);                        
                        ConnectB=colname{iCn};%sprintf('Col%d %s',iCn,lname(1));
                    else
                        js={jss{nSec+1}, jss{nSec+2}, jss{nSec+3:end}, sprintf('_%dE',mult(1)), sprintf('_%dE',mult(2))};
                        jlens=[Ptfm.LMB.L(nSec+1,iC) Ptfm.LMB.L(nSec+2,iC), Ptfm.LMB.L(nSec+3:end-1,iC)' CAN1nL ODIDn Ptfm.iCol.D(iCn)*.5];
                        TLS=[.5*Ptfm.LMB.L(nSec+1,iC) .5*Ptfm.LMB.L(nSec+2,iC), Ptfm.LMB.L(nSec+3:end-1,iC)' CAN1nL ODIDn Ptfm.iCol.D(iCn)*.5];
                        ConnectA=sprintf('LMB%d%d',iC,iCn);
                        ConnectB=sprintf('Col%d %s',iCn,lname(1));
                    end              
                end 
            else
                linename='Lower Main Beam';
                js={''};    
                jlens=sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2) );                
                ConnectA=vname;
                ConnectB=vname; 
                TLS=jlens; % 1 segment for simplicity
            end
            ibuild=true;
        elseif strcmp(lname(1:2),'VB')
            %VB number definition
            vnum=mod(lnum+1,nVB)+1;
            
            iCol=mod(floor(lnum/nVB),nCol)+1;% column that the v-brace emanates from
               % iCol=iC*(vnum==1)+iCn*(vnum==nVB); 
            if isfield(Ptfm.VBr,'id1')
                if mod(vnum,2) %odd numbered vnums   
                    id=-Ptfm.VBr.id1(iC);
                else
                    id=-Ptfm.VBr.id2(iC);
                end
            else
                id= atan2( Ptfm.UMB.dL - (Ptfm.Col.H-Ptfm.LMB.dL), Ptfm.Col.L/2-Ptfm.VBr.dL); % declination angle from UMB of the angle of the v-brace (<0)
            end
            if ~iRigid
                linename='VBr'; % base of name used in building Orca model
                %TLS=1; %[m]
                [nSec,~]=size(Ptfm.VBr.t);
                js{1}=sprintf('_%dE',mult(2));
                for ss=1:nSec
                    js{ss+1}=sprintf('_%dmm',round(1000*Ptfm.VBr.t(ss,iCol)) );%
                end  
                js{nSec+2}=sprintf('_%dE',mult(2));
                IDL=.5*Ptfm.iCol.D(iCol)/cos(-id);
                if IDL==0
                   IDL=.5*Ptfm.Col.D(iCol)/cos(-id); % do something different to the outer shell
                end
                LMBL=.5*Ptfm.LMB.D(iCol)/sin(-id);
                if isfield(Ptfm.VBr,'L')
                    jlens=[IDL Ptfm.VBr.L(:,iCol)' LMBL];
                    TLS=[IDL Ptfm.VBr.L(1,iCol) .2*Ptfm.VBr.L(2:end-1,iCol)' Ptfm.VBr.L(end,iCol) LMBL];
                else
                    jlens=[IDL jlensT-IDL-LMBL LMBL];
                    TLS=[IDL (jlensT-IDL-LMBL)*.25 LMBL];
                end
                if OFver>9
                    if mod(vnum,2) %odd numbered vnums
                        TROrient.az.A=mod(WFangles(iC)*180/pi,360); %[deg]
                        TROrient.dec.A=(pi/2+id)*180/pi;
                        TROrient.gam.A=0;
                        TROrient.az.B=180;
                        TROrient.dec.B=-id*180/pi;
                        TROrient.gam.B=180;
                    else
                        TROrient.az.A=mod(180+WFangles(iC)*180/pi,360); %[deg] who knows why!??!
                        TROrient.dec.A=(pi/2+id)*180/pi;
                        TROrient.gam.A=180;
                        TROrient.az.B=180;
                        TROrient.dec.B=180+id*180/pi;
                        TROrient.gam.B=180;
                    end          
                else
                    if mod(vnum,2) %odd numbered vnums
                        TROrient.az=mod(WFangles(iC)*180/pi,360);
                    else
                        TROrient.az=mod(180+WFangles(iC)*180/pi,360);
                    end
                    TROrient.dec=-id*180/pi+90;
                    TROrient.gam=0;
                end
                %TROrient.gam=0; %[deg] who knows why!??!
                if OFver>9
                    ConnectA=colname{iCol};%sprintf('Col%d %s',iCol,'U');
                    ConnectB=sprintf('LMB%da',iC);%sprintf('LMB%d%d',iC,iCn);
                else
                    ConnectA=sprintf('Col%d %s',iCol,'U');
                    ConnectB=sprintf('LMB%d%d',iC,iCn);                    
                end
            
            else
                linename='V-Brace'; % base of name used in building Orca model
                js={''};    
                jlens=sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2) );                
                ConnectA=vname;
                ConnectB=vname; 
                TLS=jlens; % 1 segment for simplicity
                %build the LMB for the rigid model and connect it to the vessel
            end
            ibuild=true;
        else
            disp(['Could not make line: ' lname])
            ibuild=false;
        end
        %%%%%%%%%-------- END LINE SPECIFICATIONS ------- %%%%%%%%%
        if ibuild
            %% Set the line properties
            AXr=getRelX(Model,ConnectA,TRpts(iendA,:));
            BXr=getRelX(Model,ConnectB,TRpts(iendB,:));
            ltol=1e-3;
            if sum(jlens)>sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2) )+ltol || sum(jlens)<sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2) )-ltol 
                warning('sum of sections in %s: %2.4f, while total line length is: %2.4f',linename,sum(jlens),sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2)) )
            end
            for jj=1:length(js)
                TRStruct(jj).LineType=[linename js{jj}];
                TRStruct(jj).Length=jlens(jj);
                TRStruct(jj).TargetSegmentLength=TLS(jj); %[m]
            end

            %% ACTUALLY BUILD THE LINE
            myTruss=buildOrcaLine(Model,lname,ConnectA,ConnectB,AXr,BXr,TROrient,TRStiff,TRStruct);
            %% MODIFY THE LINE (if necessary)     
            myTruss.DrawNodesAsDiscs='Yes';
            clear TRStruct js
        end
    end
end

function myLine=buildOrcaLine(Model,lname,ConnectA,ConnectB,AX,BX,Orient,Stiff,Struct)
    try
        myLine=Model(lname);
        disp(['Modified ' lname])
    catch
        myLine = Model.CreateObject(ofx.otLine, lname);
        disp(['Built ' lname])
    end
    %% Connection:
    myLine.EndAConnection=ConnectA; % connect object and then set relative position
    myLine.EndBConnection=ConnectB;
    try
        myLine.EndAX=AX(1); myLine.EndAY=AX(2); 
    catch
        eA=myLine.EndAConnectionzRelativeTo;
        disp(['Line ' lname 'has End A z relative to ' eA])
    end
    myLine.EndAZ=AX(3); 
    try
        myLine.EndBX=BX(1); myLine.EndBY=BX(2); 
    catch
        eB=myLine.EndBConnectionzRelativeTo;
        disp(['Line ' lname 'has End B z relative to ' eB])
    end
    myLine.EndBZ=BX(3);
    if isfield(Orient.az,'A')
        myLine.EndAAzimuth=Orient.az.A; myLine.EndBAzimuth=Orient.az.B;
    else
        myLine.EndAAzimuth=Orient.az; myLine.EndBAzimuth=Orient.az;
    end
    if isfield(Orient.dec,'A')
        myLine.EndADeclination=Orient.dec.A; myLine.EndBDeclination=Orient.dec.B;
    else
        myLine.EndADeclination=Orient.dec; myLine.EndBDeclination=Orient.dec;
    end
    if isfield(Orient.gam,'A')
        myLine.EndAGamma=Orient.gam.A; myLine.EndBGamma=Orient.gam.B;
    else
        myLine.EndAGamma=Orient.gam; myLine.EndBGamma=Orient.gam;
    end
    % Connection Stiffness:
    if isfield(Stiff,'AX') && ~strcmp(ConnectA,'Free')
        myLine.EndAxBendingStiffness=Stiff.AX;
    end
    if isfield(Stiff,'AY') && ~strcmp(ConnectA,'Free')
        myLine.EndAyBendingStiffness=Stiff.AY;
    end
    if isfield(Stiff,'BX') && ~strcmp(ConnectB,'Free')
        myLine.EndBxBendingStiffness=Stiff.BX;
    end
    if isfield(Stiff,'BY') && ~strcmp(ConnectB,'Free')
        myLine.EndByBendingStiffness=Stiff.BY;
    end
    if isfield(Stiff,'LayAz')
        try
            myLine.LayAzimuth=Stiff.LayAz;
        catch
            myLine.IncludeSeabedFrictionInStatics='No';
            %disp(['IncludeSeabedFrictionInStatics = No, for line: ' lname])
        end
    else
        myLine.IncludeSeabedFrictionInStatics='No';
        %disp(['IncludeSeabedFrictionInStatics = No, for line: ' lname])
    end
    if isfield(Stiff,'EndATwistingStiffness') || isfield(Stiff,'EndBTwistingStiffness')
         myLine.IncludeTorsion='Yes';
    end    
    if isfield(Stiff,'EndATwistingStiffness') && ~strcmp(ConnectA,'Free')
        try
            myLine.EndATwistingStiffness=Stiff.EndATwistingStiffness;
        catch
            myLine.IncludeTorsion='Yes';
            myLine.EndATwistingStiffness=Stiff.EndATwistingStiffness;
        end
    end
    if isfield(Stiff,'EndBTwistingStiffness') && ~strcmp(ConnectB,'Free')
        myLine.EndBTwistingStiffness=Stiff.EndBTwistingStiffness;  
    end
    %% Structure
    nSect=length(Struct);
    myLine.NumberOfSections=nSect;
    for jj=1:nSect
        myLine.Length(jj)=Struct(jj).Length;
        myLine.LineType(jj)=Struct(jj).LineType;
        if isfield(Struct,'NumberOfSegments')
            myLine.NumberOfSegments(jj)=Struct(jj).NumberOfSegments;
        elseif isfield(Struct,'TargetSegmentLength')
            myLine.TargetSegmentLength(jj)=Struct(jj).TargetSegmentLength;
        end
    end
end

%             bb=0;
%             while ~strcmp(CB,'Free')
%                 myColA=Model(CB); 
%                 bb=bb+1;
%                 CBs{bb}=CB; %build list of relative 
%                 CB=myColA.EndAConnection;
%             end
%             if bb>0
%                 if strcmp(myColA.typeName,'6D Buoy')
%                     Xabs(1)= myColA.InitialX ; Xabs(2)= myColA.InitialY ; Xabs(3)= myColA.InitialZ ;
%                 elseif strcmp(myColA.typeName,'Line')
%                     Xabs(1)= myColA.EndAX ; Xabs(2)= myColA.EndAY ; Xabs(3)= myColA.EndAZ ; %always work relative line End A
%                 end
%                 BXr=[0 0 sqrt( sum( (BX-Xabs).^2 )) ];
%             else
%                 BXr=BX;
%             end
%             
%             % get absolute position
%             for ib=bb-1:-1:1
%                 myColA=Model(CBs{ib});
%                 if strcmp(myColA.typeName,'6D Buoy')
%                     Xr(1)= myColA.InitialX ; Xr(2)= myColA.InitialY ; Xr(3)= myColA.InitialZ ;
%                 elseif strcmp(myColA.typeName,'Line')
%                     Xr(1)= myColA.EndAX ; Xr(2)= myColA.EndAY ; Xr(3)= myColA.EndAZ ; %always work relative line End A
%                 end
%                 Xabs=Xabs-Xr;
%                 BXr=[0 0 sqrt( sum( (BX-Xabs).^2 )) ];
%             end
%                 XB(1)= myColA.EndBX ; XB(2)= myColA.EndBY ; XB(3)= myColA.EndBZ ;
%                 kL=sqrt(  sum( (XB-XA).^2) ); 
%                 evec=(XB-XA)./kL;
%             else
%                 Xabs(1)= myColA.InitialX ; Xabs(2)= myColA.InitialY ; Xabs(3)= myColA.InitialZ ;
%             end
%             AXr=ColA+Xabs;
            
%             if ~strcmp(ConnectB,'Free')
%                 myColB=Model(ConnectB); 
%                 if strcmp(myColB.typeName,'6D Buoy')
%                     ColB(1)= myColB.InitialX ; ColB(2)= myColB.InitialY ; ColB(3)= myColB.InitialZ ;
%                 elseif strcmp(myColB.typeName,'Line')
%                     iB=false;
%                     ColB(1)= myColB.EndAX ; ColB(2)= myColB.EndAY ; ColB(3)= myColB.EndAZ ; %always work relative line End A
%                 end
%             else
%                 
%             end
            %TRpts(iendA,:)
            %-ColA;
            %-ColB;
%             if iA 
%                 
%             else
%                 TRpts(iendA,:)
%                 ColA
%                 AX=[0 0 sqrt( sum( (TRpts(iendA,:)-ColA).^2 )) ];
%             end
%             if iB
%                 BX=TRpts(iendB,:)-ColB;
%             else
%                 BX=[0 0 sqrt( sum( (TRpts(iendB,:)-ColB).^2 )) ];
%             end
    %         mylength=sqrt(  sum( (TRpts(iendA,:)-TRpts(iendB,:)).^2) ); %exactly the distance between the 2 nodes
    %         if canL==0
    %             jlens=mylength;
    %         else
    %             jlens=[canL mylength-sum(canL)-sum(canLn) canLn];
    %         end
        