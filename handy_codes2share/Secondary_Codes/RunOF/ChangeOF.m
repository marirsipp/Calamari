function WindFloat=ChangeOF(WindFloat,WindFloatType,Lines,TurbineLineNames,FAST_Flag)
% change a dat file from orcaFLEX to orcaFAST or vice-versa
if isempty(WindFloat)
   error('No Vessel found in datfile. Either insert a Vessel or set FAST_Flag to 0.') 
end

OrcaDrag='drag'; % end of line name for OrcaFlex 
FASTDrag='drag0';% end of line name for OrcaFAST 
oldtype=WindFloatType.name;
suffix=oldtype(end-3:end); 
% 

if FAST_Flag
% changes:
    WindFloat.PrimaryMotion='Externally Calculated';
%just to make sure:
    WindFloat.ExternallyCalculatedPrimaryMotion='ExtFn';
    WindFloat.IncludedInStatics='None';
    
    if ~strcmp(suffix,'FAST')
        %you probably have an OrcaFlex model saved
        newtype=[oldtype '_FAST'];
    else
        %you probably already have a FAST model
        newtype=oldtype;
    end
    try 
        WindFloat.VesselType=newtype;
    catch
        error(['Attemping to change vessel type to run FAST. Vessel Type:' newtype ' does not exist. Please create a vesseltype with turbine properties removed called: foo_FAST'])
    end
    changeTurbineDrag(Lines,TurbineLineNames,OrcaDrag,FASTDrag,FAST_Flag)
else
    if strcmp(suffix,'FAST')
        newtype=oldtype(1:end-5);
    else
        warning('Platform Type not properly named. The OrcaFAST vessel type should be named identically to the OrcaFlex vessel type with "_FAST" at the end')
        newtype=oldtype;
    end
    try 
        WindFloat.VesselType=newtype;
    catch
        error(['Attempting to change vessel type to run OrcaFlex. Vessel Type:' newtype ' does not exist. Please create a vesseltype with turbine properties included.'])
    end
    WindFloat.PrimaryMotion='Calculated (6 DOF)';
%just to make sure:
    %WindFloat.IncludedInStatics='None';
    WindFloat.IncludedInStatics='6 DOF';
    changeTurbineDrag(Lines,TurbineLineNames,FASTDrag,OrcaDrag,FAST_Flag)
end
%modelout.SaveData(datfileout); %overwrite original dat file
end

function changeTurbineDrag(Lines,TurbineLineNames,oldDrag,newDrag,iFAST)
nLines=length(Lines);
% go through all the lines and search for blades or tower and switch to
% no drag
for pp=1:nLines
    pL=Lines{pp};
    if any(strncmp(pL.Name,TurbineLineNames,min(cellfun(@(c) length(c),TurbineLineNames)))); 
        for ss=1:pL.NumberOfSections
            sLT=pL.LineType(ss);
            if strcmp(sLT(end-length(oldDrag)+1:end),oldDrag)
               % if you have Orca drag, then try to switch to FAST drag
               basename=sLT(1:end-length(oldDrag));
               newLineType=[basename newDrag];
               try
                   pL.LineType(ss)=newLineType;
                   if iFAST
                    disp(sprintf( 'Changing Section %d of %s line to LineType %s for a FAST run',ss,pL.Name,newLineType))
                   else
                       disp(sprintf( 'Changing Section %d of %s line to LineType %s for a Flex run',ss,pL.Name,newLineType))
                   end
               catch
                   if iFAST
                        warning(['FAST line type not found. Please make a line type called ' newLineType ' so that drag is NOT applied properly'])
                   else
                       warning(['OrcaFlex line type not found. Please make a line type called ' newLineType ' so that drag is applied properly'])
                   end
               end
            end
        end
    end
end

end