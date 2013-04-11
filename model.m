close all
clear all
clc

% profile on;

%% robot settings

robot.size.length = 0.27;            % distance between axles
robot.size.width = 0.25;             % distance between wheels on one axle
robot.size.radius = 0.05;           % wheel radius
robot.size.wheelwidth = 0.05;   % wheel width

% robot.size.rmin = 0.52;              % radius of the tightest possible turn
%
% robot.size.anglimit =  atan2(robot.size.length, robot.size.rmin + robot.size.width/2);
% % maximum wheel turning angle in either direction

robot.x = 1;                                          % initial X position
robot.y = 5;                                             % initial Y position
robot.v = 0;                                             % initial velocity
robot.a = 0;                                                % initial acceleration

robot.vmax = 11;                                        % maximum velocity (11 m/s, about 40 km/h)

robot.fi = 0 * pi/180;                                  % initial angle
robot.fidot = 0;                                            % initial angular velocity

robot.psi = 2 * pi/180;                             % initial turning angle
robot.psidot = 0;                                       % initial turning angular velocity
robot.psidotdot = 0;                                  % initial turning angular acceleration

robot.psimax = 22 * pi/180;                     % turning angle limitation (22 degrees empirically)
robot.psidotmax = 2;                                % turning angular velocity limitation (about 2 rad/s empirically)

robot.r = robot.size.length/tan(robot.psi);  % initial turning radius (negative => turning to the right)

robot.dt = 0.01;          % time sampling
T = 0;                            % initial time

robot.dd = 2; % the desired distance from a target

%% target object
target.x = 16;
target.y = 5;
target.angle = atan2(target.y - robot.y, target.x - robot.x);
target.distance = calculateDistance([target.x, target.y], [robot.x, robot.y]);

% first position and rotation calculations
[robot, target] = calculatePoints(robot, target);

%% PI regulator of the angle

% robot.fid = 45 * pi/180; % desired fi value

% PI gain constants (best values in comments)
pipsi.kp = 2;
pipsi.ki = 10;

% PI time constants
pipsi.taui = 1/pipsi.ki;

% time step
pipsi.dt = robot.dt;

% PI constants for iterative calculation
pipsi.g0 = pipsi.kp + pipsi.dt/pipsi.taui;
pipsi.g1 = pipsi.kp;

% initial error vector ([k], [k-1])
error = atan2(sin(target.angle - robot.fi), cos(target.angle - robot.fi));
pipsi.e = [error, error];

%% PID regulator of the velocity

% PID gain constants (best values in comments)
pidv.kp = 2; % 2
pidv.ki = 1; % 1
pidv.kd = 5; % 5

% PID time constants
pidv.taui = 1/pidv.ki;
pidv.taud = 1/pidv.kd;

% time step
pidv.dt = robot.dt;

% PID constants for iterative calculation
pidv.g0 = pidv.kp + pidv.dt/pidv.taui + pidv.taud/pidv.dt;
pidv.g1 = pidv.kp + 2*pidv.taud/pidv.dt;
pidv.g2 = pidv.taud/pidv.dt;

% initial error vector ([k], [k-1], [k-2])
error_v = target.distance - robot.dd;
pidv.e = [error_v, error_v, error_v];

%% basic plot
map.figure = figure('color','white');
set(map.figure, 'Position', [100 50 1400 700]);
hold on;
axis off;

% fixed map dimensions
map.w = 20;
map.h = 10;
map.x = [0 map.w map.w 0 0];
map.y = [0 0 map.h map.h 0];

map.border = area(map.x, map.y, 'facecolor',[0.9,0.9,0.9]);

map.size = 1; % how large the plot around the robot is

% axis equal;
% axis([robot.x - map.size, robot.x + map.size, robot.y - map.size, robot.y + map.size]);

axis equal;
axis tight;


%% first robot plot

% target object
map.target = plot(target.x, target.y, 'o', 'Color', 'r', 'MarkerSize', 15,'MarkerFaceColor', 'r');

% car body shape
map.body = fill(robot.body(1, :), robot.body(2, :), 'w');

% center of mass marker
map.com = plot(robot.com(1), robot.com(2), 'o', 'Color', 'k', 'MarkerSize', 5,'MarkerFaceColor', 'k');

% center of the rear axle marker
map.cora = plot(robot.cora(1), robot.cora(2), 'o', 'Color', 'r', 'MarkerSize', 5,'MarkerFaceColor', 'r');

% wheel shapes
map.fr = fill(robot.frpoints(1, :), robot.frpoints(2, :), [1, 0.5, 0]);
map.fl = fill(robot.flpoints(1, :), robot.flpoints(2, :), [1, 0.5, 0]);
map.rl = fill(robot.rlpoints(1, :), robot.rlpoints(2, :), [0, 0.5, 1]);
map.rr = fill(robot.rrpoints(1, :), robot.rrpoints(2, :), [0, 0.5, 1]);

% wheel normals
map.frline = plot(robot.frline(1, :), robot.frline(2, :));
map.flline = plot(robot.frline(1, :), robot.frline(2, :));
map.rearline = plot(robot.rearline(1, :), robot.rearline(2, :));

map.targetline = plot(target.line(1, :), target.line(2, :), 'Color', [0, 0.5, 1]);
map.carline = plot(robot.line(1, :), robot.line(2, :), 'Color', [1, 0.5, 0]);

% center of the turning radius marker
map.cor = plot(robot.cor(1), robot.cor(2), 'o', 'Color', 'k', 'MarkerSize', 5,'MarkerFaceColor', 'k');

% text
map.text = text(robot.x - 1, robot.y - 1, ['Time elapsed: ', num2str(T), 's'], 'Fontsize', 20);

% circular trajectory
map.ccircle = plot(robot.ccircle(1, :), robot.ccircle(2, :), 'r');

% deisred target distance circle
map.ddcircle = plot(target.ddcircle(1, :), target.ddcircle(2, :), '.g');


%% main cycle
cnt = 0;
const = -1;
const2 = -1.5;
acc = -0.001;
acc2 = -0.001;

iks = [];
kips = [];
kroks = [];

neudelano = 1;

% profile on

while cnt >= 0
    
    stuck = 0;
    [robot.psi, pipsi.e] = PI_psi(target.angle, robot.psi, pipsi, robot.psimax, robot.v, robot.fi);
    [robot.v, pidv.e] = PID_v(target.distance, robot.dd, robot.v, robot.vmax, pidv, pipsi.e(1));
    
    [robot, target] = calculatePoints(robot, target);
    
    target.x = target.x + const2 * robot.dt; % + acc2 * target.x;
    target.y = target.y + const * robot.dt; % + acc * target.y;
    
    if target.y > 8 | target.y < 2
        const = -const;
        acc = -acc;
    end
    
    if target.x > 18 | target.x < 2
        const2 = -const2;
        acc2 = -acc2;
    end
    
    [robot, target] = refreshRobotData(robot, target);
    
    T = T + robot.dt;
    refreshPlotData(robot, map, T, target);
    
    iks = [iks, robot.fi];
    
    kips = [kips, robot.psi];
    
    kroks = [kroks, robot.v];
    
    pause(robot.dt);
    
    cnt = cnt + 1;
end

% figure;
% plot(1:length(iks), iks);
% 
% figure;
% plot(1:length(kips), kips);
% 
% figure;
% plot(1:length(kroks), kroks);

% profile report;