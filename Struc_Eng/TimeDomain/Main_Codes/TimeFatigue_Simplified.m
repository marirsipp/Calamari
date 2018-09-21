%% Simplified method for time domain fatigue calculation
% Works for fatigue loads  at one single point 
% For now only works for loads at the tower base
% Simlified method 2.0 
% By Bingbin Yu, Principle Power Inc. 


%% Part 0: General info
%For now only works for loads at the tower base
if min(strcmp(Loads,{'Fx';'Fy';'Fz';'Mx';'My';'Mz'})) == 0
    error ('Simplified method only works for TB 6dof loads now, check var "Loads" in the input file')
end

%Paths for stress raw data and processed stress matrix
path_norm = [path0 ItrNo '\NormStr\'];
path_str = [path0 ItrNo '\SrotMtrx\'];
path_itr = [path0 ItrNo '\'];

if AddShear
    path_out = [path0 ItrNo '\' strBatch_Simp '\Simp_wShr\'];
else
    path_out = [path0 ItrNo '\' strBatch_Simp '\Simp\'];
end

%Make directories if needed
if ~exist(path_str,'dir')
    mkdir(path_str)
end
if ~exist(path_out,'dir')
    mkdir(path_out)
end

%Connection info
load([path_itr 'CnntInfo.mat']);
if ~strcmp(Cnnt.Itr,ItrNo)
    disp('Connection info does not contain the correct iteration no. Check input')
end

rst_col.x = 2; %Column No. that represents x axis 
rst_col.y = 3; %Column No. that represents y axis
rst_col.z = 4; %Column No. that represents z axis
rst_col.thk = 5; %Column No. for thickness

%% Part I: Srot matrix
if GenSrot
    cd(path_norm)
    fnames = dir('*.csv');
    numfids = length(fnames);

    for n=1:numfids
        filename = fnames(n).name;
        ind1 = regexp(filename,'_');
        cnnt{n,1} = filename(1:ind1(end)-1);
    end

    Cnames = unique(cnnt);
    CnntNo = size(Cnames,1);

    for n = 1:CnntNo
        cnntname = Cnames{n};
        ind1 = regexp(cnntname,'_');
        LineNo = cnntname(1:ind1(1)-1);
        PartName = cnntname(ind1(1)+1:ind1(2)-1);
        TorB = cnntname(ind1(2)+1:end);

        thk = Cnnt.(LineNo).(PartName).thk;
        axisTT = Cnnt.(LineNo).(PartName).axisTT;
        if isfield(Cnnt.(LineNo).(PartName),'SDir')
            StrDir = Cnnt.(LineNo).(PartName).SDir;
            BuildSrotMtrx(path_norm, path_str, cnntname, thk, axisTT, StrDir, Loads, LoadValue);
        end        
    end
end
%% Part II: Fatigue Life based on directional DEL
if length(Meq_Angle) ~= length(Meq)
    error('Input no. of DEL angles does not match no. of DELs. Check input')
else
    SNFile = [path0 'SNcurve.mat'];
    load(SNFile)
    
    N_Meq = length (Meq_Angle);        
    for k = 1:N_Meq
        if Meq_Angle(k)<10;
            Mdir{k} = ['M00' num2str(Meq_Angle(k))];
        elseif Meq_Angle(k)<100;
            Mdir{k} = ['M0' num2str(Meq_Angle(k))];
        else
            Mdir{k} = ['M' num2str(Meq_Angle(k))];
        end            
    end

    cd(path_str)
    fnames = dir('*.csv');
    numfids = length(fnames);
    
    for n = 1:numfids
    
        filename = fnames(n).name;
        ind1 = regexp(filename,'_');
        ind2 = regexp(filename,'.csv');
        LineNo = filename(ind1(1)+1:ind1(2)-1);
        PartName = filename(ind1(2)+1:ind1(3)-1);
        TorB = filename(ind1(3)+1:ind2(1)-1);
        CnntName = filename(ind1(1)+1:ind2(1)-1);
        
        SNname = Cnnt.(LineNo).SN;
        SN = SNcurve.(SNname);
        
        SrotMtrx = importdata(filename);
        Srot = SrotMtrx.data;
        FatigLife(:,1:5) = Srot(:,1:5);
        Thk = Srot(1,rst_col.thk); %For now, just assuming one thickness for one member along the connection
                        
        Ntheta = (size(Srot,2)-5)/4;
        for k = 1:Ntheta
            Sdir{k} = SrotMtrx.textdata{5+k}(1:4);
        end
        
        OutputName = [path_out, LineNo,'_',PartName,'_',TorB, '.csv'];
        header = cell(1,5+Ntheta*N_Meq);
        header(1:5) = [{'NodeNo'},{'X(mm)'},{'Y(mm)'},{'Z(mm)'},{'Thk(mm)'}];
        format1 = ['%6s',',', repmat(['%5s',','],1,3), '%7s', repmat([',','%18s'],1,Ntheta*N_Meq),'\n'];
        format2 = ['%10.0f', repmat([',','%10.3f'],1,3), ',', '%6.1f', repmat([',','%10.3f'],1,Ntheta*N_Meq),'\n'];
        
        for ii = 1:N_Meq            
            for jj = 1:Ntheta                
                Mdir_rad = Meq_Angle(ii)/180*pi;                
                %Calculate directional stress wrt 1kNm bending moment in currecnt direction
                S_Mdir = Srot(:,5+(jj-1)*4+3)*cos(Mdir_rad)+Srot(:,5+(jj-1)*4+4)*sin(Mdir_rad); 
                
                if AddShear == 1                    
                     %Calculate directional stress wrt 1kN shear force in
                     %direction 270deg offset from moment direction, force that would be in phase with the moment
                    S_Fdir = Srot(:,5+(jj-1)*4+1)*cos(Mdir_rad+3*pi/2)+Srot(:,5+(jj-1)*4+2)*sin(Mdir_rad+3*pi/2);
                    [flag,ind_Fdir]=ismember(Meq_Angle(ii)+90,Meq_Angle);
                    if flag == 0
                        [flag,ind_Fdir]=ismember(Meq_Angle(ii)-90,Meq_Angle);
                    end
                    S_eq = abs( Meq(ii) * S_Mdir+ Feq(ind_Fdir) * S_Fdir);
                else
                    S_eq = Meq(ii) * abs(S_Mdir); %Equvalent (directional) stress
                end
                
                if Thk>SN.t_ref %Thickness correction
                   Seq_corr=S_eq*(Thk/SN.t_ref)^SN.kcorr;
                else
                    Seq_corr = S_eq;
                end
                Neq = SN.A./(Seq_corr).^SN.m;  %Number to failure
%                 if isfield(SN,'N0')
%                     index_above=find(Neq>SN.N0);
%                     Neq(index_above)=SN.C./(Seq_corr(index_above)).^SN.r; 
%                 end
                damage = N0/Life_DEL./Neq;
                life = 1./damage;
                Srot_Mdir.(CnntName).(Mdir{ii})(:,jj) = S_Mdir;
                %Srot_Fdir.(CnntName).(Mdir{ii})(:,jj) = S_Fdir;
                Srot_Eqv.(CnntName).(Mdir{ii})(:,jj) = Seq_corr;
                Dmg.(CnntName).(Mdir{ii})(:,jj) = damage;
                
                header{5+(ii-1)*Ntheta+jj} = ['Life_' Sdir{jj} '_' Mdir{ii}];
                FatigLife(:,5+(ii-1)*Ntheta+jj) = life;
            end
        end
        
        Nnode = size(FatigLife,1);
        fid = fopen(OutputName,'w');
        fprintf(fid,format1, header{1:end});
        for i=1:Nnode
            fprintf(fid,format2, FatigLife(i,:));
        end
        fclose(fid);
        
        clear FatigLife Srot header format1 format2 Sdir
        
    end
end
