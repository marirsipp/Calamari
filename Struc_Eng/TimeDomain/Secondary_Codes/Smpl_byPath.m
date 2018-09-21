function[HspData] = Smpl_byPath(M,path,col1,col2,int)

%Sample input matrix by following a certain path/trajectory(usually on a plane) for a
%given interval
%Input:
%M         - input (stress) matrix 
%path      - coordinates of each point on the path
%col1      - Column no. of the 1st axis of the input coordinate of points
%col2      - Column no. of the 2nd axis of the input coordinate of points
%int       - sampling one of every interval number of nodes

Nseg = size(path,1); %Total number of segment
tolerance = 1;
HspData = [];
%Divide the data into segment
for n = 1:Nseg
    SegName = ['seg' num2str(n)];
    if n ~= Nseg
        if path(n,1) == path(n+1,1)
            datasort.(SegName) = Smpl_byVal(M, col1, path(n,1), tolerance);
            data1 = Smpl_byIntrvl(datasort.(SegName), col2, int);
        elseif path(n,2) == path(n+1,2)
            datasort.(SegName) = Smpl_byVal(M, col2, path(n,2), tolerance);
            data1 = Smpl_byIntrvl(datasort.(SegName), col1, int);
        end
    elseif Nseg ~= 2
        if path(n,1) == path(1,1)
            datasort.(SegName) = Smpl_byVal(M, col1, path(n,1), tolerance);
            data1 = Smpl_byIntrvl(datasort.(SegName), col2, int);
        elseif path(n,2) == path(1,2)
            datasort.(SegName) = Smpl_byVal(M, col2, path(n,2), tolerance);
            data1 = Smpl_byIntrvl(datasort.(SegName), col1, int);
        end
    else
        data1 = [];
    end
    HspData=[HspData;data1];
end
 
end