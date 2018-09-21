clc
clear all

%Compare connection Stress RAOs
path0 = 'C:\Users\Ansys\Documents\MATLAB\FreqDomain\';
theta0 = 340;
HeadNo = 4; %Column no. of wave heading to compare
TorB = 'Top'; %Top or bottom surface to compare
Method = 1;

%Iterations to compare
Itr1 = 'Itr13_5';
GroupName1 = 'Truss_CG1';
Itr1_text = 'Itr13\_5';

Itr2 = 'Itr13_7';
GroupName2 = 'BoxKJnt_CG1';
Itr2_text = 'Itr13\_7';

%Connection to compare
Connection = 'LMB23 Brkt';

%Load Group results
path1 = [path0 Itr1 '\Results\' GroupName1 '\'];
PartResultFile1 = [path1 'ElemResult_' TorB '_Method' num2str(Method) '.mat' ]; 
Result1 = load(PartResultFile1);
NoElem1 = size(Result1.ElemRst,2);

path2 = [path0 Itr2 '\Results\' GroupName2 '\'];
PartResultFile2 = [path2 'ElemResult_' TorB '_Method' num2str(Method) '.mat' ]; 
Result2 = load(PartResultFile2);
NoElem2 = size(Result2.ElemRst,2);

%Simulated wave headings
a = Result1.ElemRst{1}.Heading(:,HeadNo);
b = theta0-a;
TextHeading = ['Heading ' num2str(b)];

%%
%Plot stress RAO per connection per heading
path_compare = [path2 'StrRAO\Compare\'];

for n = 1:NoElem1
    if strcmp(Result1.ElemRst{n}.CnntName,Connection)
        CnntNo1 = n;
    end
end

for n = 1:NoElem2
    if strcmp(Result2.ElemRst{n}.CnntName,Connection)
        CnntNo2 = n;
    end
end

NoPeriod1 = length(Result1.ElemRst{CnntNo1}.StrRAO(:,:,HeadNo));
NoPeriod2 = length(Result2.ElemRst{CnntNo2}.StrRAO(:,:,HeadNo));
PDiff = NoPeriod1 - NoPeriod2;

RAO(1,1:NoPeriod1) = Result1.ElemRst{CnntNo1}.StrRAO(:,:,HeadNo);
RAO(2,PDiff+1:NoPeriod1) = Result2.ElemRst{CnntNo2}.StrRAO(:,:,HeadNo);

figure(1)
plot(Result1.ElemRst{n}.Period,RAO(1:2,:),'-o')
legend( Itr1_text, Itr2_text )
xlabel('Wave period (s)')
ylabel('Principle stress (MPa)')
title( [Result1.ElemRst{CnntNo1}.CnntName ' ' TextHeading])
FigureFile1 = [path_compare Result1.ElemRst{CnntNo1}.CnntName '_' TextHeading '_' TorB '.fig'];
hgsave(FigureFile1)    

