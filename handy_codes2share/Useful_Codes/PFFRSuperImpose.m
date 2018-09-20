%PFFR   Plot Fast  Results (Script) - Superimpose two .out results
%   Written By Antoine
%   Plots FastFloat Results from user chosen *.out file. A plot is
%   created for each result chosen
clear
close all
%% Initialization and Parameters
[out_name, pathtoout] = uigetfile({'*.out;*.outb'},'Select .out file');
[~, filename, ext] = fileparts(out_name);
if out_name ~= 0
    if strncmp(ext, '.outb', 5)
        [data, headers, units] = ReadFASTbinary([pathtoout, out_name]);
    else
        fid = fopen([pathtoout, out_name]);
    
    for i = 1:6
        fgets(fid);
    end
    headers = textscan(fgets(fid), '%s');
    headers = headers{1}';
    ncol = length(headers);
    units = textscan(fgets(fid), '%s');
    units = units{1}';
    data = fscanf(fid, '%f', [ncol inf])';
    fclose(fid);
    end
    %% Open second file
[out_name2, pathtoout2] = uigetfile({'*.out;*.outb'},'Select .out file');
[~, filename, ext] = fileparts(out_name2);
if out_name2 ~= 0
    if strncmp(ext, '.outb', 5)
        [data2, headers, units] = ReadFASTbinary([pathtoout2, out_name2]);
    else
        fid = fopen([pathtoout2, out_name2]);
    for i = 1:6
        fgets(fid2);
    end
    headers = textscan(fgets(fid2), '%s');
    headers = headers{1}';
    ncol = length(headers);
    units = textscan(fgets(fid2), '%s');
    units = units{1}';
    data2 = fscanf(fid2, '%f', [ncol inf])';
    fclose(fid2);
    end
end
    
    [iChoice, isOK] = listdlg('PromptString','Select results to plot', 'Name', '.dat files available', 'ListString', headers(2:end));
    plot_specdens = questdlg('Plot Spectral Density?','Spectral Density');
    if ~isOK || strcmp(plot_specdens, 'Cancel')
        error('User canceled')
    else
        iChoice = iChoice + 1;
        for i = iChoice
            figure('name', headers{i})
            plot(data(:,1),data(:,i))
            hold all
            plot(data2(:,1),data2(:,i))
            legend('OldTower','NewTower')
            xlabel('Time (sec)');
            ylabel([headers{i}, ' ', units{i}]);
            title('Time Series');
            grid minor
            if strcmp(plot_specdens, 'Yes')
                figure('name', [headers{i}, ' Spectral Density'])
                [freq, energy] = SpecDen(data(:,1), data(:,i));
                [freq2, energy2] = SpecDen(data2(:,1), data2(:,i));
                plot(freq,abs(energy))
                hold all;
                plot(freq2,abs(energy2))
                xlabel('Frequency (Hz)');
                ylabel('Energy');
                title([headers{i} ' Spectral Density']);
                xlim([0 1]);
                grid minor
                legend('OldTower','NewTower')
            end
        end
    end
else
    error('User canceled')
end