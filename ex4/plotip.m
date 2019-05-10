function plotip(theta, w, feature)
%PLOTIP Plot inverted pendulum value function and policy
%   PLOTIP(THETA) plots the inverted pendulum policy from the parameter
%   vector THETA.
%   PLOTIP(THETA, W) additionally plots the value function from the
%   parameter vector W
%   PLOTIP(THETA, W, FEATURE) specifies the feature projection FEATURE.
%   Otherwise, @gaussrbf is used with default parameters.
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

    if nargin < 3
        feature = @gaussrbf;
    end
    if nargin < 2
        w = [];
    end

    [pos, vel] = meshgrid(linspace(-pi, pi, 51), ...
                          linspace(-12*pi, 12*pi, 51));

    s = [pos(:), vel(:)];
    phi = feature(s);
    p = phi'*theta;
    subplot(2, 2, 2);
    surf(reshape(s(:, 1), 51, 51), reshape(s(:, 2), 51, 51), reshape(p, 51, 51));
    shading interp
    axis([-pi pi -12*pi 12*pi])
    colormap jet
    colorbar
    
    if ~isempty(w)
        if numel(w) == numel(theta)
            v = phi'*w;
        else
            s = [pos(:), vel(:), p];
            phi = feature(s);
            v = phi'*w;
        end
    
        subplot(2, 2, 1);
        surf(reshape(s(:, 1), 51, 51), reshape(s(:, 2), 51, 51), reshape(v, 51, 51));
        shading interp
        axis([-pi pi -12*pi 12*pi])
        colormap jet
        colorbar
    end
    
end
