function[Result] = TmFatigS1_or_S2 (tstep,load,prob,Strfile,ColNs, SNcurve)
% Calculation of fatigue damage based on time history of maximum principal
% stress (S1) or minimum principal stress (S2) for each run
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

% disp('CAUTION - file with hard-coded rotation!!!!!!')
for n = 1:nrun
    disp(['Running bin ' num2str(n) ' for ' Cnnt])
    M_vst = load.vals.(RunNames{n});
    % Hard coded rotation
%     M_wf = [-M_vst(:,2), M_vst(:,1), M_vst(:,3), -M_vst(:,5), M_vst(:,4), M_vst(:,6)];
    M_wf = M_vst;
    p = prob.(RunNames{n});
    p_test(n) = p;
    
    StrChoice1.name = 'S1';
    StrChoice1.theta = [];
    StrChoice2.name = 'S2';
    StrChoice2.theta = [];
    DamageS1(:,n) = p* Dmg_perRun (tstep, M_wf, StrNm, Thk, SNcurve, StrChoice1); %Annual fatigue damage weighted by probability per bin, based on S1
    DamageS2(:,n) = p* Dmg_perRun (tstep, M_wf, StrNm, Thk, SNcurve, StrChoice2); %Annual fatigue damage weighted by probability per bin, based on S2
    
    for j = 1:size(DamageS1,1) %Per hot spot
        if DamageS1(j,n) >= DamageS2(j,n)
            DamageS1or2 (j,n) = DamageS1(j,n);
        else
            DamageS1or2 (j,n) = DamageS2(j,n);
        end
    end
end

FatigLife = 1./sum(DamageS1or2,2);

Result(:,ThkColN+1) = FatigLife;

testfile = ['test_' RunNames{1}(1:5) '_' Cnnt '.mat'];
save(testfile,'p_test','DamageS1','DamageS2','DamageS1or2')
end