import numpy as np
from .gridworld import gridworld
import matplotlib.pyplot as plt


def plotv(v):
    """
    plots the grid world value function V and its induced policy
    if multiple actions are optimal, only one is plotted
    :param v the value policy list
    """
    pi = np.zeros((1, 25))

    for s in range(0, 25):
        actions = np.zeros((1, 4))
        for a in range(0, 4):
            _, sp = gridworld(s, a)
            actions[a] = v[sp]
        _, pi[s] = max(actions)

    v = np.reshape(v, (5, 5))
    pi = np.reshape(pi, (5, 5))

    x, y = np.meshgrid(np.arange(1, 6, 1), np.arange(1, 6,1))
    plt.quiver(x, y, )

    plt.show()