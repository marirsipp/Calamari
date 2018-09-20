function allobjX=getObjX(Model,allobj)
Env=Model.environment;
Depth=Env.WaterDepth;
%recursively find absolute locations of all objects in the model
nobj=length(allobj);
allobjX=cell(nobj,4); % name [XA YA ZA] [XB YB ZB] [evec]
allobjX(:,1)=allobj;
while sum(sum(cellfun(@isempty,allobjX)))
    %find remaining 
    irem=logical(sum(cellfun(@isempty,allobjX),2));
    nrem=sum(irem);
    rnames=allobjX(irem,1);
    for ii=1:nrem
        
        myobj=Model(rnames{ii});
        if strcmp(myobj.typeName,'Line') 
            CA=myobj.EndAConnection;
            CB=myobj.EndBConnection;
        elseif strcmp(myobj.typeName,'6D Buoy') || strcmp(myobj.typeName,'3D Buoy')
            CA=myobj.Connection; 
            CB=myobj.Connection;
        elseif strcmp(myobj.typeName,'Vessel') 
            CA='Free';
            CB='Free';
        end
        if ~strcmp(CA,'Free') &&  ~strcmp(CA,'Anchored')
            CAobj=Model(CA);
        end
        if ~strcmp(CB,'Free') && ~strcmp(CB,'Anchored') 
            CBobj=Model(CB);
        end
        [AX,BX]=getX(myobj);
        iC  = find(cellfun(@(s) ~isempty(strfind(rnames{ii}, s)), allobj));
        iCA = find(cellfun(@(s) ~isempty(strfind(CA, s)), allobj));
        iCB = find(cellfun(@(s) ~isempty(strfind(CB, s)), allobj));
        if strcmp(CA,'Free')  
            allobjX{iC,2}=AX;
        elseif strcmp(CA,'Anchored')  
            allobjX{iC,2}=[AX(1:2) Depth];
        elseif ~isempty(allobjX{iCA,4}) && strcmp(CAobj.typeName,'Line') 
            GA=allobjX{iCA,2};
            allobjX{iC,2}=GA+AX(3)*allobjX{iCA,4};
        elseif ~isempty(allobjX{iCA,4}) && strcmp(CAobj.typeName,'6D Buoy') 
            GA=allobjX{iCA,2};
            allobjX{iC,2}=GA+AX;   
        elseif ~isempty(allobjX{iCA,4}) && strcmp(CAobj.typeName,'Vessel')     
            GA=allobjX{iCA,2};
             allobjX{iC,2}=GA+AX;   
        else
            %don't do anything, wait until the connection is filled
        end
        if strcmp(CB,'Free') 
            allobjX{iC,3}=BX;    
        elseif strcmp(CB,'Anchored')  
            allobjX{iC,3}=[BX(1:2) Depth];    
        elseif ~isempty(allobjX{iCB,4}) && strcmp(CBobj.typeName,'Line') 
            GB=allobjX{iCB,2};
            allobjX{iC,3}=GB+BX(3)*allobjX{iCB,4};
        elseif ~isempty(allobjX{iCB,4}) && strcmp(CBobj.typeName,'6D Buoy') 
            GB=allobjX{iCB,2};
            allobjX{iC,3}=GB+BX;
        elseif ~isempty(allobjX{iCB,4}) && strcmp(CBobj.typeName,'Vessel') 
            GB=allobjX{iCB,2};
            allobjX{iC,3}=GB+BX;
        end
        % get the evec
        if ~isempty(allobjX{iC,2}) && ~isempty(allobjX{iC,3})
            eAX=allobjX{iC,2};
            eBX=allobjX{iC,3};
            elen= sqrt( sum( (eAX-eBX).^2));
            if elen>0
                allobjX{iC,4}= (eBX-eAX)/elen;
            else
                allobjX{iC,4}= [1 1 1];
            end
        end
    end
end
allobjX=allobjX(:,1:3); %clear evec
end


function [Xabs,Babs]=getX(myobj)
if strcmp(myobj.typeName,'6D Buoy')
    Xabs(1)= myobj.InitialX ; Xabs(2)= myobj.InitialY ; Xabs(3)= myobj.InitialZ ;
    Babs=Xabs;
    %AXr=AX-Xabs;
elseif strcmp(myobj.typeName,'Line')
    Xabs(1)= myobj.EndAX ; Xabs(2)= myobj.EndAY ; Xabs(3)= myobj.EndAZ ; %always work relative line End A
    Babs(1)= myobj.EndBX ; Babs(2)= myobj.EndBY ; Babs(3)= myobj.EndBZ ; 
    %AXr=[0 0 sqrt( sum( (AX-Xabs).^2 )) ]; %z is the axial direction
else
    Xabs=[0 0 0];
    Babs=[0 0 0];
end

end