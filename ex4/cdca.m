% Compatible deterministic actor-critic reinforcement learning algorithm
% for solving the inverse pendulum task

function [learner] = cdca()
    par = get_parameters();

    learner.theta = discretize_position();
    learner.d_theta = discretize_velocity();
    learner.voltage = discretize_voltage();
    learner.features = set_centers();
    learner.centers = set_centers();
    learner.reward = @reward;
    
    function par = get_parameters()
        par.gamma = 0.9;     % Discount rate
        par.pos_states = 11;   % Position discretization
        par.vel_states = 11;   % Velocity discretization
        par.actions = 3;      % Action discretization
        par.num_episodes = 10;       % Batch Size
        par.time_steps = 100;
        par.alpha = 0.5;
        par.beta = 0.5;
        par.sigma = 1;
    end

    function theta = discretize_position()
        theta = linspace(-pi, pi, par.pos_states);
    end

    function d_theta = discretize_velocity()
        d_theta = linspace(-12*pi, 12*pi, par.vel_states);
    end
    
    function voltage = discretize_voltage()
        voltage = linspace(-3, 3, par.actions);
    end

    function centers = set_centers()
        [s1, s2] = meshgrid(learner.theta, learner.d_theta);
        centers = [s1(:) s2(:)];
    end

    function reward = reward(s, a)
        reward = - 5 * s(1).^2 - 0.1* s(2).^2 - a.^2;
    end

    function distances = compute_distances(s)
        distances = pdist2(s, learner.centers, 'seuclidean', [1 12]);
    end

    function features = compute_features(s)
        distances = compute_distances(s);
        features = normpdf(distances, 0, 1);
    end

    shape = size(learner.centers);
    theta = zeros(shape(1), 1);
    omega = zeros(shape(1), 1);
    v = zeros(shape(1), 1);
    
    for i=1:par.num_episodes
        s = [pi, 0];
        phi = compute_features(s);
        a = phi * theta + normrnd(0, 1);
        for t=1:par.time_steps
            s_prime = pendulum(s, a);
            r = learner.reward(s, a);
            a_prime = phi * theta + normrnd(0, 1);
            
            % this won't work, I don't know how Q should be computed
            delta = r + par.gamma * Q(s_prime, a_prime, omega) - Q(s, a, omega);
            omega = omega + par.alpha * delta * (a - phi * theta) * phi;
            v = v + par.alpha * delta * phi;
            theta = theta + par.belta * phi(s) * omega * phi(s);
            s = s_prime;
            a = a_prime;
        end
    end
end
