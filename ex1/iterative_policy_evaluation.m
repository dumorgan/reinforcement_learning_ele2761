function [V, counter] = iterative_policy_evaluation(V, pi, gamma, theta)
  delta = theta;
  counter = 0;
  
  while delta >= theta
    delta = 0;
    for s=1:25
      v = V(s);
      counter++;
      [reward, next_state] = gridworld(s, pi(s));
      
      V(s) = reward + gamma * V(next_state);
      delta = max(delta, abs(v - V(s)));
    end
  end
end 

  