function[data_sort] = sort_zval(data, zmin, zmax)
%Sort fatigue life results based on the element z value
%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%ymin - target minimum y value (mm)
%ymax - target maximum y value (mm)

ind = (data(:,4) >= zmin) & (data(:,4) <= zmax);
data_sort = data(ind,:);

% m = 1;
% ElemNo = size(data,1);
% 
% for n=1:ElemNo
%     if (data(n,4) >= zmin) && (data(n,4) <= zmax)
% 	   data_sort(m,:) = data(n,:);
% 	   m = m+1;
%     end
% end

end