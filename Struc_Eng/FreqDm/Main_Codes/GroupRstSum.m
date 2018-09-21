%Summarize and plot fatigue calculation results for each control group

%Go to the result path
cd(path_rst)
fnames=dir('*.csv');
Nrst = length(fnames);
Sum1{1,1} = 'Cnnt_Name';
Sum1{1,2} = 'Life_Top';
Sum1{1,3} = 'Loc_Top_X';
Sum1{1,4} = 'Loc_Top_Y';
Sum1{1,5} = 'Loc_Top_Z';
Sum1{1,6} = 'Life_Btm';
Sum1{1,7} = 'Loc_Btm_X';
Sum1{1,8} = 'Loc_Btm_Y';
Sum1{1,9} = 'Loc_Btm_Z';

for n=1:Nrst
	rstfile = fnames(n).name;
	result = importdata(rstfile);
	ind = regexp(rstfile,'.csv');
	PartName = rstfile(1:ind-1);
    PartName1 = regexprep(PartName,'_',' ');
	plot_TopBtm_FatigLife (result,'',PartName1,50)
	[Life_Top, Row_Top] = min(result(:,5));
	[Life_Btm, Row_Btm] = min(result(:,6));
	Sum1{n+1,1} = PartName;
	Sum1{n+1,2} = Life_Top;
	Sum1{n+1,3} = result(Row_Top,2);
    Sum1{n+1,4} = result(Row_Top,3);
    Sum1{n+1,5} = result(Row_Top,4);
	Sum1{n+1,6} = Life_Btm;
	Sum1{n+1,7} = result(Row_Btm,2);
    Sum1{n+1,8} = result(Row_Btm,3);
    Sum1{n+1,9} = result(Row_Btm,4);
end

OutFile = [Itr '_Summary.xls'];
xlswrite(OutFile,Sum1)

%%

cd(path_rst)
fnames=dir('*.csv');
Nrst = length(fnames);
Sum2{1,1} = 'Cnnt_Name';
Sum2{1,2} = 'SN_Curve';
Sum2{1,3} = 'Act_Thk';
Sum2{1,4} = 'Life_Top';
Sum2{1,5} = 'Elem_Top';
Sum2{1,6} = 'Row_Top';
Sum2{1,7} = 'Life_Btm';
Sum2{1,8} = 'Elem_Btm';
Sum2{1,9} = 'Row_Btm';

for n=1:Nrst
	rstfile = fnames(n).name;
	result = importdata(rstfile);
	ind = regexp(rstfile,'.csv');
	PartName = rstfile(1:ind-1);
    PartName1 = regexprep(PartName,'_',' ');
% 	plot_TopBtm_FatigLife (result,'',PartName1,50)
	[Life_Top, Row_Top] = min(result(:,5));
	[Life_Btm, Row_Btm] = min(result(:,6));
	Sum2{2,1} = PartName;
    Sum2{2,2} = CGinfo.(PartName).SN;
	Sum2{2,3} = CGinfo.(PartName).thk;
	Sum2{2,4} = Life_Top;
    Sum2{2,5} = result(Row_Top,1);
	Sum2{2,6} = Row_Top;
    Sum2{2,7} = Life_Btm;
	Sum2{2,8} = result(Row_Btm,1);
    Sum2{2,9} = Row_Btm;
    
    OutFile = [PartName '_Summary.xls'];
    xlswrite(OutFile,Sum2)
end

%% Element prescreening

cd(path_rst)
fnames=dir('*.csv');
Nrst = length(fnames);
for n=1:Nrst
	rstfile = fnames(n).name;
	result = importdata(rstfile);
	ind = regexp(rstfile,'.csv');
	PartName = rstfile(1:ind-1);
    if isfield( CGinfo.(PartName),'target')
        target = CGinfo.(PartName).target;
    else
        target = 250;
    end
	row_top = find(result(:,5)<target);
	rst_top = result(row_top,:);
	row_btm = find(result(:,6)<target);
	rst_btm = result(row_btm,:);
    
    if ~isempty(rst_top)
        Elem2run.(PartName).(PartName).Top.Life = rst_top(:,5);
        Elem2run.(PartName).(PartName).Top.Loc = rst_top(:,2:4);
        Elem2run.(PartName).(PartName).Top.Elem = rst_top(:,1);
        Elem2run.(PartName).(PartName).Top.ElemRow = row_top;
    else
        Elem2run.(PartName).(PartName).Top = [];
    end
    if ~isempty(rst_btm)
        Elem2run.(PartName).(PartName).Btm.Life = rst_btm(:,6);
        Elem2run.(PartName).(PartName).Btm.Loc = rst_btm(:,2:4);
        Elem2run.(PartName).(PartName).Btm.Elem = rst_btm(:,1);
        Elem2run.(PartName).(PartName).Btm.ElemRow = row_btm;
    end

	Elem2run.(PartName).(PartName).SNcurve = CGinfo.(PartName).SN;
	Elem2run.(PartName).(PartName).Thk = CGinfo.(PartName).thk;

	ElemFile = [PartName '_ELem2Run.mat'];
	save(ElemFile,'Elem2run')

	clear Elem2run
end