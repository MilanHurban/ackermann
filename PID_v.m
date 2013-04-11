function [output, e] = PID_v(distance, desired, v, vmax, pidv, angle)

e(3) = pidv.e(2);
e(2) = pidv.e(1);
e(1) = distance - desired;

output = v + pidv.g0*e(1) - pidv.g1*e(2) + pidv.g2*e(3);

vmaxnew = vmax;

if (angle > pi/4) | (angle < -pi/4)
    vmaxnew = 2;
end

if output > vmaxnew
    output = vmaxnew;
elseif output < -vmaxnew
    output = -vmaxnew;
end