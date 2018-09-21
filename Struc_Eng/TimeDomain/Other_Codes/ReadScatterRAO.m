function[] = ReadScatterRAO(ItrNo, path_out, wave_file, RAO_file, read_scatter, read_RAO)
%Read wave scatter data and tower base RAO file into Wave Scatter and RAO 
%structures 

%Input examples:
% ItrNo = 10; %Iteration number
% path = ['\\SHARK\Users\Ansys.000\Documents\MATLAB\TimeDomain\Itr' num2str(ItrNo)]; 
% wave_fname = 'WFM_ScatterTable.csv';
% wave_file = [path '\' wave_fname];
% RAO_fname = ['RunRAO_Iteration' num2str(ItrNo) '_TWR_2m.csv'];
% RAO_file = [path '\' RAO_fname];
% read_scatter = 1; %Read and generate scatter file
% read_RAO = 1; %Read and generate RAO file

%% Read wave scatter data
if read_scatter
    
    %Hard-coded scatter table info based on the format of the wave scatter 
    % diagram file (.csv)
    header = 7; 
    Hs = 0.25:0.5:6.25;
    Tp = 0.5:1:15.5;
    Heading = 0:30:330;

    N_hs = length(Hs);
    N_tp = length(Tp);
    N_head = length(Heading);
    N_row = N_tp+4;

    WaveScatter.Project = 'WFM';
    WaveScatter.Hs = Hs;
    WaveScatter.Tp = Tp;
    WaveScatter.Headings = Heading;

    for n = 1:N_head
        Head_Name = ['Head' num2str(Heading(n))];
        headline = header + (n-1)*N_row;
        wave_bin = importdata(wave_file,',',headline);
        WaveScatter.(Head_Name) = wave_bin.data(1:N_tp,1:N_hs);
        clear wave_bin
    end

    save([path_out '\WaveScatter.mat'],'WaveScatter')
end
%% Read BaseBend RAO data
if read_RAO
    %Hard-coded RAO table info based on the format of the tower RAO file (.csv)
    header = 5;
    Periods = [1 3:0.5:20 21:35 40];
    Dof = 6;
    Heading = 0:30:180;

    N_period = length(Periods);
    N_head = length(Heading);
    N_row = N_period+3;

    RAO.ItrNo = ['Itr' num2str(ItrNo)];
    RAO.Periods = Periods;

    for n = 1:N_head
        Head_Name = ['Head' num2str(Heading(n))];
        headline = header + (n-1)*N_row;
        RAO_head = importdata(RAO_file,',',headline);
        RAO.(Head_Name).Amp = RAO_head.data(:,2:1+Dof);
        RAO.(Head_Name).Phase = RAO_head.data(:,2+Dof:1+Dof*2);
        clear RAO_head
    end
    save([path_out '\TwrRAO_2m.mat'],'RAO')
end
end