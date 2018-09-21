function[ObjJnt, ElemJnt] = JointDiff(JntNo,JntRst)
%Differentiate frame joints and element joints (e.g. joint number: ~122)

ind = regexp(JntNo,'~'); %Differentiate frame joint and element joint
NJnt2 = sum(cell2mat(ind)); %total number of element joints
NJnt1 = size(JntNo,1)-NJnt2; %total number of frame joints

for kk = 1:NJnt1
    ObjJntNo(kk,1) = str2double(JntNo{kk,1});
end
ObjJntRst = JntRst(1:NJnt1,:);
ObjJnt = sortrows([ObjJntNo,ObjJntRst],1);

for nn = 1:NJnt2
    ElemJntNo(nn,1) = str2double(JntNo{NJnt1+nn,1}(2:end)); 
end
ElemJntRst = JntRst(NJnt1+1:end,:);
ElemJnt = sortrows([ElemJntNo+1e5,ElemJntRst],1);
end