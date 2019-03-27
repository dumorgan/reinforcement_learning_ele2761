from .gridworld import gridworld
import numpy as np


def iterative_policy_evaluation(pi, S, theta=1e-5, gamma=0.9):
    """
    
    """
    S = S if S is not None else np.range(start=0, stop=5*5, step=1)
    delta = 0

    V = np.random.random_sample(S)
    V[-1] = 0

    while delta >= theta:
        for s in S:
            v = V[s]
            reward, next_state = gridworld(s, pi(s))
            V[s] = reward + gamma * V[next_state]
            delta = max(delta, abs(v - V[s]))

