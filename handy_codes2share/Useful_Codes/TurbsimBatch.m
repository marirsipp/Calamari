%% Define WindSpeed vector
WS=1:41;
Intensity15 = .12;
a_coeff = 3;
stdwind = Intensity15*(15+a_coeff*WS)/(a_coeff+1);
TL = stdwind./WS*100;
WSeed=[1111:1:1116];
Letters=[{'A'},{'B'},{'C'},{'D'},{'E'},{'F'}];

TSdir='\\SUP\Longboard\SUP\WFJ_Hitachi5MW\Wind\TurbSim\';
for i=1:length(WS)
    
    for j=1:length(WSeed)
        
        %----------------------------------------------------------------------
        % Load in model data from the Turbim input files:
        %----------------------------------------------------------------------
        inputfile=[TSdir 'turbwindTemplate.inp'];
        FP = Fast2Matlab(inputfile,3); %FP are Fast Parameters, specify 4 lines of header
        
        %%  %----------------------------------------------------------------------
        % Write new model data to the Turbsim input files:
        %----------------------------------------------------------------------
        
        WindSpeed=WS(i); %m/s
        TurbLevel=TL(i);
        WindSEED=WSeed(j);
        
        FP.Val(1)={WindSEED};
        FP.Val(25)={[' " ' num2str(TurbLevel) ' " ']};
        FP.Val(30)={WindSpeed};
        
        outputFile = [TSdir 'turbwind' num2str(WindSpeed,'%02g')  char(Letters(j)) '.inp'];
        Matlab2FAST(FP,inputfile,outputFile, 3); %contains 2 header lines
        
        clear FP
        
        [status,result] = dos( ['TurbSim64.exe ' outputFile],'-echo') ;
    end
    
end