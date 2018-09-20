function B = Rotate2DMat(A, C)

% Rotates an n x 3  matrix A by C radians in Yaw and returns rotated 3 x n
% matrix B. The 3rd dimension is unchanged.
% Written by Alan Lum of Marine Innovation & Technology

if length(C) == 1
    B(:,1) = A(:,1) * cos(C) - A(:,2) * sin(C);
    B(:,2) = A(:,1) * sin(C) + A(:,2) * cos(C);
    if size(A,2) == 3
        B(:,3) = A(:,3);
    end
elseif length(C) == size(A,1)
    for i = 1:length(C)
        B(i,1) = A(i,1) * cos(C(i)) - A(i,2) * sin(C(i));
        B(i,2) = A(i,1) * sin(C(i)) + A(i,2) * cos(C(i));
        B(i,3) = A(i,3);
    end
else
    error('Size mismatch, input C must be a scalar or array with the same length as A')
end