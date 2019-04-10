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
        par.gamma = 0.99;     % Discount rate
        par.alpha = 0.2;        % Learning rate
        par.pos_states = 30;   % Position discretization
        par.vel_states = 30;   % Velocity discretization
        par.actions = 3;      % Action discretization
        par.trials = 1000;       % Learning trials
    end

    function init_Q()
        % TODO: Initialize the Q table.
    end

    function s = discretize_state(x)
        % TODO: Discretize state. Note: s(1) should be
        % TODO: position, s(2) velocity.
        s = [];
    end

    function a = execute_policy(s)
        % TODO: Select an action for state s using the
        % TODO: epsilon-greedy algorithm.
        a = [];
    end

    function r = observe_reward(a, sP)
        % TODO: Calculate the reward for taking action a,
        % TODO: resulting in state sP.
        r = [];
    end

    function t = is_terminal(sP)
        % TODO: Return 1 if state sP is terminal, 0 otherwise.
        t = [];
    end

    function update_Q(s, a, r, sP, aP)
        % TODO: Implement the SARSA update rule.
    end

    function u = take_action(a)
        % TODO: Calculate the proper voltage for action a. This cannot
        % TODO: exceed par.maxvoltage.
        u = [];
    end
end
