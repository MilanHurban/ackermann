function [robot, target] = refreshRobotData(robot, target)

robot.v = robot.v + robot.a * robot.dt;
robot.psidot = robot.psidot + robot.psidotdot * robot.dt;

% angular velocity
robot.fidot = robot.v / robot.r;

% turning angle limitation
if robot.psi > robot.psimax
    robot.psi = robot.psimax;
elseif robot.psi < -robot.psimax
    robot.psi = -robot.psimax;
end

robot.psi = robot.psi +robot.psidot*robot.dt;
robot.x = robot.x + robot.v*robot.dt*cos(robot.fi);
robot.y = robot.y + robot.v*robot.dt*sin(robot.fi);
robot.fi = robot.fi + robot.fidot*robot.dt;

target.angle = atan2(target.y - robot.y, target.x - robot.x);
target.distance = calculateDistance([target.x, target.y], [robot.x, robot.y]);

% converting into <-pi; pi> range
robot.fi = atan2(sin(robot.fi), cos(robot.fi));
robot.psi = atan2(sin(robot.psi), cos(robot.psi));