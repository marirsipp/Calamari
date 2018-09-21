function[Result] = TmFatigSothers_VestasTransient (tstep,load,prob,Strfile,ColNs, SNcurve, StrChoice, DirInfo)
% Calculation of fatigue damage based on time history of choice of stress 
% for each run
% For loads with Vestas format

%--------------------------------Input-------------------------------------
%General path for load data
RunNames = fieldnames(load.vals);
nrun = size(RunNames,1);

ThkColN = ColNs(1); %Thickness column number
StrColN1 = ColNs(2); %Normal stress starting column number
StrColN2 = ColNs(3); %Normal stress ending column number
% SNColN = ColNs(4); %SN curve info column number


%Read stress matrix 
str = importdata(Strfile);
ind1 = regexp(Strfile,'\');
ind2 = regexp(Strfile,'_');
Cnnt = Strfile(max(ind1)+1:max(ind2)-1);

if isstruct(str)
    StrNm = str.data(:,StrColN1:StrColN2); %Normal stress matrix 
    Thk = str.data(:,ThkColN); %Thkness of each member where hot spots locate
    Result(:,1:ThkColN) = str.data(:,1:ThkColN);
    % SN = str.data(:,SNColN); % SN curve selection
else
    StrNm = str(:,StrColN1:StrColN2); %Normal stress matrix 
    Thk = str(:,ThkColN); %Thkness of each member where hot spots locate
    Result(:,1:ThkColN) = str(:,1:ThkColN);
end

%Wind direction distribution info
Ndir = length(DirInfo.phi);

for n = 1:nrun
    disp(['Running bin ' num2str(n) ' for ' Cnnt])
    M_vst = load.vals.(RunNames{n});
    M_wf = [-M_vst(:,2), M_vst(:,1), M_vst(:,3), -M_vst(:,5), M_vst(:,4), M_vst(:,6)];
    p = prob.(RunNames{n});
    p_test(n) = p;
    
    for ii = 1:Ndir
        angle = (DirInfo.phi0 - DirInfo.phi(ii))/180*pi;
        Fx_rot = M_wf(:,1)*cos(angle) - M_wf(:,2)*sin(angle);
        Fy_rot = M_wf(:,1)*sin(angle) + M_wf(:,2)*cos(angle);
        Mx_rot = M_wf(:,4)*cos(angle) - M_wf(:,5)*sin(angle);
        My_rot = M_wf(:,4)*sin(angle) + M_wf(:,5)*cos(angle);
        M_wf_vdir{ii} = [Fx_rot,Fy_rot,M_wf(:,3),Mx_rot,My_rot,M_wf(:,6)];
        p_vdir(ii) = p*DirInfo.dir_prob(ii);
    end
    
    if ~strcmp(StrChoice.name,'Srot')
        for ii = 1:Ndir
            DamageS_vdir(:,ii,n) = p_vdir(ii) * Dmg_perRun(tstep, M_wf_vdir{ii}, StrNm, Thk, SNcurve, StrChoice); 
        end
        DamageS(:,n) = sum(DamageS_vdir(:,:,n),2); 
    else
        Nnode = size(StrNm,1);
        Ntheta = length(StrChoice.theta);
        for ii = 1:Ndir
            DamageS_vdir(:,1:Ntheta,ii,n) = p_vdir(ii) * Dmg_perRun (tstep, M_wf_vdir{ii}, StrNm, Thk, SNcurve, StrChoice); 
        end
        DamageS(:,1:Ntheta,n) = sum(DamageS_vdir(:,:,:,n),3);        
        for j = 1:Nnode %Per hot spot
            DamageS(j,Ntheta+1,n) = max(DamageS(j,1:end,n)); %Maximum damage for all stress directions
        end
    end    
end

if ~strcmp(StrChoice.name,'Srot')
    FatigLife = 1./sum(DamageS,2);
    Result(:,ThkColN+1) = FatigLife;
else
    FatigLife = 1./sum(DamageS,3);
    Result(:,ThkColN+1:ThkColN+Ntheta+1) = FatigLife;
end

testfile = ['test_dirsprd_' RunNames{1}(1:5) '_' Cnnt '.mat'];
save(testfile,'p_test','DamageS','DamageS_vdir')
end