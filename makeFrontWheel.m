function [points, angle, rad] = makeFrontWheel(pos, angle, turnangle, which, size, radius)

r = size.radius;
w = size.wheelwidth;
L = size.length;
W = size.width;
tr = abs(radius);

% calculating the angle of each wheel based on the angle of the central one
% if turnangle is zero, angle remains unchanged
if turnangle > 0
    angle = angle + atan2(L, tr  - which * W/2);
    
    % calculating the radius for the wheel
    rad = sqrt((tr - which * W/2)^2 + L^2);
    
elseif turnangle < 0
    angle = angle - atan2(L, tr + which * W/2);
    
    rad = sqrt((tr + which * W/2)^2 + L^2);

else
    rad = Inf;
    
end

C = [cos(angle), -sin(angle); sin(angle), cos(angle)];

points = [r, r, -r, -r; -w/2, w/2, w/2, -w/2];

points = C*points;
points(1, :) = points(1, :) + pos(1);
points(2, :) = points(2, :) + pos(2);