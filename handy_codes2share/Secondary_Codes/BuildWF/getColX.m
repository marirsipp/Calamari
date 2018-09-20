function ColX=getColX(Ptfm,X1)
% default is center of column 1 at [0,0,0], with column 2 in upper-left
% quadrant and column 3 in lower-left quadrant
% get the coordinates of the center of columns 
nCol=length(Ptfm.Col.D);
Xb=zeros(nCol,3);
ColX=zeros(nCol,3);

%Col1L=[Ptfm.Col.Lh*2/3,0,Ptfm.Col.Draft];
%Xb(1,:)=Rotate2DMat(Col1L,-Ptfm.Heading*pi/180); %current position of bottom pointer = Col1
Xb(1,:)=zeros(1,3);
WFangles=Ptfm.Col.Az; % equilateral triangle, should be related to Ptfm.Col.L 
if length(Ptfm.Col.L)==1
    Ptfm.Col.L=repmat(Ptfm.Col.L,[1 3]);
end
for iC=2:nCol
    % Get [X,Y] distance to next column
     newX=[Ptfm.Col.L(iC-1)*cos(WFangles(iC-1)),Ptfm.Col.L(iC-1)*sin(WFangles(iC-1)),0];
     % Advance cursors
     Xb(iC,:)=Xb(iC-1,:)+newX;
     % Set next column coordinates
     ColX(iC,:)=[Xb(iC,1:2) 0]; % at the waterline
end
ColX=Rotate2DMat(ColX,Ptfm.Heading);
ColX=ColX+repmat(Rotate2DMat(X1,Ptfm.Heading),[nCol 1]);
end