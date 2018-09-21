function [TBloads,varargout] = GenRAObsTBloads(matname,RAO_file,Wave_file,Plfm_orient,tstep,Length_Timeseries,dT_fine,isave,isaveSpc,varargin)
%Generate time series of tower base force and moments based on wave spectrum and
%force momernt RAO
if nargin<7
    isave=0;
end
if nargin<8
    isaveSpc=0;
end
%Input example:
% matname = 'BatchM_Wave';
% RAO_file = 'TwrRAO_2m.mat';
% Wave_file = 'WaveScatter.mat';
% Plfm_orient = 0; %deg, offset from north, counter-clockwise
% tstep =.1;
% Length_Timeseries = 1800; %sec
% dT_fine = 0.5; %s, periods for refining load spectrum 
% isave =1;
% isaveSpc =0;
if ~exist(RAO_file,'file')
   RAO_file=convertDot4to2dScatter(); 
else
    disp(['Found RAO file: ' RAO_file]) % generally not on the path, don't use which
end
load(RAO_file);  % load a structure call RAO, see convertDot4to2dScatter

RAO_Dir=[RAO(:).Wdir]; % OrcaFlex wave convention

if ~exist(Wave_file,'file')
    Wave_file=write2dScatterTable(); 
else
    disp(['Found WaveScatter file: ' which(Wave_file)]) % should be on a shared repo
end
load(Wave_file); % load a structure call WaveScatter in OrcaFlex wave convention, see write2dScatterTable;

Wave_Dir = [WaveScatter.Wdir(:)];
N_Wdir = length(Wave_Dir);
N_per = length(WaveScatter.Tp);
N_Hs = length(WaveScatter.Hs);
Ndof = 6; % always right??

fr_fine = 1./(RAO(1).Tp(1):dT_fine:RAO(1).Tp(end)); %fr = 1./RAO.Periods; %Hz

        
%end up constructing a time history response of stress over the specified time
time = 0:tstep:Length_Timeseries; % in seconds 
%TBloads(N_Wdir).TBload=nan(N_per,length(time),Ndof); % way underestimates length...
%TBloads(N_Wdir).Prob=nan(N_per,1);
if isave
    TBloads(N_Wdir).TwrSpec = nan(N_per,length(fr_fine),Ndof);
end
%TBload = zeros(N_Wdir,N_per,length(time),size(TwrRAO,2));
for nn=1:N_Wdir
    DirName = sprintf('Head %d', round(WaveScatter.Wdir(nn)));
    
    [row,col,val]=find(WaveScatter.Prob{nn} ); %sea states with non-zero probabilities
    nN_per = length(row); %Total number of wave periods with non-zero prob for the current heading
    
    phi = mod(WaveScatter.Wdir(nn) - Plfm_orient,360); % No conversion necessary, both are in OrcaFlex wave convention
    if phi >180 %Assume longitudinal symmetry for RAOs
       RAO_dir = 360 - phi;
    else
       RAO_dir = phi;
    end
    iSnap=find(min(abs(RAO_dir-RAO_Dir))==abs(RAO_dir-RAO_Dir)); % snap to nearest RAO data, RAO defined in OrcaFlex wave convention
    %RAO_DirName = ['Head' num2str(RAO_Dir(iSnap))];

    TwrRAO = RAO(iSnap).Amp;
    TwrTp = RAO(iSnap).Tp;
    TwrPhase = RAO(iSnap).Phase;
    nDOF=size(TwrRAO,2);
    
    TwrRAO_intrp = zeros(length(fr_fine),nDOF);
    TwrPhase_intrp = zeros(length(fr_fine),nDOF);
    for pp = 1:nDOF %for all d-o-f of tower base loads
        TwrRAO_intrp(:,pp) = interp1(TwrTp,TwrRAO(:,pp),1./fr_fine);
        TwrPhase_intrp(:,pp) = interp1(TwrTp,TwrPhase(:,pp),1./fr_fine);
    end
    TBloads(nn).Wdir =  WaveScatter.Wdir(nn);
    TBloads(nn).Wdir1 =  WaveScatter.Wdir1(nn);
    TBloads(nn).Wdir2 =  WaveScatter.Wdir2(nn);
    for mm = 1:nN_per
        Tp = WaveScatter.Tp(row(mm));
       %for hh = 1:N_Hs
        Hs = WaveScatter.Hs(col(mm));
            
        % record values for non-zero prob
        TBloads(nn).Prob(mm) = val(mm)/100;%WaveScatter(nn).Prob/100;
        TBloads(nn).Hs(mm) = Hs;
        TBloads(nn).Tp(mm) = Tp;
        % Write to a runname
        %RunName = ['Run_H' num2str(Hs*100) '_T' num2str(Tp*10) '_' DirName];
        
       

            %sp1 spectral density (m^2/Hz)
            Wave.Hs=Hs; Wave.Tp=Tp;Wave.Gam=3.3;
            S1 = waveLibrary(2*pi*fr_fine,Wave,'JONSWAP');
            sp1 = S1*2*pi; %[m^2/Hz]
        
            for k=length(fr_fine):-1:1
%             fhat=fr_fine(k)*Tp;
%             if (fhat<1)
%                 alpha=exp(-1. * ((fhat-1.)^2) / (2*siga^2));
%             else
%                 alpha=exp(-1. * ((fhat-1.)^2) / (2*sigb^2));
%             end
%             sp1(k) =Cp*Gamma^alpha*exp(-1.25/fhat^4)/fhat^5;
                TwrSp(k,:)=TwrRAO_intrp(k,:).^2.*sp1(k); % classical output spec = input .* TF.^2
            
                %Determine spectra of stress amplitude
                if k == 1
                    f1 = 2*fr_fine(1);
                    f2 =(fr_fine(1)+fr_fine(2))/2;
                elseif k == length(fr_fine)
                    f1 =(fr_fine(k-1)+fr_fine(k))/2;
                    f2 = 0;
                else
                    f1 =(fr_fine(k-1)+fr_fine(k))/2;
                    f2 =(fr_fine(k)+fr_fine(k+1))/2;
                end

                TB_amp(k,:)=sqrt(2*TwrRAO_intrp(k,:).^2.*sp1(k)*(f1-f2));
                random_wave_phase(k)=rand*360;
            end
        
      
        
            for ii = 1:size(TwrRAO,2) %for all d-o-f of tower base loads
                amplitudes = repmat(TB_amp(:,ii),1,length(time));
                random_load_phase = random_wave_phase' + TwrPhase_intrp(:,ii);
                random_phase = repmat(random_load_phase,1,length(time));
                phase = 2.*pi.*(fr_fine'*time) + random_phase.*pi./180;
                response = sum(amplitudes.*sin(phase));
                TBloads(nn).TBload(mm,:,ii) = response;
            end
        %vals.(RunName) = TBload;
        if isaveSpc
            TBloads(nn).TwrSpec(mm,:,:) = TwrSp; 
        end
    end
    disp(['Created timeseries for all bins with ' DirName])
    %clear row col val N_sea RAO_dir RAO_DirName TwrRAO TwrPhase TwrRAO_intrp TwrPhase_intrp
end
if isave
    save(matname,'TBloads')
end
% cd(path_batch)
% load_file = 'Combine_BB_POWandPAR.mat';
% prob_file = 'prob.mat';
% save(load_file,'vals','dT_fine','fr_fine','TwrSpec','sp1')
% save(prob_file,'prob')
end

       %prob.(RunName) = val(mm)/100;
        
        %Calculate wave spectral density - from CalcspecHS.m
        %target spectrum
%         siga=0.07;
%         sigb=0.09;
%         Gamma = 3.3;
%         Cp = (5*Hs^2)/(16*(1/Tp)*(1.15+0.168*Gamma-0.925/(1.909+Gamma)));