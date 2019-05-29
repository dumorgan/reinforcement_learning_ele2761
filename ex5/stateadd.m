function xP = stateadd(x, d)
%STATEADD Adds a difference to a pendulum state.
%   XP = STATEADD(X, D) adds difference D to pendulum state X to get next
%   state XP, wrapping the angle if necessary.
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

    xP = x + d;
    xP(1) = mod(xP(1)+pi, 2*pi)-pi;

end
