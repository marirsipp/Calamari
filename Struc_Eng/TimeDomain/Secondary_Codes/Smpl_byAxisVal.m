function[HspData] = Smpl_byAxisVal(M,col_c,col_r,int)
%Sample input matrix by data of one column 
%First sort by circumferential angle value, then sample along
%radial/vertical axis

%Input:
%M         - input (stress) matrix 
%col_c     - Column no. of the datar representing circ axis
%col_r     - Column no. of the datar representing radial/vertical axis
%int       - sampling one of every interval number of nodes

y = M(:,col_c);
y_unq = unique(y);
tolerance = 0.01;

HspData = [];
for n = 1:length(y_unq)
    data1 = Smpl_byVal(M, col_c, y_unq(n), tolerance);
    data2 = Smpl_byIntrvl(data1, col_r, int);
    HspData = [HspData;data2];
    clear data1 data2
end
end