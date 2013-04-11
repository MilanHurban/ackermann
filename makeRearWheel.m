function [points] = makeRearWheel(pos, C, r, w)

points = [r, r, -r, -r; -w/2, w/2, w/2, -w/2];

points = C*points;
points(1, :) = points(1, :) + pos(1);
points(2, :) = points(2, :) + pos(2);