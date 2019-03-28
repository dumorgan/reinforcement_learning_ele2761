% GRIDWORLD

% POLICY EVALUATION

%% Exercise 1
pi = ones(1, 25);

[V, counter] = iterative_policy_evaluation(pi);

plotv(V)

%% Exercise 2

[V, pi, counter] = policy_iteration(0.9, 1e-5);

plotv(V);


%% Exercise 3

[V, pi, counter] = policy_iteration(0.8, 1e-5);