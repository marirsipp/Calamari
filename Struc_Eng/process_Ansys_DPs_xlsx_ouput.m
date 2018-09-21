% This script has been created in June 2017 by Charlotte Leroux 
% in order to rearrange Ansys ouput data (parameters stored in a table)
% in case of Design Points simulation

%% Path of Ansys output tables
WorkDir = 'C:\Users\Nortada\Desktop\Document de Charlotte\WFA\MooringConnector\';
output_file = 'WFA_MC_Col1_raw.xlsx';
dps = 6; % number of design points, including dp0

%% Load data
[~, ~, raw] = xlsread([ WorkDir output_file],'output');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,1);

%% Sort data by load case
run_name = cellVectors{1};
% Number of Load Cases
n = strfind(cellVectors,'Name');
n = sum([n{:}]);

for i = 1:n
    l1 = 3 + (i-1)*(4+dps);
    load_case{i,1} = raw{l1,1};
    names = raw(l1+1,2:end);
    units = raw(l1+2,2:end);
    results = raw(l1+3:l1+3+dps-1,2:end);
    
    %     clean names
    names = strrep(names,'Exported','');
    names = strrep(names,'Notes','');
    % remove ID number from variable
    % convert data in MPa
    for j = 1:length(names)
        if isempty(names{j}) == 0
            tempN = names{1,j};
            ki = strfind(tempN,' - '); % Remove Ansys ID number
            if isempty(ki) == 0
                tempN = tempN(ki(1)+3:end);
            end
%             tempN = strrep(temp,'Maximum','Max');
%             tempN = strrep(temp,'Minimum','Min');
            
            tempU = units{1,j};
            tempR = [results{1:dps,j}];
            % Change unit if needed
            if isequal(tempU,'Pa')
                tempR = tempR/1e6;
                tempU = 'MPa';
            end
            % Allocate variables in output
            namesC{j,1} = char(tempN);
            unitsC{j,1} = tempU;
            resultsC(j,:) = tempR;
            clear tempN tempU tempR
        end
    end
    
    % Global output
    DataOut.(load_case{i,1}).names = namesC;
    DataOut.(load_case{i,1}).units = unitsC;
    DataOut.(load_case{i,1}).results = resultsC;
    
    clear names units results namesC unitsC resultsC
    
end

%% Create Table for excel output

% Find common output variables in the different load cases
i = 1;
names = DataOut.(load_case{i,1}).names;
J = length(names);
for i = 2:n
    names = [names;DataOut.(load_case{i,1}).names];
end
k= cellfun('isempty',names);
names(k==1,:) = [];

Vars = {};
for j = 1:J
    tempN = names{j};
    idx = strfind(names,tempN);
    idxT = sum([idx{:}]);
    if isequal(idxT,n) 
        Vars = [Vars;tempN];
    end
end
clear names

%%% Order categories
% Maxima
Maxima = strfind(Vars,'Maximum Principal Stress');
k= cellfun(@(x)~isempty(x),Maxima);
Maxima = find(k);
% Minima
Minima = strfind(Vars,'Minimum Principal Stress');
k= cellfun(@(x)~isempty(x),Minima);
Minima = find(k);
% Normal stress
Normal_stress = strfind(Vars,'Normal Stress');
k= cellfun(@(x)~isempty(x),Normal_stress);
Normal_stress = find(k);
% Add maximum normal stress to maxima
Normal_stress_max = strfind(Vars(Normal_stress),'Maximum');
k= cellfun(@(x)~isempty(x),Normal_stress_max);
Maxima = [Maxima;Normal_stress(find(k))];
% Add maximum normal stress to maxima
Normal_stress_min = strfind(Vars(Normal_stress),'Minimum');
k= cellfun(@(x)~isempty(x),Normal_stress_min);
Minima = [Minima;Normal_stress(find(k))];
% Force Component
F_Component = strfind(Vars,'Component');
k= cellfun(@(x)~isempty(x),F_Component);
F_Component = find(k);
% % Fy Component
% Y_Component = strfind(Vars,'Y Component');
% k= cellfun(@(x)~isempty(x),Y_Component);
% Y_Component = find(k);
% % Fz Component
% Z_Component = strfind(Vars,'Z Component');
% k= cellfun(@(x)~isempty(x),Z_Component);
% Z_Component = find(k);
% Indices left
Others = ismember(1:1:length(Vars),[Maxima;Minima]);
Others = find(~Others);

%%% Output to be copied in excel
%%% First row
for idpn = 1:dps
    dpn = idpn-1;
r = 1;
Table_Out{1+(2*n+7)*dpn,1} = ['dp' int2str(dpn)];;
Table_Out{2+(2*n+7)*dpn,1} = '';
Table_Out{3+(2*n+7)*dpn,1} = 'Units';
Table_Out(4+(2*n+7)*dpn:3+n+(2*n+7)*dpn,1) = load_case;

% %%% Write "Components" category first
% 
% for j = 1:length(F_Component)
%     r = r+1;
%     var = Vars(F_Component(j));
%     Table_Out(2,r) = var;
%     for i = 1:n
%         names = DataOut.(load_case{i,1}).names;
%         k= cellfun('isempty',names);
%         names(k==1,:) = [];
%         k = strfind(names,var{:});
%         k= find(cellfun(@(x)~isempty(x),k));
%         Table_Out{3+i,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
%     end
%     Table_Out{3,r} = DataOut.(load_case{i,1}).units{k,1};
% end

% Write "Others" category first
for j = 1:length(Others)
    r = r+1;
    var = Vars(Others(j));
    Table_Out(2+(2*n+7)*dpn,r) = var;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
end
        
        
%%% Write "Maxima" category 
r = r+1;
r1 = r;
Table_Out{4+(2*n+7)*dpn,r} = 'Maximum Principal Stress - Max';

% Surfaces analysis
Table_Out{1+(2*n+7)*dpn,r+1} = 'Surface';
for j = 1:length(Maxima)
    var = Vars(Maxima(j));
    
    if isempty(strfind(var{:},'Path')) && isempty(strfind(var{:},'Normal Stress'))       
    r = r+1;    
    temp = strrep(var{:},'Maximum Principal Stress','');
    temp = strrep(temp,'Maximum','');
    temp = strrep(temp,'-','');
    temp = strrep(temp,'  ','');
    Table_Out{2+(2*n+7)*dpn,r} = temp;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
    end
end

% Paths analysis
Table_Out{1+(2*n+7)*dpn,r+1} = 'Path';
for j = 1:length(Maxima)
    var = Vars(Maxima(j));
    
    if isempty(strfind(var{:},'Path')) == 0     
    r = r+1;    
    temp = strrep(var{:},'Maximum Principal Stress',''); 
    temp = strrep(temp,'Maximum','');
    temp = strrep(temp,'Path','');
    temp = strrep(temp,'-','');
    temp = strrep(temp,'  ','');
    Table_Out{2+(2*n+7)*dpn,r} = temp;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
    end
end

% Normal Stress analysis
Table_Out{1+(2*n+7)*dpn,r+1} = 'Normal Stress';
for j = 1:length(Maxima)
    var = Vars(Maxima(j));
    
    if isempty(strfind(var{:},'Normal Stress')) == 0     
    r = r+1;    
    temp = strrep(var{:},'Normal Stress - ','');
    temp = strrep(temp,' Maximum','');
    Table_Out{2+(2*n+7)*dpn,r} = temp;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
    end
end

%%% Write "Minima" category 
r = r1;
l = 3+n;
Table_Out(4+l+(2*n+7)*dpn:3+n+l+(2*n+7)*dpn,1) = load_case;
Table_Out{4+l+(2*n+7)*dpn,r} = 'Minimum Principal Stress - Min';

% Surfaces analysis
Table_Out{1+l+(2*n+7)*dpn,r+1} = 'Surface';
for j = 1:length(Minima)
    var = Vars(Minima(j));
    
    if isempty(strfind(var{:},'Path')) && isempty(strfind(var{:},'Normal Stress'))         
    r = r+1;    
    temp = strrep(var{:},'Minimum Principal Stress','');
    temp = strrep(temp,'Minimum','');
    temp = strrep(temp,'-','');
    temp = strrep(temp,'  ','');
    Table_Out{2+l+(2*n+7)*dpn,r} = temp;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+l+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+l+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
    end
end

% Paths analysis
Table_Out{1+l+(2*n+7)*dpn,r+1} = 'Path';
for j = 1:length(Minima)
    var = Vars(Minima(j));
    
    if isempty(strfind(var{:},'Path')) == 0     
    r = r+1;    
    temp = strrep(var{:},'Minimum Principal Stress','');
    temp = strrep(temp,'Minimum','');
    temp = strrep(temp,'Path','');
    temp = strrep(temp,'-','');
    temp = strrep(temp,'  ','');    
    Table_Out{2+l+(2*n+7)*dpn,r} = temp;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+l+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+l+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
    end
end

% Normal Stress analysis
Table_Out{1+l+(2*n+7)*dpn,r+1} = 'Normal Stress';
for j = 1:length(Minima)
    var = Vars(Minima(j));
    
    if isempty(strfind(var{:},'Normal Stress')) == 0     
    r = r+1;    
    temp = strrep(var{:},'Normal Stress - ','');
    temp = strrep(temp,' Minimum','');
    Table_Out{2+l+(2*n+7)*dpn,r} = temp;    
    for i = 1:n       
        names = DataOut.(load_case{i,1}).names;
        k= cellfun('isempty',names);
        names(k==1,:) = [];
        k = strfind(names,var{:});
        k= find(cellfun(@(x)~isempty(x),k));
        Table_Out{3+i+l+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).results(k,1+dpn);
    end
    Table_Out{3+l+(2*n+7)*dpn,r} = DataOut.(load_case{i,1}).units{k,1};
    end
end
end

%%
% Export to file
% filenameOut = 'WFA_MC_Col1_update_results.xlsx';
% filenameOut = 'WFA_MC_Col23_results.xlsx';
filenameOut = 'WFA_MC_Col1_update_extremes_results.xlsx';
% filenameOut = 'WFA_MC_Col1_update_results_flangeConnection.xlsx';
% filenameOut = 'WFA_MC_Col23_update_extremes_results_StN35mm.xlsx';
xlswrite([WorkDir, filenameOut],{run_name},run_name,'A1');
xlswrite([WorkDir, filenameOut],Table_Out,run_name,'A3');
    