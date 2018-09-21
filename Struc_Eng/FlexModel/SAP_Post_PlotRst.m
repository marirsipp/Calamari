function[] = SAP_Post_PlotRst(path0, CaseName, BaseCase, BeamName)
%Plot SAP output beam results - force and moment distribution along beams

CaseFile = [path0 '\SAP_BeamResult_' CaseName '.mat'];
CaseRst = load(CaseFile);
if ~isempty(BaseCase)
    BsCsFile = [path0 '\SAP_BeamResult_' BaseCase '.mat'];
    BsCsRst = load(BsCsFile);
end

fcnames = CaseRst.Beam_Result.Header(1,6:11);
units = CaseRst.Beam_Result.Header(2,6:11);

if ~isempty(BeamName)
    loc = CaseRst.Beam_Result.(BeamName)(:,3:5);
    arc = CaseRst.Beam_Result.(BeamName)(:,end);
    if ~isempty(BaseCase)
        force = CaseRst.Beam_Result.(BeamName)(:,6:11)-BsCsRst.Beam_Result.(BeamName)(:,6:11);
    else
        force = CaseRst.Beam_Result.(BeamName)(:,6:11);
    end
    hf=figure('name', sprintf('%s-%s_%s_forces',CaseName, BaseCase, BeamName));
    plot(arc,force(:,1:3))
    legend(fcnames{1:3},'Location','Best')
    xlabel('Arc length (m)')
    ylabel(sprintf('Forces(%s)', units{1}))
    
    hf=figure('name', sprintf('%s-%s_%s_moments',CaseName, BaseCase, BeamName));
    plot(arc,force(:,4:6))
    legend(fcnames{4:6},'Location','Best')
    xlabel('Arc length (m)')
    ylabel(sprintf('Moments(%s)', units{4}))
else
    fnames = fieldnames(CaseRst.Beam_Result);
    Nbeams = length(fnames)-1;
    loc = [];
    force = [];
    for n=1:Nbeams
        beamname = fnames{n+1};
        loc_org = CaseRst.Beam_Result.(beamname)(:,3:5);
        if ~isempty(BaseCase)
            fm = CaseRst.Beam_Result.(beamname)(:,6:11)-BsCsRst.Beam_Result.(beamname)(:,6:11);
        else
            fm = CaseRst.Beam_Result.(beamname)(:,6:11);
        end
        loc = [loc; loc_org];
        force = [force; fm];
    end
    for ii = 1:6
        forcename = fcnames{ii};
        unitname = units{ii};
        Xd = loc(:,1);
        Yd = loc(:,2);
        Zd = loc(:,3);
        Sd = force(:,ii);
        hf=figure('name', sprintf('%s-%s_%s',CaseName, BaseCase, forcename));
        nColors=100;
        mycmap=getcmap(nColors,{'dblue','blue','white','red','dred'});
%         colormap(mycmap)
%         scatter3(Xd,Yd,Zd,30,Sd,'filled','MarkerEdgeColor','k')
        colormap('default')
        scatter3(Xd,Yd,Zd,30,Sd,'filled')
        axis equal
        caxis([-max(abs(Sd)),max(abs(Sd))]) % change caxis    
        hc=colorbar;
        hL = ylabel(hc, sprintf('%s(%s)',forcename, unitname));
        set(hL,'Rotation',90);
    end
end

path_rst = [path0 '\' CaseName '\'];
SaveAllFig(path_rst)
close all
end