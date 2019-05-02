function [learner] = lspi()
    par = get_parameters();

    learner.theta = discretize_position();
    learner.d_theta = discretize_velocity();
    learner.voltage = discretize_voltage();
    learner.features = set_centers();
    learner.batch = generate_batch();
    learner.reward = reward();
    learner.policy = set_policy();
    learner.centers = set_centers();
    
    function par = get_parameters()
        par.gamma = 0.9;     % Discount rate
        par.pos_states = 11;   % Position discretization
        par.vel_states = 11;   % Velocity discretization
        par.actions = 3;      % Action discretization
        par.batch_size = 10000;       % Batch Size
        par.iterations = 10;
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
        [s1, s2, a] = meshgrid(learner.theta, learner.d_theta, learner.voltage);
        centers = [s1(:) s2(:) a(:)];
    end

    function batch = generate_batch()
        % five columns for angle, velocity, action, next angle and next
        % velocity
        batch = rand(par.batch_size, 5);
        batch(:, 1) = batch(:, 1) * 2* pi - pi;
        batch(:, 2) = batch(:, 2) * 24* pi - 12 * pi;
        batch(:, 3) = batch(:, 3) * 6 - 3;
        for i=1:par.batch_size
            sp = pendulum(batch(i, 1:2), batch(i, 3)); 
            batch(i, 4) = sp(1);
            batch(i, 5) = sp(2);
        end
    end
    function reward = reward()
        batch = learner.batch;
        reward = - 5 * (batch(:, 4).^2) - 0.1* (batch(:, 5).^2) - batch(:, 3).^2;
    end

    function policy = set_policy()
        policy = rand(par.batch_size, 1) * 6 - 3;
    end

    function distances = compute_distances(s, a)
        examples = [s, a];
        distances = pdist2(examples, learner.centers, 'seuclidean', [1 12 1]);
    end

    function features = compute_features(distances)
        features = normpdf(distances);
    end

    function policy = policy_iteration(n)
        policy = learner.policy;
        for i=1:n
            examples = learner.batch;
            state = examples(:, 1:2);
            action = examples(:, 3);
            phi_current = compute_features(compute_distances(state, action));
            
            next_state = examples(:, 4:5);
            scatter(next_state(:, 1), next_state(:, 2), 10, policy);
            drawnow;
            next_action = policy;
            phi_next = compute_features(compute_distances(next_state, next_action));
            
            A = phi_current - par.gamma * phi_next;
            theta = A \ learner.reward;
            
            td = zeros(par.batch_size, 3);
            for action=1:par.actions
                phi = compute_features(compute_distances(next_state, learner.voltage(action) + zeros(par.batch_size, 1)));
                phi = phi * theta;
                td(:, action) = phi;
            end
            [maxval, argmax] = max(td, [], 2);
            policy = (argmax - 2) * 3;
        end
    end

    learner.resulting_policy = policy_iteration(par.iterations);
end
