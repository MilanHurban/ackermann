function [points] = makeBody(l, w, r, ww, x, y, C)

points = zeros(2, 12);

points(1, :) = [l + r, l + r, l - r, l - 3*r, 1.5*r, 1.5*r, -r, -r, 1.5*r,1.5*r, l - 3*r, l - r];
points(2, :) = [-w/2 + 1.5*ww, w/2 - 1.5*ww, w/2 - 1.5*ww, w/2, w/2, w/2 - 1.5*ww, w/2 - 1.5*ww, -w/2 + 1.5*ww, -w/2 + 1.5*ww, -w/2, -w/2, -w/2 + 1.5*ww];

points = C * points;

points(1, :) = points(1, :) + x;
points(2, :) = points(2, :) + y;