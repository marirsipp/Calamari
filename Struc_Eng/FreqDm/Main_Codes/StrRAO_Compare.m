clc
clear all

%Compare connection Stress RAOs
path0 = 'C:\Users\Ansys\Documents\MATLAB\FreqDomain\';
theta0 = 340;

GroupName = 'Truss_CG1';
TorB = 'Top';
HeadNo = 3; %Column no. of wave heading to compare

%Iterations to compare
Itr1 = 'Itr13_10';
Itr2 = 'Itr13_10_NoTwr';

Itr1_text = 'Itr13\_10';
Itr2_text = 'Itr13\_10\_NoTwr';

%Load Group results
path1 = [path0 Itr1 '\Results\' GroupName '\'];
PartResultFile1 = [path1 'ElemResult.mat' ]; 
Result1 = load(PartResultFile1);
NoElem = size(Result1.ElemRst,2);

path2 = [path0 Itr2 '\Results\' GroupName '\'];
PartResultFile2 = [path2 'ElemResult.mat' ]; 
Result2 = load(PartResultFile2);

%Simulated wave headings
a = Result1.ElemRst{1}.Heading(:,HeadNo);
b = theta0-a;
TextHeading = ['Heading ' num2str(b)];

%%
%Plot stress RAO per connection per heading
path_compare = [path2 'StrRAO\Compare\'];

for n = 1:NoElem
    RAO(1,:) = Result1.ElemRst{n}.StrRAO(:,:,HeadNo);
    RAO(2,:) = Result2.ElemRst{n}.StrRAO(:,:,HeadNo);
    
    figure(1)
    plot(Result1.ElemRst{n}.Period,RAO(1:2,:),'-o')
    legend( Itr1_text, Itr2_text )
    xlabel('Wave period (s)')
    ylabel('Principle stress (MPa)')
    title( [Result1.ElemRst{n}.CnntName ' ' TextHeading])
    FigureFile1 = [path_compare Result1.ElemRst{n}.CnntName '_' TextHeading '.fig'];
    hgsave(FigureFile1)    
end
