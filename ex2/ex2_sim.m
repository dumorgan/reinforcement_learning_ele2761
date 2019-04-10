function ex2_sim(par)

    [~, learner] = sarsa(par);

    % Initialize a new trial
    x = par.initial_state;
    s = learner.discretize_state(x);
    a = learner.execute_policy(s);

    % Inner loop: simulation steps
    for tt = 1:ceil(par.simtime/par.simstep)
        % Take the chosen action
        u = max(min(learner.take_action(a), par.maxvoltage), -par.maxvoltage);

        % Simulate a time step
        x = pendulum(x, u);

        s = learner.discretize_state(x);
        a = learner.execute_policy(s);

        % Visualize
        drawip(x, u);
        pause(0.05);

        % Stop trial if state is terminal
        if learner.is_terminal(s)
            break
        end
    end
end
