function drawcp(x, u);
%DRAWIP Draw inverted pendulum system
%   DRAWIP(X) draws the inverted pendulum system at state X.
%   
%   DRAWIP(X, U) additionally draws the actuation U.
%
%   AUTHOR
%      Wouter Caarls <wouter@caarls.org>

    persistent h
    
    if ~isempty(h)
        try
            delete(h);
        catch
        end
    end
    
    h = line([0, cos(x(1)+pi/2)], [0 sin(x(1)+pi/2)]);
    axis equal
    
    if nargin > 1
        ang = 2*pi*u/12;
        
        segment = linspace(0, ang, 10);
        
        xc = 0.25*cos(segment + x(1) + pi/2);
        yc = 0.25*sin(segment + x(1) + pi/2);
        
        h = [h; line(xc, yc, 'Color', 'r')];
    end
    
    axis([-1 1 -1 1]);

    drawnow;
end
