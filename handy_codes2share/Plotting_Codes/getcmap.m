function map=getcmap(n,colorstr)
%colorstr={'dgreen','green','yellow','red','dred'};

%colorstr={'dgreen','green','yellow','orange'};
ncolors=length(colorstr);
dblue=[0,33,106]; %dark blue
blue=[0,50,250];
lblue=[9,215,216];
dgreen=[0,102,0];
green=[28,250,106];
lgreen=[51, 255,51];
red=[250,52,0];
dred=[135,0,0];
mag=[182,0,185];
pink=[255,153,204];
yellow=[255,255,0];
orange=[255, 128, 0];
white=[255,255,255];
brown = [165,42,42];
lpurple= [204,204,255];
purple=[153,51,255];
dpurple=[102,0,102];
beige=[255,229,204];
colors=zeros(ncolors,3);
for ii=1:ncolors
    eval(['colors(ii,:)=' colorstr{ii} ';'])
end
map=interp1(1:ncolors,colors,linspace(1,ncolors,n))./255;
end