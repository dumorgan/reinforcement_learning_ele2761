function [V, pi, gridworld_counter] = policy_iteration(gamma, theta)
  V = zeros(1,25);
  pi = ones(1,25);
  
  stable = false;
  gridworld_counter = 0;
  
  while ~stable
    [V, counter] = iterative_policy_evaluation(V, pi, gamma, theta);
    gridworld_counter += counter;
    [pi, stable, counter] = policy_improvement(V, pi, gamma);
    gridworld_counter += counter;
  end
 end
