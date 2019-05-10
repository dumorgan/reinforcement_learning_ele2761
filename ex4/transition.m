function xp = transition(eom, x, u)
%TRANSITION Calculate transition from dynamics
%   XP = TRANSITION(EOM, X, U) generates the next state XP starting from
%   state X and applying actuation U by integrating the dynamics given by
%   EOM. EOM is a function handle taking X and U and returning XDOT.
%
%   EXAMPLE
%      xp = transition(@ipdynamics, x, u);
%
%   AUTHOR
%      Wouter Caarls <wouter@caarls.org>

    if any(~isfinite(x))
        error('Cowardly refusing to integrate invalid state');
    end
    
    if any(~isfinite(u))
        error('Cowardly refusing to integrate invalid action');
    end

    h = 0.05;

    % Trapezoid
    d1 = eom(x, u);
    xp = x + h*d1;
    d2 = eom(xp, u);
    xp = x + h*(d1+d2)/2;

end
