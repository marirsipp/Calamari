function [MassMat,COG,xclsheet]=getOFMass(datfile,PtfmName)
Model=ofxModel(datfile);
mod_all = Model.objects;
% mod_lines = mod_all(cellfun(@(obj) isa(obj,'ofxLineObject'), mod_all));
% linetypes = mod_all(cellfun(@(obj) isa(obj,'ofxWizardObject'), mod_all));
xclnames={'Col1','Col2','Col3','Truss', 'WEP', 'Tower', 'RNA','Equipment','Piping','Corrosion','Secondary','Ballast'}; %
xclrow=zeros(1,length(xclnames));
xclmat=zeros(20,length(xclnames),4);

allnames = cellfun( @(obj) obj.typeName, mod_all, 'uni', false); 

alltypes={ 'Vessel', '6D Buoy','Line','Link','Line Type'};
objmat=zeros(length(allnames),length(alltypes));
for kk=1:length(alltypes)
    objmat(:,kk)=strcmp(allnames,alltypes{kk});
end
%
% just get all massive objects: vessel, buoys, lines, 
mod_obj=mod_all(logical(sum(objmat(:,1:end-2),2)));
massmat=nan(length(mod_obj),4); %array for each object, 
massnames={};
Xabs=nan(length(mod_obj),3);
Babs=nan(length(mod_obj),3);

% assume no vessel, look for free 6dbuoys
objconnect = cellfun( @(obj) obj.Connection, mod_obj, 'uni', false);
objnames=cellfun( @(obj) obj.Name, mod_obj, 'uni', false);
objtypes= cellfun( @(obj) obj.typeName, mod_obj, 'uni', false); 
%% Find Absolute Locations of all objects!
%allobjX=getObjX(Model,objnames) ; % {names,[AX],[BX]} 
%% FREE 6D Buoys
ifree=find(strcmp(objconnect,'Free') &  strcmp(objtypes, '6D Buoy'));

freeobj=mod_obj(ifree);
for kk=1:length(freeobj)
    bname=freeobj{kk}.Name;
    bmass=freeobj{kk}.Mass;
    massmat(ifree(kk),1)=bmass;
    massnames{ifree(kk)}=bname;
    bX=[freeobj{kk}.InitialX freeobj{kk}.InitialY freeobj{kk}.InitialZ];
    Xabs(ifree(kk),:)=bX;
    bCOG=bX+[freeobj{kk}.CentreOfMassX freeobj{kk}.CentreOfMassY freeobj{kk}.CentreOfMassZ];
    massmat(ifree(kk),2:4)=bCOG;
    %fill in excel matrix
    ixcl=find(cellfun(@(s) ~isempty(strfind(bname, s)), xclnames));
    xclrow(ixcl)=xclrow(ixcl)+1;
    xclmat(xclrow(ixcl),ixcl,1)=bmass;
    xclmat(xclrow(ixcl),ixcl,2:4)=permute(bCOG,[3 1 2]);
end

%% LINES
ilines = find( strcmp(objtypes, 'Line'));
lineobj=mod_obj(ilines);
icl=0;
for kk=1:length(lineobj)
    kLine=lineobj{kk};
    %get connection positions
    kName=kLine.Name;
    if ~strcmp(kName(1:2),'ML') && ~strcmp(kName(1:3),'Bla') % don't measure the mass of the mooring lines (if they exist) since a lot of their weight is on the ground

        iC  = find(cellfun(@(s) ~isempty(strfind(kName, s)), objnames));
        %BX=allobjX{iC,3};
        %AX=allobjX{iC,2};
        [AX,BX,RAX,RBX]= getAbsXinOF(Model,kName);
        kL=sqrt(  sum( (BX-AX).^2) ); 
        evec=(BX-AX)./kL;
        nSec=kLine.NumberOfSections;
        jM=nan(nSec,4);
        %jCOG=nan(nSec,3);
        jX=AX;
        for jj=1:nSec     
            %remLen=sqrt(  sum( (BX-jX).^2) ); 
            jLTn=kLine.LineType(jj);
            jLT=Model(jLTn);
            jL=kLine.Length(jj);
            jMPUL=jLT.MassPerUnitLength;
            jM(jj,1)=jMPUL*jL;
            % assume that the line is straight (rigid) between two endpoints
            jXn=jX+ jL.*evec;
            jM(jj,2:4)=mean([jX ;jXn],1);
            jX=jXn;
        end
        
        % Record data in excel sheet
        ixcl=find(strcmpi(kName,xclnames));
        if isempty(ixcl)
            if strncmp(kName, 'UMB',3) || strncmp(kName, 'LMB',3) || strncmp(kName, 'VB',2)
                ixcl=find(strcmpi('Truss',xclnames));
            elseif strncmpi(kName, 'WEP',3) || strncmpi(kName, 'Web',3)
                ixcl=find(strcmpi('WEP',xclnames));
            else
                error(['Cannot find line: ' kName ' in excel spreadsheet headers'])
            end
        end
        xclrow(ixcl)=xclrow(ixcl)+1;
        lmass=sum(jM(:,1));
        xclmat(xclrow(ixcl),ixcl,1)=lmass;
        if lmass<1e-3
            lCOG=mean(jM(:,2:4),1);
        else
            lCOG=sum(jM(:,2:4).*repmat(jM(:,1),[1 3]),1)/lmass;
        end
            
        xclmat(xclrow(ixcl),ixcl,2:4)=permute(lCOG,[3 1 2]);
        %% Attachements!
        NoA=kLine.NumberOfAttachments; 

        jA=zeros(NoA,4);        
        for ii=1:NoA

            iAT=kLine.AttachmentType(ii);
            iZ=kLine.Attachmentz(ii);
            iATobj=Model(iAT);
            % find if the clumpweight belongs in another group
            iATd=min([strfind(iAT,'-') strfind(iAT,' ')]);
            ATxcl=iAT(1:iATd-1);
            colNstr=iAT(iATd+1:end);
            ixcl=find(strcmpi(ATxcl,xclnames));
            if isempty(ixcl)
                if strcmp(ATxcl,'AB') || strcmp(ATxcl,'PB')
                    ixcl=find(strcmpi('Ballast',xclnames)); 
                elseif strncmp(iAT,'WEP',3)
                    ixcl=find(strcmpi('WEP',xclnames)); 
                elseif strcmp(ATxcl,'Misc')
                    ixcl=find(strcmpi(colNstr,xclnames));
                else
                    warning(['Cannot find clumpweight ' ATxcl ' in excel spreadsheet headers. Putting into tower'])
                     ixcl=find(strcmpi('Tower',xclnames));
                    %
                end
            end
             
            xclrow(ixcl)=xclrow(ixcl)+1;
            xclmat(xclrow(ixcl),ixcl,1)=iATobj.Mass;
            aCOG=AX+iZ*evec;
            xclmat(xclrow(ixcl),ixcl,2:4)=permute(aCOG,[3 1 2]);
            jA(ii,:)=[iATobj.Mass aCOG];   
        end
        %% add in the attachments, if appropriate
        massmat(ilines(kk),1)=sum(jM(:,1))+sum(jA(:,1));
        massnames{ilines(kk)}=kLine.Name;
        massmat(ilines(kk),2:4)= (sum(jM(:,2:4).*repmat(jM(:,1),[1 3]),1) +sum(jA(:,2:4).*repmat(jA(:,1),[1 3]),1))/massmat(ilines(kk),1);
        Xabs(ilines(kk),:)=AX; % just keep track of AX of lines, since all buoys are connected relative to End A
        Babs(ilines(kk),:)=BX;
    end
end

%% Connected 6D Buoys
ifix=find(~strcmp(objconnect,'Free')& ~strcmp(objconnect,'Fixed') &  strcmp(objtypes, '6D Buoy'));
fixobj=mod_obj(ifix);
for kk=1:length(ifix)
    kBuoy=fixobj{kk};
    kBname=kBuoy.Name;

    iC  = find(cellfun(@(s) ~isempty(strfind(kBname, s)), objnames));
    %AX=allobjX{iC,2}; %identical to third
    [AX,BX,RAX,RBX]= getAbsXinOF(Model,kBname);
    Xabs(ifix(kk),:)=AX;
    
    %% find if buoys should go into excel sheet
    iBd=min([strfind(kBname,'-') strfind(kBname,' ')]);
    xBname=kBname(1:iBd-1);
    ixcl=find(strcmpi(xBname,xclnames));
    xclrow(ixcl)=xclrow(ixcl)+1;
    xclmat(xclrow(ixcl),ixcl,1)=kBuoy.Mass;
    kBCOG=AX+[kBuoy.CentreOfMassX kBuoy.CentreOfMassY kBuoy.CentreOfMassZ];
    xclmat(xclrow(ixcl),ixcl,2:4)=permute(kBCOG,[3 1 2]);
    
    massmat(ifix(kk),1)=kBuoy.Mass;
    massnames{ifix(kk)}=kBuoy.Name;
    massmat(ifix(kk),2:4)=kBCOG;
end
inan = isnan(massmat(:,1));
M=nansum(massmat(:,1));
COG=nansum(massmat(:,2:4).*repmat(massmat(:,1),[1 3]),1)./M;
%% Inertia
allMass = massmat(inan,:);
nMass = sum(inan);
MOI = zeros(1,3);
for ii=1:nMass
    % Global inertia
    MOI(1,1) = MOI(1,1) + allMass(ii,1)*(allMass(ii,3)^2 + allMass(ii,4)^2); % [kg-m^2]
    MOI(1,2) = MOI(1,2) + allMass(ii,1)*(allMass(ii,2)^2 + allMass(ii,4)^2); % [kg-m^2]
    MOI(1,3) = MOI(1,3) + allMass(ii,1)*(allMass(ii,2)^2 + allMass(ii,3)^2); % [kg-m^2]
end
RadGyr = sqrt(MOI./M); % [m]
%% Mass Matrix
MassMat = zeros(6,6);
MassMat(1:3,1:3) = M*eye(3);
MassMat(4:6,4:6) = diag(MOI);
OffMat =M*[ 0 COG(3) -COG(2); -COG(3) 0 COG(1); COG(2) -COG(1) 0];
MassMat(1:3,4:6) = OffMat;
MassMat(4:6,1:3) = -OffMat;

MassMat(4,5) = -M * COG(1)*COG(2); MassMat(5,4) = -M * COG(1)*COG(2); 
MassMat(4,6) = -M * COG(1)*COG(3); MassMat(6,4) = -M * COG(1)*COG(3);
MassMat(5,6) = -M * COG(2)*COG(3); MassMat(6,5) = -M * COG(2)*COG(3);
%% Excel Mass Spreadsheet
Ptfm=getMyPtfm(PtfmName);
XclOrigin=[Ptfm.Col.Lh*2/3,0,0];
xclCOG=nan(length(xclnames),3);
xclmass=squeeze(sum( xclmat(:,:,1),1));
xclmass=xclmass'; %make it a column
for ii=1:length(xclnames)
    xclCOG(ii,:)=sum(squeeze(xclmat(:,ii,2:4)).*repmat(squeeze(xclmat(:,ii,1)),[1 3]),1)./xclmass(ii);
end
xclsheet={xclnames' xclmass xclCOG+repmat(XclOrigin,[length(xclnames),1])};
M2=sum(xclmass);
COG2=sum(xclCOG.*repmat(xclmass,[1 3]))/sum(xclmass);
% M2
% COG2+XclOrigin
% for kk=1:length(xclnames)
%     kxcl=xclnames{kk};
%     ik=strncmpi(objnames, kxcl,length(kxcl));
%     if strcmp(kxcl,'Truss')
%         ik1=strncmp(objnames, 'UMB',3);
%         ik2=strncmp(objnames, 'LMB',3);
%         ik3=strncmp(objnames, 'VB',2);
%         ik4=strncmp(objnames,'Truss',5);
%         ik = ik1 | ik2 | ik3 | ik4;
%     elseif strcmp(kxcl,'AB')
%         ikn=strncmp(objnames, 'PB',2);
%         ik=ik | ikn;
%     end
%     xclmat(kk,1)=sum(massmat(ik,1));
%     xclmat(kk,2:4)= nansum(massmat(ik,2:4).*repmat(massmat(ik,1),[1 3]),1)./ sum(massmat(ik,1));
% end
% xclmat(:,1)
% sum(xclmat(:,1))
% xclmat(:,2:4)+repmat(XclOrigin,[length(xclnames) 1])
end