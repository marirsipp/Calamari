function [WEPpts, WEPlabels,KBpts,KBlabels]=getMyWEP(WEPtype,Ptfm,OrcaOrigin)

KBpts=[];
KBlabels=[];
iu=1;
if Ptfm.Col.Draft>0
    iu=-1;
end

if isfield(Ptfm,WEPtype)
    WEP=Ptfm.(WEPtype);

    nT=size(WEP.Pts,1);
    nP=nT/3;
    if ceil(mod(nP,1))
        error('You WEPs have a different amount of points')
    end
    WEPpts=nan(2*3*(nP-1),3);
    WEPlabels=cell(2*3*(nP-1),1);
    % remove the blank strings from the list
    kk=1:nT;
    kj=kk(~ismember(kk,[0:2]*nP+1));
    ii=0;
    for kk=kj
        ii=ii+1;
        labelk=['WEP' WEP.Pts{kk,1}];
        xA=WEP.Pts{kk-1,2};
        yA=WEP.Pts{kk-1,3};
        zA=iu*Ptfm.Col.Draft;
        
        xB=WEP.Pts{kk,2};
        yB=WEP.Pts{kk,3};
        zB=iu*Ptfm.Col.Draft;
        %% Labels
        WEPlabels{2*(ii-1)+1}=labelk;
        WEPlabels{2*ii}=labelk;
        %% Points
        WEPpts(2*(ii-1)+1,:)=[xA yA zA]+OrcaOrigin;
        WEPpts(2*ii,:)=[xB yB zB]+OrcaOrigin;
        
    end
    %sort WEP names
    %[WEPlabels,ia]=sort(WEPlabels); % don't sort!!
    %WEPpts=WEPpts(ia,:);
    for jj=2:2:length(WEPpts)
        WEPlabels{jj}='';
    end
else
    error('define your WEP geometry in the Ptfm Excel!')
end
end