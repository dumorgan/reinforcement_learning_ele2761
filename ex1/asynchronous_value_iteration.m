function [V, pi, counter] = value_iteration(gamma)
  V = zeros(1, 25);
  pi = ones(1, 25);
  counter = 0;
  actions = zeros(1,4);

  for i=1:250
    s = randi(25);
    % computes currently optimal policy
    for a=1:4
      counter++;
      [reward, next_state] = gridworld(s, a);
      actions(a) = reward + gamma * V(next_state);
    end
    [new_v, pi(s)] = max(actions);
    
    % updates values
    v = V(s);
    V(s) = new_v;
  end
end