function [] = refreshPlotData(robot, map, T, target)

set(map.body, 'XData', robot.body(1, :), 'YData', robot.body(2, :));

set(map.com, 'XData', robot.com(1), 'YData', robot.com(2));
set(map.cora, 'XData', robot.cora(1), 'YData', robot.cora(2));

set(map.cor, 'XData', robot.cor(1), 'YData', robot.cor(2));
set(map.ccircle, 'XData', robot.ccircle(1, :), 'YData', robot.ccircle(2, :));

set(map.fr, 'XData', robot.frpoints(1, :), 'YData', robot.frpoints(2, :));
set(map.fl, 'XData', robot.flpoints(1, :), 'YData', robot.flpoints(2, :));
set(map.rl, 'XData', robot.rlpoints(1, :), 'YData', robot.rlpoints(2, :));
set(map.rr, 'XData', robot.rrpoints(1, :), 'YData', robot.rrpoints(2, :));

set(map.frline, 'XData', robot.frline(1, :), 'YData', robot.frline(2, :));
set(map.flline, 'XData', robot.flline(1, :), 'YData', robot.flline(2, :));
set(map.rearline, 'XData', robot.rearline(1, :), 'YData', robot.rearline(2, :));

set(map.carline, 'XData', robot.line(1, :), 'YData', robot.line(2, :));
set(map.targetline, 'XData', target.line(1, :), 'YData', target.line(2, :));

set(map.text, 'Position', [robot.x - 1, robot.y - 1], 'String', ['Time elapsed: ', num2str(T), 's']);

set(map.target, 'XData', target.x, 'YData', target.y);
set(map.ddcircle, 'XData', target.ddcircle(1, :), 'YData', target.ddcircle(2, :));

% axis([robot.x - map.size, robot.x + map.size, robot.y - map.size, robot.y + map.size]);

end