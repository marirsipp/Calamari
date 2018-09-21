function[Result] = TmFatigSothers_Vestas (tstep,load,prob,Strfile,ColNs, SNcurve, StrChoice)
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

disp('CAUTION - file with hard-coded rotation!!!!!!')
for n = 1:nrun
    disp(['Running bin ' num2str(n) ' for ' Cnnt])
    M_vst = load.vals.(RunNames{n});
    % Hard coded rotation
    M_wf = [-M_vst(:,2), M_vst(:,1), M_vst(:,3), -M_vst(:,5), M_vst(:,4), M_vst(:,6)];
    p = prob.(RunNames{n});
    
    p_test(n) = p;
    
    if ~strcmp(StrChoice.name,'Srot')
        DamageS(:,n) = p * Dmg_perRun (tstep, M_wf, StrNm, Thk, SNcurve, StrChoice); 
    else
        Nnode = size(StrNm,1);
        Ntheta = length(StrChoice.theta);
        DamageS(:,1:Ntheta,n) = p * Dmg_perRun (tstep, M_wf, StrNm, Thk, SNcurve, StrChoice);
        
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

testfile = ['test_' RunNames{1}(1:5) '_' Cnnt '.mat'];
save(testfile,'p_test','DamageS')
end