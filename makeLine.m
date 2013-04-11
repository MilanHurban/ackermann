function line = makeLine(pos, angle);

line = [0, 0; 1, -1];

C = [cos(angle), -sin(angle); sin(angle), cos(angle)];

line = C*line;

line(1, :) = line(1, :) + pos(1);
line(2, :) = line(2, :) + pos(2);