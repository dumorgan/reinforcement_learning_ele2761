function phi = gaussrbf(x, res, sigma)
%GAUSSRBF Gaussian RBF features.
%   PHI = GAUSSRBF(X) calculates the Gaussian RBF feature vector of the
%   two-dimensional or three-dimensional state X = [THETA, DTHETA] or
%   X = [THETA, DTHETA, U].
%   PHI = GAUSSRBF(X, RES) additionally specifies the number of basis
%   functions per dimension RES. The number of basis functions for U is
%   always 5.
%   PHI = GAUSSRBF(X, RES, SIGMA) additionally specifies the width of the
%   basis functions SIGMA.
%
%   X may also be a NxM matrix, in which case a RES^MxN feature matrix
%   is returned. 2 <= M <= 3.
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

    persistent cp2 cv2 cp3 cv3 ca cres;
    
    % Defaults
    if nargin < 3
        sigma = 0.5;
    end
    if nargin < 2
        res = 11;
    end
    
    % Rebuild if resolution changes
    if res ~= cres
      cp2 = [];
      cp3 = [];
    end
    
    % Initialize RBF centers
    if size(x, 2) == 2
        if isempty(cp2)
            [cp2, cv2] = meshgrid(linspace(-pi, pi, res), ...
                                  linspace(-12*pi, 12*pi, res));
            cp2 = cp2(:);
            cv2 = cv2(:);
        end
    elseif size(x, 2) == 3
        if isempty(cp3)
            [cp3, cv3, ca] = meshgrid(linspace(-pi, pi, res), ...
                                      linspace(-12*pi, 12*pi, res), ...
                                      linspace(-3, 3, 5));
            cp3 = cp3(:);
            cv3 = cv3(:);
            ca = ca(:);
        end
    else
        error('State must have between 2 and 3 dimensions');
    end
    
    cres = res;
    
    % Calculate distances to centers
    if size(x, 2) == 2
        dist = sqrt(bsxfun(@minus, cp2, x(:, 1)').^2 + (bsxfun(@minus, cv2, x(:, 2)')/12).^2);
    else
        x(x(:,3)>3, 3) = 3;
        x(x(:,3)<-3, 3) = -3;
        dist = sqrt(bsxfun(@minus, cp3, x(:, 1)').^2 + (bsxfun(@minus, cv3, x(:, 2)')/12).^2 + (bsxfun(@minus, ca, x(:, 3)')).^2);
    end
    
    % Gaussian RBFs
    phi = normpdf(dist, 0, sigma);
    
    % Normalize to squared norm
    phi = bsxfun(@rdivide, phi, sum(phi.^2, 1));
end
