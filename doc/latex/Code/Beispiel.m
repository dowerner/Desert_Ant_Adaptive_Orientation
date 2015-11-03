function angle = vector2angle(v)

if abs(v(1))<10^(-5)
    %v(1)=sign(v(1))*10^(-4);
else
    
end
angle = atan(v(2)/v(1));
if v(1) < 0
    angle = angle+pi;
 end
end