function[] = genSAPinput()

[WFpts,WFlabels]=getWFpts({'COL','UMB','LMB','VB','VB'},[1 1 2 1 1],'WFM',[0 0 0],0);
%WFupts=unique(WFpts);   
jj=1;
for ii=1:length(WFpts)
    joint = WFpts(ii,:);
    if ii==1
        WFupts(jj,:)=joint;
		ind(ii,1) = jj;
    else
		dist = sum( (repmat(joint,[jj,1])-WFupts(1:jj,:)).^2,2);
		[d_min, n_min] = min(dist);
        if d_min>1e-1
			jj=jj+1;
            WFupts(jj,:)=joint;
			ind(ii,1) = jj;        
		else
			ind(ii,1) = n_min;
        end
    end
end

Nframe = length(WFlabels)/2;
JntNo=[1:size(WFupts,1)]';
for n=1:Nframe
	FrmNo(n,1)=n;
	FrmI(n,1)=JntNo(ind(2*n-1));
	FrmJ(n,1)=JntNo(ind(2*n));
end
end