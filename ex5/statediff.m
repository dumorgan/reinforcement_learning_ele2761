function d = statediff(x, xP)
%STATEDIFF Calculates difference between pendulum states
%   D = STATEDIFF(X, XP) calculates the difference D between pendulum
%   states X and XP, unwrapping the angle if necessary.
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

    d = xP-x;
    
    if d(1) > pi
        d(1) = d(1) - 2*pi;
    elseif d(1) < -pi
        d(1) = d(1) + 2*pi;
    end

end
