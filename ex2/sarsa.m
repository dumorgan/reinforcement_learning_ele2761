function [par, learner] = sarsa(par)

    par = get_parameters(par);
    Q = [];
    e = [];

    learner.get_Q = @get_Q;
    learner.init_Q = @init_Q;
    learner.init_trace = @init_trace;
    learner.discretize_state = @discretize_state;
    learner.execute_policy = @execute_policy;
    learner.observe_reward = @observe_reward;
    learner.is_terminal = @is_terminal;
    learner.update_Q = @update_Q;
    learner.take_action = @take_action;
    
    if isfield(par, 'Q')
        Q = par.Q;
    end

    function myQ = get_Q()
        myQ = Q;
    end

    function init_trace()
        e = zeros(size(Q));
    end

    % ******************************************************************
    % *** Edit below this line                                       ***
    % ******************************************************************
    
    function par = get_parameters(par)
        par.epsilon = 0.05;      % Random action rate
        par.gamma = 0.9;     % Discount rate
        par.alpha = 0.2;        % Learning rate
        par.pos_states = 31;   % Position discretization
        par.vel_states = 31;   % Velocity discretization
        par.actions = 3;      % Action discretization
        par.trials = 1000;       % Learning trials
        par.lambda = 0.5;
    end

    function init_Q()
        Q = 0.1 * ones(par.pos_states, par.vel_states, par.actions);
        Q(fix(par.pos_states/2), fix(par.vel_states/2), :) = 0;
    end

    function s = discretize_state(x)
        % TODO: Discretize state. Note: s(1) should be
        % TODO: position, s(2) velocity.
        s = [];
        s(1) = discretize(x(1), -pi, pi, par.pos_states); 
        s(2) = discretize(x(2), -12*pi, 12*pi, par.vel_states);
    end

    function a = execute_policy(s)
        explore = rand(1) <= par.epsilon;
        if explore
            a = fix(rand(1) * par.actions) + 1;
        else
            max_val = max(Q(s(1), s(2), :));
            candidates = find(Q(s(1), s(2), :) == max_val)
            idx = randi(length(candidates));
            a = candidates(idx);
        end
    end

    function r = observe_reward(a, sP)
        if isequal(sP, discretize_state([0 0]))
            r = 1;
        else
            r = 0;
        end
    end

    function t = is_terminal(sP)
        t = isequal(sP, discretize_state([0 0]));
    end

    function update_Q(s, a, r, sP, aP)
%       current_value = Q(s(1), s(2), a);
%       Q(s(1), s(2), a) =  current_value + par.alpha * ...
%            (r + par.gamma * Q(sP(1), sP(2), aP) - current_value);
        e = par.gamma * par.lambda * e;
        e(s(1), s(2), a) =  1;
        Q = Q + par.alpha * (r + par.gamma * Q(sP(1), sP(2), aP) - Q(s(1), s(2), a)) * e;
    end

    function u = take_action(a)
        voltages = linspace(-par.maxvoltage, par.maxvoltage, par.actions);
        u = voltages(a);
    end
end
