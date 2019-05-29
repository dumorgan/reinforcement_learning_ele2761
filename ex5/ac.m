function [ep, rt, network] = ac
%State-value actor-critic for the pendulum.
%   [EP, RT] returns the end performance and rise time of state-value
%   actor-critic on the underactuated pendulum swing-up.
%
%   AUTHOR:
%      Wouter Caarls <wouter@caarls.org>

    % General initialization
    alpha = 0.2;
    beta = 0.01;
    gamma = 0.99;
    hidden_units = 10;
    
    % Get feature vector size
    sz = numel(feature([0 0]));
    
    % Initialize features
    theta = randn(sz, 1);
    w = randn(sz, 1);
    
    curve = zeros(1, 100);
    b = zeros(100, 3);
    sigma = 1;
    
    state_action = zeros(3, size(b, 1));
    next_state = zeros(2, size(b, 1));
    
    function net = init_net(features, targets)
        net = feedforwardnet(hidden_units);
        net = configure(net, features, targets);
    end
    
    function batch = generate_examples(num_episodes)
        % five columns for angle, velocity, action, next angle and next
        % velocity
        pos = rand() * 2 * pi - pi;
        vel = rand() * 24 * pi - 12 * pi;
        action = rand() * 6 - 3;
        for episode=1:num_episodes
            
        end
    end

    function test_network = test_network(net)
        num_examples = 100;
        input_examples = generate_examples(num_examples);
        
    end

    network = init_net(state_action, next_state);
    % Episodes
    for ee = 1:numel(curve)
        sigma = sigma*0.99;
        
        x = [pi, 0];
        fx = feature(x);
        
        for ii=1:size(b, 1)
            % Choose action
            actor_u = fx'*theta;
            u = actor_u+randn*sigma;
            
            b(ii, 1:2) = x;
            b(ii, 3) = u;
                        
            % Get next state
            xP = pendulum(x, u);
            fxP = feature(xP);
            
            % save transitions to train the network
            state_action(1:2, ii) = x;
            state_action(3, ii) = u;
            next_state(1:2, ii) = xP;
            
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
        network = train(network, state_action, next_state);
        if (rem(ee, 10) == 0)
            subplot(2, 2, 3);
            plot(curve);
            subplot(2, 2, 4);
            x = 1:size(b, 1);
            plot(x, b(:,1), x, b(:, 2), x, b(:, 3));
            axis([0 size(b, 1) -10 10]);
            drawnow;
        end
        
        if (rem(ee, 100) == 0)
            plotip(theta, w, @feature);
        end
    end
    
    ep = mean(curve(end-10:end));
    
    reached = curve > -1000;
    reached3 = reached(1:end-2) + reached(2:end-1) + reached(3:end) == 3;
    rt = find(reached3, 1);
    
    function phi = feature(x)
        phi = gaussrbf(x, 11, 0.5);
    end

end
