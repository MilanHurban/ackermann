function [output, e] = PI_psi(angle, psi, pipsi, psimax, v, fi)

e(2) = pipsi.e(1);
e(1) = atan2(sin(angle - fi), cos(angle - fi));

e(1) = atan2(sin(e(1)), cos(e(1)));

if v < 0
    e(1) = -e(1);
end

output = psi + pipsi.g0*e(1) - pipsi.g1*e(2);

psimaxnew = psimax * 0.7/ abs(v);

if psimaxnew > psimax
    psimaxnew = psimax;
end

if output > psimaxnew
    output = psimaxnew;
elseif output < -psimaxnew
    output = -psimaxnew;
end