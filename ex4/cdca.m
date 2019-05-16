% Compatible deterministic actor-critic reinforcement learning algorithm
% for solving the inverse pendulum task

function [learner] = cdca()
    par = get_parameters();
    learner.reward = @reward;
    
    function par = get_parameters()
        par.gamma = 0.9;     % Discount rate
        par.pos_states = 11;   % Position discretization
        par.vel_states = 11;   % Velocity discretization
        par.actions = 3;      % Action discretization
        par.num_episodes = 1000;    
        par.time_steps = 100;
        par.alpha = 0.2;
        par.beta = 0.001;
        par.ni = 0.0001;
        par.exploration_rate = 1;
    end

    function reward = reward(s, a)
        reward = - 5 * s(1).^2 - 0.1* s(2).^2 - a.^2;
    end

    function adv = advantage_function(phi_s, theta, a, w)
        policy = phi_s' * theta;
        adv = (a - policy) * phi_s' * w;
    end

    function value_state = value_state_function(phi_s, v)
        value_state = phi_s' * v;
    end
    
    function phi = compute_phi(x)
        phi = gaussrbf(x, par.pos_states, 1);
    end

    shape = par.pos_states * par.vel_states;
   
    theta = zeros(shape, 1);
    w = rand(shape, 1);
    v = rand(shape, 1);
    total_reward = zeros(par.num_episodes, 1);
    for i=1:par.num_episodes
        s = [pi, 0];
        phi = compute_phi(s);
        a = phi' * theta + normrnd(0, par.exploration_rate);
        for t=1:par.time_steps
            r = learner.reward(s, a);
            total_reward(i) = total_reward(i) + r;
            s_prime = pendulum(s, a);
            phi_prime = compute_phi(s_prime);
            a_prime = phi_prime' * theta + normrnd(0, par.exploration_rate);
            
            Q_prime = advantage_function(phi_prime, theta, a_prime, w) + ...
                value_state_function(phi_prime, v);
            
            Q = advantage_function(phi, theta, a, w) + ... 
                value_state_function(phi, v);
            
            delta = r + par.gamma * Q_prime - Q;
            w = w + par.alpha * delta * (a - phi' * theta) * phi;
            v = v + par.alpha * delta * phi;
            theta = theta + par.beta * phi' * w * phi;
            theta = min(max(theta, -3), 3);
            s = s_prime;
            a = a_prime;
            phi = compute_phi(s);
        end
        plotip(theta, v);
        subplot(2, 2, 3);
        plot(1:i, total_reward(1:i));
        title('Accumulated reward per episode');
        xlabel('Episode');
        ylabel('Accumulated reward');
        drawnow;
        par.exploration_rate = par.exploration_rate * (1 - par.ni);
    end
end
