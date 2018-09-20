%PFFR   Plot Fast Float Results (Script)
%   Written By Alan Lum
%   Plots FastFloat Results from user chosen *.out or *.outb file. A plot is
%   created for each result chosen
%% Initialization and Parameters
[out_name, pathtoout] = uigetfile({'*.out;*.outb'},'Select .out file');
[~, filename, ext] = fileparts(out_name);
% out_name='\\POSEIDON\Data\WindFloat Numerical Codes\WindFloat 8MW WFATL\Detailed Design\NEWTOWERTuned - NBC FatRuns\Runs\Run610618006\primary.outb';
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
    [iChoice, isOK] = listdlg('PromptString','Select results to plot', 'Name', '.dat files available', 'ListString', headers(2:end));
    plot_specdens = questdlg('Plot Spectral Density?','Spectral Density');
    if ~isOK || strcmp(plot_specdens, 'Cancel')
        error('User canceled')
    else
        iChoice = iChoice + 1;
        for i = iChoice
            figure('name', headers{i})
            plot(data(:,1),data(:,i))
            xlabel('Time (sec)');
            ylabel([headers{i}, ' ', units{i}]);
            title('Time Series');
            grid minor
            if strcmp(plot_specdens, 'Yes')
                figure('name', [headers{i}, ' Spectral Density'])
                [freq, energy] = SpecDen(data(1:end,1), data(1:end,i));
                plot(freq,abs(energy))
                xlabel('Frequency (Hz)');
                ylabel('Energy');
                title([headers{i} ' Spectral Density']);
                xlim([0 2]);
                grid minor
            end
        end
    end
else
    error('User canceled')
end