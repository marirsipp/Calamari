function Data = getWAMITData(wamitfile)
    fiddat = fopen(wamitfile);
    %read header line and discard it
    dataline = fgetl(fiddat);

    %Figure out from wamit suffix what variable we're looking at
    s = find(wamitfile=='.');
    if strcmp(wamitfile(s+1:end),'rao')
        suffix=4;
    else
        suffix = int8(str2double(regexp(wamitfile(s+1:end),'\d*','match')));% int8(str2double(sfile(s+1:end)));
    end
   
    %check out http://wamit.com/manualV7.2/wamit_v72manualch5.html for more info
switch suffix
    case 1 % added mass, damping (directionally independent)
        [c,count]=fscanf(fiddat,'%f %i %i %f %f ',[5 inf]);
        Xs = sortrows(c',[2 3 1]); %sort by i, then by, j, then by freq
        % How to make iprint variable persist throughout for loop?
%         iprint = questdlg('Reduce hydrodynamic coef matrix','Added mass and damping plots','full','reduced','reduced');
%         if strcmp(iprint,'reduced')
%             % reduce matrix here
%             for i=1:1:length(Xs)
%                 Xs(i,6) = abs(Xs(i,2)-Xs(i,3));
%             end
%             Xss = Xs;
%             out = 0;
%             for i=1:length(Xs)
%                 if(Xs(i,6)~=0)
%                     if((Xs(i,2)+Xs(i,3))~=6)
%                         Xss(i-out,:) = [];
%                         out = out + 1;
%                     end
%                 end
%             end
%             Xs = sortrows(Xss,[6 2]);
%         end
        Data.Xs=Xs;
        Data.Per=Xs(:,1);
        Data.DOFi=Xs(:,2);
        Data.DOFj=Xs(:,3);
        Data.A=Xs(:,4);
        Data.B=Xs(:,5);
        Data.NoPer = max(find((Xs(:,2)==1)& Xs(:,3)==1)); % find all instance of the (1,1) hydrocoeff
        Data.Heading=zeros(length(Xs),1);
        Data.NoHeading=0;
        Data.NoBody = max(Xs(:,3))/6;
        Data.NoFig= length(Xs)/Data.NoPer;
    case {2,3} % wave-exciting force(directionally-dependent)
        [c,count]=fscanf(fiddat,'%f %f %i %f %f %f %f',[7 inf]);
        Xs = sortrows(c',[3 2 1]);
        Data.Xs=Xs;
        Data.Per=Xs(:,1);
        Data.Heading=Xs(:,2);
        Data.DOFi=Xs(:,3);
        Data.ModX=Xs(:,4);
        Data.PhX=Xs(:,5);
        Data.ReX=Xs(:,6);
        Data.ImX=Xs(:,7);
        Data.NoElePerDOF = max(find(Xs(:,3)==1));
        temp =find(Xs(:,1)==Xs(1,1));
        Data.NoPer = temp(2)-1;
        Data.NoHeading = Data.NoElePerDOF/Data.NoPer;
        Data.NoBody = max(Xs(:,3))/6;
        Data.NoFig=6*Data.NoBody; %Data.NoHeading
    case 4 %RAOs!
        [c,count]=fscanf(fiddat,'%f %f %i %f %f %f %f',[7 inf]);
        Xs = sortrows(c',[3 2 1]);
        Data.Xs=Xs;
        Data.Per=Xs(:,1);
        Data.Heading=Xs(:,2);
        Data.DOFi=Xs(:,3);
        Data.ModRAO=Xs(:,4);
        Data.PhRAO=Xs(:,5);
        Data.ReRAO=Xs(:,6);
        Data.ImRAO=Xs(:,7);
        Data.NoElePerDOF = max(find(Xs(:,3)==1));
        temp =find(Xs(:,1)==Xs(1,1));
        Data.NoPer = temp(2)-1;
        Data.NoHeading = Data.NoElePerDOF/Data.NoPer;
        Data.NoBody = max(Xs(:,3))/6;
        Data.NoFig=6*Data.NoBody; %6*Data.NoHeadSelec*Data.NoBody;
    case 6 %Radiated/Diffracted Wave Field!
        [c,count]=fscanf(fiddat,'%f %f %i %f %f %f %f',[7 inf]);
        Xs = sortrows(c',[3 2 1]);
        Data.Xs=Xs;
        Data.Per=Xs(:,1);
        Data.Heading=Xs(:,2);
        Data.GPoint=Xs(:,3);
        Data.ModA=Xs(:,4);
        Data.PhA=Xs(:,5);
        Data.ReA=Xs(:,6);
        Data.ImA=Xs(:,7);
        Data.NoElePerDOF = max(find(Xs(:,3)==1));
        temp =find(Xs(:,1)==Xs(1,1));
        Data.NoPer = temp(2)-1;
        Data.NoHeading = Data.NoElePerDOF/Data.NoPer;
        Data.NoBody = max(Xs(:,3))/6;
        NoGPoint=length(unique(Data.GPoint));
        NoGPoint*Data.NoBody;
        Data.NoFig=NoGPoint; %6*Data.NoHeadSelec*Data.NoBody;
    case 8 %drift forces
        [c,count]=fscanf(fiddat,'%f %f %f %i %f %f %f %f',[8 inf]);
        Xs = sortrows(c',[4 3 2 1]);
        Data.Xs=Xs;
        Data.Per=Xs(:,1);
        Data.Heading=Xs(:,2);
        Data.Heading2=Xs(:,3);
        Data.DOFi=Xs(:,4);
        Data.ModF=Xs(:,5);
        Data.PhF=Xs(:,6);
        Data.ReF=Xs(:,7);
        Data.ImF=Xs(:,8);
        Data.NoElePerDOF = max(find(Xs(:,4)==1));
        temp =find(Xs(:,1)==Xs(1,1));
        Data.NoPer = length(unique(Data.Per));
        Data.NoHeading = Data.NoElePerDOF/Data.NoPer;
        Data.NoBody = max(Xs(:,4))/6;
        Data.NoDOFs=length(unique(Data.DOFi));
        Data.NoFig= Data.NoDOFs*Data.NoBody; % PLOT ALL DOFS ON SAME PLOT
    case 9 % ?
       [c,count]=fscanf(fiddat,'%f %f %f %i %f %f %f %f',[8 inf]);
        Xs = sortrows(c',[4 3 2 1]);
        Data.Xs=Xs;
        Data.NoBody = max(Xs(:,4))/6;
        Data.NoElePerDOF = max(find(Xs(:,4)==-6*Data.NoBody));
        temp =find(Xs(:,1)==Xs(1,1));
        Data.NoPer = temp(2)-1;
        Data.NoHeading = Data.NoElePerDOF/Data.NoPer;
        Data.NoFig= 9*Data.NoBody*Data.NoHeading; %
        Data.Per=Xs(:,1);
        Data.Heading=Xs(:,2);
        Data.Heading2=Xs(:,3);
        Data.DOFi=Xs(:,4);
        Data.ModF=Xs(:,5);
        Data.PhF=Xs(:,6);
        Data.ReF=Xs(:,7);
        Data.ImF=Xs(:,8);
end
fclose(fiddat);    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%     for i=1:MaxNoFig
%         h = figure(i);
% 
%         k = strcmp(suffix,'1');
%         if (k ~= 1)
%             if (length(suffix)==3)
%                 tlabel = ['Wave heading:  ',num2str(Xs(i*NoPer,3)),' deg'];
%                 if (suffix(3) =='d')
%                     subplot(2,1,1)
%                     xlabel('d T')
%                 else
%                     subplot(2,1,1)
%                     xlabel('T1 + T2')
%                 end
%             else
%                 tlabel = ['Wave heading:  ',num2str(Xs(i*NoPer,2)),' deg'];
%                 xlabel('T');
%             end
%    %         uicontrol('Style','text','Position',[400 400 150 15],'String',tlabel,'backgroundcolor',[1 1 1])
%         else
%             tlabel = ['Hydrodynamic Coefficients'];
%             xlabel('T');
%         end
% 
%         %Get title on top of fig
%         if((suffix~='8')&(suffix~='9'))
%             subplot(2,1,1)
%         end
%         title(tlabel)
%         legend(mylegend,0);
% 
%     end
% old multi-body functionality
    % bodyno = 0;
    % iprint = questdlg('Look at one body of a multiple body file?');
    % k = strcmp(iprint,'Yes');
    % if k == 1
    %     prompt   = {'Which body? (type zero if you meant to type No above)'};
    %     titl    = 'Body of interest';
    %     lines = 1;
    %     def     = {'1'};
    %     pickbody   = inputdlg(prompt,titl,lines,def,'on');
    %     bodyno = str2num(pickbody{1});
    % end
        %remove lines that are not needed if single body
        % if (bodyno~=0)
        %     out = 0;
        %     Xss = Xs;
        %     for i=1:length(Xs)
        %         if(((Xs(i,2)-(bodyno-1)*6)<1)|((Xs(i,2)-(bodyno-1)*6)>6))
        %             Xss(i-out,:) = [];
        %             out = out + 1;
        %         elseif(((Xs(i,3)-(bodyno-1)*6)<1)|((Xs(i,3)-(bodyno-1)*6)>6))
        %             Xss(i-out,:) = [];
        %             out = out + 1;
        %         else
        %             Xss(i-out,2) = Xs(i,2)-(bodyno-1)*6;
        %             Xss(i-out,3) = Xs(i,3)-(bodyno-1)*6;
        %         end
        %     end
        %     Xs = Xss;
        % end
        %end shrinking of multiple body file for single body


    % %remove lines that are not needed if single body
    % if (bodyno~=0)
    %     out = 0;
    %     Xss = Xs;
    %     for i=1:length(Xs)
    %         if(((Xs(i,3)-(bodyno-1)*6)<1)|((Xs(i,3)-(bodyno-1)*6)>6))
    %             Xss(i-out,:) = [];
    %             out = out + 1;
    %         else
    %             Xss(i-out,3) = Xs(i,3)-(bodyno-1)*6;
    %         end
    %     end
    %     Xs = Xss;
    % end

    %     %remove lines that are not needed if single body
    % if (bodyno~=0)
    %     Xss = Xs;
    %     for i=1:length(Xs)
    %         if(((Xs(i,3)-(bodyno-1)*6)<1)|((Xs(i,3)-(bodyno-1)*6)>6))
    %             Xss(i-out,:) = [];
    %             out = out + 1;
    %         else
    %             Xss(i-out,3) = Xs(i,3)-(bodyno-1)*6;
    %         end
    %     end
    %     Xs = Xss;
    % end
    % %end shrinking of multiple body file for single body
   % %remove lines that are not needed if single body
   %  if (bodyno~=0)
   %      warndlg('Wamit Option 8 for double bodies yield Drift force on complete system','!! Warning !!')
   %      waitforbuttonpress
   %  end
   %  %end shrinking of multiple body file for single body
    % %remove lines that are not needed if single body
    % if (bodyno~=0)
    %     out = 0;
    %     Xss = Xs;
    %     for i=1:length(Xs)
    %         if(((abs(Xs(i,4))-(bodyno-1)*6)<1)|((abs(Xs(i,4))-(bodyno-1)*6)>6))
    %             Xss(i-out,:) = [];
    %             out = out + 1;
    %         else
    %             Xss(i-out,4) = Xs(i,4)-sign(Xs(i,4))*(bodyno-1)*6;
    %         end
    %     end
    %     Xs = Xss;
    % end
    % %end shrinking of multiple body file for single body
