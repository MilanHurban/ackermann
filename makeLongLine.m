function line = makeLongLine(pos, angle);

line = [-100, 100; 0, 0];

C = [cos(angle), -sin(angle); sin(angle), cos(angle)];

line = C*line;

line(1, :) = line(1, :) + pos(1);
line(2, :) = line(2, :) + pos(2);