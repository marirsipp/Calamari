function angle2 = AngleShift(angle)

if angle > 180
    angle2=angle-360;
elseif    angle < -180
    angle2=angle+360;
else
    angle2=angle;

end
end
