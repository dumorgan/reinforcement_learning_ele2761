function [V, pi, counter] = value_iteration(gamma, theta)
  V = zeros(1, 25);
  pi = ones(1, 25);
  counter = 0;
  delta = theta;
  actions = zeros(1,4);

  while delta >= theta
    delta = 0;
    for s=1:25
    
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
      delta = max(delta, abs(v - V(s)));
    end
  end
end