function[] = SAP_Post_PlotDisp(path0, CaseName, BaseCase, BeamName, scale)
%Plot SAP output beam results - displacement of nodes/stations distribution along beams

CaseFile = [path0 '\SAP_BeamDisp_' CaseName '.mat'];
CaseRst = load(CaseFile);
if ~isempty(BaseCase)
    BsCsFile = [path0 '\SAP_BeamDisp_' BaseCase '.mat'];
    BsCsRst = load(BsCsFile);
end

fcnames = CaseRst.Beam_DispRst.Header(1,4:9);
units = CaseRst.Beam_DispRst.Header(2,4:9);

if ~isempty(BeamName)
    loc = CaseRst.Beam_DispRst.(BeamName)(:,1:3);
    arc = CaseRst.Beam_DispRst.(BeamName)(:,end);
    if ~isempty(BaseCase)
        disp = CaseRst.Beam_DispRst.(BeamName)(:,4:9)-BsCsRst.Beam_DispRst.(BeamName)(:,4:9);
    else
        disp = CaseRst.Beam_DispRst.(BeamName)(:,4:9);
    end
    hf=figure('name', sprintf('%s-%s_%s_disp',CaseName, BaseCase, BeamName));
    plot(arc,disp(:,1:3))
    legend(fcnames{1:3},'Location','Best')
    xlabel('Arc length (m)')
    ylabel(sprintf('Displacements(%s)', units{1}))
    
    hf=figure('name', sprintf('%s-%s_%s_rot',CaseName, BaseCase, BeamName));
    plot(arc,disp(:,4:6))
    legend(fcnames{4:6},'Location','Best')
    xlabel('Arc length (m)')
    ylabel(sprintf('Rotations(%s)', units{4}))
    
else
    fnames = fieldnames(CaseRst.Beam_DispRst);
    Nbeams = length(fnames)-1;
    loc = [];
    disp = [];
    for n=1:Nbeams
        beamname = fnames{n+1};
        loc_org = CaseRst.Beam_DispRst.(beamname)(:,1:3);
        if ~isempty(BaseCase)
            dp = CaseRst.Beam_DispRst.(beamname)(:,4:9)-BsCsRst.Beam_DispRst.(beamname)(:,4:9);
        else
            dp = CaseRst.Beam_DispRst.(beamname)(:,4:9);
        end
        loc = [loc; loc_org];
        disp = [disp; dp];
    end
    
    X_org = loc(:,1);
    Y_org = loc(:,2);
    Z_org = loc(:,3);
    X_def = X_org + scale*disp(:,1);
    Y_def = Y_org + scale*disp(:,2);
    Z_def = Z_org + scale*disp(:,3);
    
    for ii = 1:3
        dispname = fcnames{ii};
        unitname = units{ii};

        Sd = disp(:,ii);
        hf=figure('name', sprintf('%s-%s_%s',CaseName, BaseCase, dispname));
        nColors=100;
        colormap('default')
%         scatter3(X_org,Y_org,Z_org,5,'filled','m')
%         hold on
        scatter3(X_def,Y_def,Z_def,30,Sd,'filled')
        hold off
        axis equal
        caxis([-max(abs(Sd)),max(abs(Sd))]) % change caxis    
        hc=colorbar;
        hL = ylabel(hc, sprintf('%s(%s)',dispname, unitname));
        set(hL,'Rotation',90);
    end

end

path_rst = [path0 '\' CaseName '\Disp\'];
SaveAllFig(path_rst)
close all
end