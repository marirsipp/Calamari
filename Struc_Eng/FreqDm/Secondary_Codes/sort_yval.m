function[data_sort] = sort_yval(data, ymin, ymax)
%Sort fatigue life results based on the element y value
%Input:
%data - 1st column, element number
%     - 2nd column, x value (mm) of element centroid
%     - 3rd column, y value (mm) of element centroid
%     - 4th column, z value (mm) of element centroid
%     - 5th column, fatigue life on element top surface (year)
%     - 6th column, fatigue life on element bottom surface (year)
%ymin - target minimum y value (mm)
%ymax - target maximum y value (mm)

ind = (data(:,3) >= ymin) & (data(:,3) <= ymax);
data_sort = data(ind,:);

% m = 1;
% ElemNo = size(data,1);
% 
% for n=1:ElemNo
%     if (data(n,3) >= ymin) && (data(n,3) <= ymax)
% 	   data_sort(m,:) = data(n,:);
% 	   m = m+1;
%     end
% end

end