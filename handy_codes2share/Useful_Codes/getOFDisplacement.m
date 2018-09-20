function X=getOFDisplacement(WindFloat,t,position,X6,DOF)
tstartcut=t(1);
tend=t(2);
if strcmp(WindFloat.typeName,'Vessel')
    if DOF<3
       % Must rotate (into platform coords), translate and unrotate back
       % into global
       XY = [WindFloat.TimeHistory('X',ofx.Period(tstartcut,tend),ofx.oeVessel(position))'  WindFloat.TimeHistory('Y',ofx.Period(tstartcut,tend),ofx.oeVessel(position))' ];
       nt = size(XY,1);
       XYr= Rotate2DMat(XY,-X6*pi/180);
       XYd = XYr - repmat(position(1:2),[nt 1]);
       XY= Rotate2DMat(XYd,X6*pi/180);
    end
    switch DOF
        case 1
            X = XY(:,1);
        case 2
            X = XY(:,2);
        case 3
            X = WindFloat.TimeHistory('Z',ofx.Period(tstartcut,tend),ofx.oeVessel(position))- position(3);
        case 4
            X = WindFloat.TimeHistory('Rotation 1',ofx.Period(tstartcut,tend),ofx.oeVessel(position));
        case 5
            X = WindFloat.TimeHistory('Rotation 2',ofx.Period(tstartcut,tend),ofx.oeVessel(position));
        case 6
            X = WindFloat.TimeHistory('Rotation 3',ofx.Period(tstartcut,tend),ofx.oeVessel(position));
    end
elseif strcmp(WindFloat.typeName,'6D Buoy')
    switch DOF
        case 1
            X = WindFloat.TimeHistory('X',ofx.Period(tstartcut,tend),ofx.oeBuoy(position)) - position(1);
        case 2
            X = WindFloat.TimeHistory('Y',ofx.Period(tstartcut,tend),ofx.oeBuoy(position)) - position(2);
        case 3
            X = WindFloat.TimeHistory('Z',ofx.Period(tstartcut,tend),ofx.oeBuoy(position)); %its at the waterline
        case 4
            X = WindFloat.TimeHistory('Rotation 1',ofx.Period(tstartcut,tend),ofx.oeBuoy(position));
        case 5
            X = WindFloat.TimeHistory('Rotation 2',ofx.Period(tstartcut,tend),ofx.oeBuoy(position));
        case 6
            X = WindFloat.TimeHistory('Rotation 3',ofx.Period(tstartcut,tend),ofx.oeBuoy(position));
    end
end
end