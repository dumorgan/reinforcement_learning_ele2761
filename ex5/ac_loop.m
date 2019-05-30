function [theta, w, state_action, next_state, b, curve, fx, x, sigma] = ...
     ac_loop(transition_function, feature, x, fx, b, state_action, next_state, ee, theta, w, curve, sigma, ii, gamma, beta, alpha)
    actor_u = fx'*theta;
    u = actor_u+randn*sigma;

    b(ii, 1:2) = x;
    b(ii, 3) = u;
    s = zeros(3, 1);
    s(1:2) = x;
    s(3) = u;
    % Get next state
    xP = transition_function(s);
    fxP = feature(xP');

    % save transitions to train the network
    state_action(1:2, ii, ee) = x;
    state_action(3, ii, ee) = u;
    next_state(1:2, ii, ee) = xP;
    % Calculate reward
    r = -5*xP(1)^2-0.1*xP(2)^2-1*u^2;
    curve(ee) = curve(ee) + r;

    % TD error
    delta = r + (gamma*fxP - fx)'*w;

    % Update critic
    w = w + alpha*delta*fx;

    % Update actor
    theta = min(max(theta + beta*(u-actor_u)*delta*fx, -3), 3);

    x = xP;
    fx = fxP;
end            
% Choose action
