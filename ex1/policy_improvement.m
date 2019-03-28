function [pi, stable, counter] = policy_improvement(V, pi, gamma)
  stable = true;
  counter = 0;
  for s=1:25
    old_action = pi(s);
    actions = zeros(1,4);
    for a=1:4
      counter++;
      [reward, next_state] = gridworld(s, a);
      actions(a) = reward + gamma * V(next_state);
     end
    [_, pi(s)] = max(actions);
    
    if pi(s) != old_action;
      stable = false;
    end
  end
end