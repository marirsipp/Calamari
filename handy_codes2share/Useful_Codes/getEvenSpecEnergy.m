function [wout,varargout] = getEvenSpecEnergy(minw,maxw,Nw,Wave,WaveType,Etol)
%win = (N+2,1) total points (there are N interior points)
  % move w around to try and equalize energy
  Tp=Wave.Tp;
    maxdW=maxw*(2*pi/Tp);
  mindW=minw*2*pi/Tp;
   delW=(maxdW-mindW)/Nw; 
   relax0=.1;
  N=Nw-2; % don't move the endpoints
  wout=nan(N+2,1);
  Sout=nan(N+2,1);
  dSout=nan(N+1,1);
  wi=mindW; wout(1)=wi;
  wf=maxdW; wout(end)=wf;
  wfine=linspace(wi,wf,1e4);
  Sfine = waveLibrary(wfine,Wave,WaveType);
   Egoal=trapz(wfine,Sfine)/(N+1);
  % initialize 
%   S = waveLibrary(win,Hs,Tp,WaveType) ; % N+2 function evaluations
%       plot(2*pi./win,S,'k-x');
%   Sbar = mean([S(1:end-1) S(2:end)],2); % N+1 mid points
%   Energy = Sbar.*diff(win); % there are N+1 areas
  Sout(1)=waveLibrary(wi,Wave,WaveType) ; 
  err=[0; inf(N+1,1) ];
  for kk=2:N+2
      dwk=delW;
      wout(kk)=wout(kk-1);
      ni=0;
      relax=relax0;
      errChk=err(kk);
      while abs(errChk)>Etol
          %initial guess
          wout(kk)=wout(kk)+dwk;
          Sout(kk) = waveLibrary(wout(kk),Wave,WaveType) ;
          dSout(kk-1)=diff(Sout(kk-1:kk));
          m = dSout(kk-1)/dwk;  % could be tiny or huge..
          Ek=mean(Sout(kk-1:kk))*(wout(kk)-wout(kk-1));
          err(kk)=Ek-Egoal;
          errChk=err(kk);
          %dwS=(dSout(kk-1)<1e-2)*delW+(dSout(kk-1)>1e-2)*(1./abs(dSout(kk-1)))*delW
          disp(sprintf('.....freq %d, %1.6E, error=%1.6E', kk, wout(kk),err(kk)))
          if kk<N+2
            dwE=max([min([delW relax*sqrt(abs(2*err(kk)/m))]) Etol/Wave.Hs^2]);
            dwk=-1*sign(err(kk))*dwE;
          else
              %discretize the tail properly
              wxtra=linspace(wout(kk),wf,floor(N*.2))';
              wout=[wout(1:end-1);wxtra];
              Sxtra=  waveLibrary(wxtra,Wave,WaveType) ;
              Sout=[Sout(1:end-1);Sxtra];
              Extra=mean([Sout(kk:end-1) Sout(kk+1:end)],2).*diff(wxtra);
              err=[err; Extra-Egoal];
              errChk=0; %get out of the loop
          end
          ni=ni+1;
          if mod(ni,100)==0
              relax=relax/2;
          end
           if mod(ni,1000)==0
              relax=relax0;
          end
      end          
  end
  varargout{1}=err;
  varargout{2}=Sout;
end

%               pp=0;
%               Erem=mean([Sfine(end) Sout(kk+pp)])*(wf-wout(kk+pp));
%               dwk=0;
%               while Erem>Etol
%                   wout(kk+pp)=wout(kk+pp-1);
%                   err(kk+pp)=inf; %enter the loop
%                   while abs(err(kk+pp))>Etol
%                       wout(kk+pp)=wout(kk+pp)+dwk;
%                       Sout(kk+pp) = waveLibrary(wout(kk+pp),Wave,WaveType) ;
%                       dSout(kk+pp-1)=diff(Sout(kk+pp-1:kk+pp));
%                       m = dSout(kk+pp-1)/dwk;  % could be tiny or huge..
%                       Ek=mean(Sout(kk+pp-1:kk+pp))*(wout(kk+pp)-wout(kk+pp-1));
% 
%                       err(kk+pp)=Ek-Egoal/10;
%                       dwE=max([min([delW relax*sqrt(abs(2*err(kk+pp)/m))]) Etol/Wave.Hs^2]);
%                       dwk=-1*sign(err(kk+pp))*dwE;
%                       disp(sprintf('.....freq %d, %1.6E, error=%1.6E', kk+pp, wout(kk+pp),err(kk+pp)))
%                   end
%                   Erem=mean([Sfine(end) Sout(kk+pp)])*(wf-wout(kk+pp));
%                   pp=pp+1;
%               end