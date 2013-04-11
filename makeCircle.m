function circle = makeCircle(pos, r, angle, robpos);

if abs(r) >= 500
    circle = [20, -20; 0, 0];
    C = [cos(angle), -sin(angle); sin(angle), cos(angle)];
    
    circle = C*circle;
    
    circle(1, :) = circle(1, :) + robpos(1);
    circle(2, :) = circle(2, :) + robpos(2);
    
else
    if abs(r) < 1
        t = linspace(0, 2*pi, 16);
    elseif abs(r) < 5
        t = linspace(0, 2*pi, 64);
    else
        t = linspace(0, 2*pi, 128);
    end
    
    circle = [r*cos(t); r*sin(t)];
    
    circle(1, :) = circle(1, :) + pos(1);
    circle(2, :) = circle(2, :) + pos(2);
end