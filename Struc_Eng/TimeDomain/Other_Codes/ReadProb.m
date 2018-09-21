function [] = ReadProb(path1,file_type,start_line)

%Input
%path1      - path where run info files are stored
%file_type  - type of the run info files: 'xlsx' or 'frq'
%start_line - no. of line where run info starts

%Reads probability o
life = 25; %year
hour_year = 365.25*24; %No of hours per year
output = 'prob';

cd(path1)

if strcmp(file_type,'xlsx')
    
    fnames = dir('*.xlsx');
    numfids = length(fnames);

    for n = 1:numfids
        [num, txt]=xlsread(fnames(n).name);
        RunNo = size(num,1);
        for m = 1:RunNo
            RunName = ['Run' txt{m+1,1} '_PPI'];
            prob.(RunName)=num(m,1)/(life*hour_year);
        end
        total_prob(n) = sum(num(:,1))/(life*hour_year);
        clear num txt
    end
    
elseif strcmp(file_type,'frq')
    
    fnames = dir('*.frq');
    numfids = length(fnames);    
    
    for n = 1:numfids
        fid = fopen(fnames(n).name);
        LineNo = 1;
        while ~feof(fid)
            tline = fgets(fid);
            if LineNo < start_line
            elseif length(tline) < 10
                break
            else
                [A,B,C,D,E,F,G,HH,II]=strread(tline,'%s %f %f %d %d %f %s %f %s');
                ind = regexp(A{1},'.int');
                runname = ['Run' A{1}(1:ind-1) '_PPI'];
                ind2 = findstr(runname,'.');
                if isempty(ind2)
                    RunName = runname;
                elseif length(ind2) == 1
                    RunName = [runname(1:ind2-1),runname(ind2+1:end)];
                end
                prob.(RunName)=B/(life*hour_year);
                p_test(LineNo) = prob.(RunName);
            end
            LineNo = LineNo + 1;    
        end
        total_prob(n) = sum(p_test);
        fclose(fid);
    end
end

save(output,'prob');
end