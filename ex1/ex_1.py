from .gridworld import gridworld

def iterative_policy_estimation(theta, S):
    delta = 0

    for s in S:
        v = 