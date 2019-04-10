function par = ex2()

    par.simtime = 3;            % Trial length (s)
    par.simstep = 0.03;         % Simulation time step
    par.maxvoltage = 3;         % Maximum applicable torque
    par.initial_state = [pi 0]; % Start in down position

    [par, learner] = sarsa(par);

    % Initialize bookkeeping (for plotting only)
    ra = zeros(par.trials, 1);
    tta = zeros(par.trials, 1);

    % Initialize value function
    learner.init_Q();

    % Outer loop: trials
    for ii = 1:par.trials
        % Initialize a new trial
        x = par.initial_state;
        learner.init_trace();
        s = learner.discretize_state(x);
        a = learner.execute_policy(s);

        % Inner loop: simulation steps
        for tt = 1:ceil(par.simtime/par.simstep)
            % Take the chosen action
            u = max(min(learner.take_action(a), par.maxvoltage), -par.maxvoltage);

            % Simulate a time step
            x = pendulum(x, u);
            
            sP = learner.discretize_state(x);
            r = learner.observe_reward(a, sP);
            aP = learner.execute_policy(sP);
            learner.update_Q(s, a, r, sP, aP);
            
            % Back up state and action
            s = sP;
            a = aP;
            
            % Keep track of cumulative reward
            ra(ii) = ra(ii)+r;
            
            % Stop trial if state is terminal
            if learner.is_terminal(s)
                break
            end
        end
        
        tta(ii) = tta(ii) + tt*par.simstep;
        
        % Update plot every ten trials
        if rem(ii, 10) == 0
            plot_Q();
            drawnow;
        end
    end

    par.Q = learner.get_Q();

    function plot_Q()
        % Visualization
        Q = learner.get_Q();
        [xx, yy] = meshgrid(1:par.pos_states, 1:par.vel_states);
        [val, pos] = max(Q, [], 3);

        % Value function
        subaxis(2, 2, 1, 'MR', 0.05, 'SV', 0.15, 'SH', 0.1);
        surf(xx, yy, val');
        colormap jet;
        view(0,90);
        axis tight
        title('State-value function (V = max_a(Q(s, a)))');
        xlabel('Position');
        ylabel('Velocity');

        % Policy
        subaxis(2, 2, 2);
        surf(xx, yy, movavg(pos', 3));
        colormap jet;
        view(0,90);
        axis tight
        title('Policy (argmax_a(Q(s, a)))');
        xlabel('Position');
        ylabel('Velocity');
        
        % Reward
        subaxis(2, 2, 3);
        plot(1:ii, movavg(ra(1:ii), 9));
        set(gca, 'xlim', [0 par.trials]);
        title('Progress');
        xlabel('Trial');
        ylabel('Average cumulative reward');
        
        % Trial duration
        subaxis(2, 2, 4);
        plot(movavg(tta(1:ii), 9));
        set(gca, 'xlim', [0 par.trials]);
        title('Progress');
        xlabel('Trial');
        ylabel('Average trial duration');

        set(gcf, 'Name', ['Iteration ' num2str(ii)]);
    end
end
