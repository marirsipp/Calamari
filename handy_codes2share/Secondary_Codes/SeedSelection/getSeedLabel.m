function ystr=getSeedLabel(varname)
if strcmp(varname,'basebendRXY')
    ystr={'Basebend Planar Moment (N-m)'};
elseif strcmp(varname,'basebendXY')
    ystr={'Basebend Planar Force (N)'};
elseif strcmp(varname,'basebend')
    ystr={'Basebend Force in Surge (N)' ,'Basebend Force in Sway (N)' ,'Basebend Force in Heave (N)' ,'Basebend Moment in Roll (N-m)' ,'Basebend Moment in Pitch (N-m)','Basebend Moment in Yaw (N-m)'}  ;
elseif strcmp(varname,'motionsRXY')
    ystr={'Roll-Pitch Magnitude (deg)'};
elseif strcmp(varname,'motionsXY')
    ystr={'Surge-Sway Magnitude (m)'};
elseif strcmp(varname,'motions')
    ystr={'Surge (m) ','Sway (m) ','Heave (m) ', 'Roll (deg)', 'Pitch (deg)', 'Yaw (deg)'};
elseif strcmp(varname,'accel')
    ystr={'platform Acceleration in Surge (m/s^2)','platform Acceleration in Sway (m/s^2)','platform Acceleration in Heave (m/s^2),','platform Acceleration in roll (degs/s^2)','platform Acceleration in Pitch (degs/s^2)','platform Acceleration in Yaw (degs/s^2)'};
elseif strcmp(varname,'naccel')
    ystr={'Nacelle Acceleration in Surge (m/s^2)','Nacelle Acceleration in Sway (m/s^2)','Nacelle Acceleration in Heave (m/s^2)'};
elseif strcmp(varname,'thrust')
    ystr={'Thrust Force in Rotor Plane (N)','Thrust Force in Perpendicular Plane (N)','Thrust Force in Rotor Plane (N)','Thrust Force in Rotor Plane (N)','Thrust Force in Rotor Plane (N)','Thrust Force in Rotor Plane (N)'};
elseif strcmp(varname,'thrustXY')
    ystr={'Thrust Force Magnitude in Horizontal Plane (N)'};
elseif strcmp(varname,'naccelXY')
    ystr={'Surge-Sway Nacelle Acceleration Magnitude (m/s^2)'};
elseif strcmp(varname,'naccel_norotXY')
    ystr={'Surge-Sway Nacelle Acceleration Magnitude (nacelle frame) (m/s^2)'};    
elseif strcmp(varname,'MaxAnchorEffT')
    ystr={'Max Anchor In-Line Tension (N)'};
else
    ystr={'','','','','',''};
end
end