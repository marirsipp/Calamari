function[HSpData] = Smpl_byIntrvl(M, col, interval)%Sample input matrix by one column for a given interval%Input:%M   - input (stress) matrix %col - Column no. of the data sampling based on%interval - sampling one of every interval number of nodesHSpNo = floor(size(M,1)/interval); %Total number of hot spots sampled M_sort = sortrows(M,col);for j = 1:HSpNo    k = (j-1) * interval + 1;    HSpData (j,:) = M_sort(k,:);endif k~=size(M_sort,1)    HSpData (HSpNo+1,:) = M_sort(end,:);endend