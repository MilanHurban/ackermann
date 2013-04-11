function [robot, target] = calculatePoints(robot, target)

% transformation matrix
robot.C = [cos(robot.fi), -sin(robot.fi); sin(robot.fi), cos(robot.fi)];

% wheel positions
robot.fr = robot.C * [robot.size.length; -robot.size.width/2] + [robot.x; robot.y];
robot.fl = robot.C * [robot.size.length; robot.size.width/2] + [robot.x; robot.y];
robot.rl = robot.C * [0; robot.size.width/2] + [robot.x; robot.y];
robot.rr = robot.C * [0; -robot.size.width/2] + [robot.x; robot.y];

% centre of mass position (in the middle)
robot.com = (robot.rl + robot.rr + robot.fl + robot.fr) / 4;

% reference point position (between rear wheels)
robot.cora = (robot.rl + robot.rr) / 2;

% % robot body point positions
robot.body = makeBody(robot.size.length, robot.size.width, robot.size.radius, robot.size.wheelwidth, robot.x, robot.y, robot.C);

% turning radius of the reference point
robot.r = robot.size.length/tan(robot.psi);

% robot wheel point positions
[robot.frpoints, robot.frangle, robot.frradius] = makeFrontWheel(robot.fr, robot.fi, robot.psi, -1, robot.size, robot.r);    % -1 for right wheel
[robot.flpoints, robot.flangle, robot.flradius] = makeFrontWheel(robot.fl, robot.fi, robot.psi, +1, robot.size, robot.r);      % +1 for left wheel
robot.rlpoints = makeRearWheel(robot.rl, robot.C, robot.size.radius, robot.size.wheelwidth);
robot.rrpoints = makeRearWheel(robot.rr, robot.C, robot.size.radius, robot.size.wheelwidth);

robot.rlradius = abs(robot.r - robot.size.width/2);
robot.rrradius = abs(robot.r + robot.size.width/2);

% robot steering lines
robot.frline = makeLine(robot.fr, robot.frangle);
robot.flline = makeLine(robot.fl, robot.flangle);
robot.rearline = makeLine([robot.x; robot.y], robot.fi);

% long lines
robot.line = makeLongLine([robot.x, robot.y], robot.fi);
target.line = makeLongLine([target.x, target.y], target.angle);

% center of the turning radius
robot.cor = robot.C * [0; robot.r] + [robot.x; robot.y];

% circular trajectory
robot.ccircle = makeCircle(robot.cor, robot.r, robot.fi, [robot.x; robot.y]);

% desired target distance circle
target.ddcircle = makeCircle([target.x, target.y], robot.dd, robot.fi, [robot.x; robot.y]);