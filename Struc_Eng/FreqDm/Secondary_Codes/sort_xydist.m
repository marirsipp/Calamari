function[data_sort] = sort_xydist (data,L1,L2,px,py)
%Sort fatigue life results based on the distance of the element conetroid
%to a certain point on the XY plane

%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%L1 - target minimum distance (mm)
%L2 - target maximum distance (mm)
%px - x value of the point (mm)
%py - y value of the point (mm)

L = sqrt( (data(:,2)-px).^2 + (data(:,3)-py).^2 );
ind =  (L >= L1) & (L <= L2);
data_sort = data(ind,:);

% m = 1;
% ElemNo = size(data,1);
% 
% for n=1:ElemNo
%     L = sqrt( (data(n,2)-px)^2 + (data(n,3)-py)^2 );
%     if (L >= L1) && (L <= L2)
% 	   data_sort(m,:) = data(n,:);
% 	   m = m+1;
%     end
% end

end