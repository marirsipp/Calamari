function[Rst] = SAP_Post_Force_Single(RstFile, FrameNo, StationNo)
%Return force and moment at a single station of a single frame from SAP
%output file

%Inputs:
%RstFile - Name of SAP output files
%FrameNo - No. of frame to read force results
%StationNo - No. of station to read force results 

%Input file tabs
ForceTab = 'Element Forces - Frames';
row_start = 4;

%Frame force/moment output
[num3, txt3, raw3] = xlsread(RstFile,ForceTab);
name = raw3(2,:);
station=cell2struct(raw3(row_start:end,:),name,2);

for i = 1:size(station,1)
    if (str2double(station(i).Frame)==FrameNo)
        if (station(i).Station == StationNo)
            Station_Force = [station(i).P,station(i).V2, station(i).V3, station(i).T, station(i).M2, station(i).M3]*1000; %N
            if strcmp (station(i).CaseType, 'LinStatic')                
                Rst.(station(i).OutputCase) = Station_Force;
            elseif strcmp (station(i).CaseType, 'NonStatic')
                if strcmp (station(i).StepType, 'Max')
                    Rst.(station(i).OutputCase) = Station_Force;
                end
            end
        end
    end
end
end