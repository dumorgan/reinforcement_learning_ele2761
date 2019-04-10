function xp = pendulum(x, u)
%PENDULUM Inverted pendulum system
%   XP = PENDULUM(X, U) returns the next state XP of the pendulum using
%   previous state X = [THETA, DTHETA] and action U = [MOTOR_VOLTAGE]
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

    xp = transition(@ipdynamics, x, u);
    xp(1) = mod(xp(1)+pi, 2*pi)-pi;
end
