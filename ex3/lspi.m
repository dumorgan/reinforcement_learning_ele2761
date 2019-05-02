function [learner] = lspi(par)
    
    par = get_parameters(par);

    learner.theta = @discretize_position;
    learner.d_theta = @discretize_velocity;
    learner.voltage = @discretize_voltage;
    learner.features = @set_features;
    
    function par = get_parameters(par)
        par.epsilon = 0.05;      % Random action rate
        par.gamma = 0.99;     % Discount rate
        par.alpha = 0.2;        % Learning rate
        par.pos_states = 11;   % Position discretization
        par.vel_states = 11;   % Velocity discretization
        par.actions = 3;      % Action discretization
        par.batch_size = 10000;       % Batch Size
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

    function features = set_features()
        features = meshgrid(learner.theta, learner.d_theta, learner.voltage);
    end

    function batch = generate_batch()
        batch = zeros(batch_size, 3)
        for i=1:par.batch_size
           
        end
    end
end
