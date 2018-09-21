function[HspData] = Smpl_byVal(M, col, val, tolerance)

%Sample input matrix by data of one column for given values

%Input:
%M         - input (stress) matrix 
%col       - Column no. of the data the sampling based on
%val       - sampling values, is a vector
%tolerance - tolerance of how far the sampled data from specified value

n = 1;
for i = 1:length(val)
    ind = find(abs(M(:,col)- val(i))<tolerance);
    m = length(ind);
    HspData1(n:n+m-1,:) = M(ind,:);
    n = n+m;
end
HspData = sortrows(HspData1,col);
end