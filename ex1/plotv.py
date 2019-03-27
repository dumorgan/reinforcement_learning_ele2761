import numpy as np
from gridworld import gridworld
import matplotlib.pyplot as plt


def plotv(v):
    """
    plots the grid world value function V and its induced policy
    if multiple actions are optimal, only one is plotted
    :param v the value policy list
    """
    pi = np.zeros(25)

    for s in range(0, 24):
        actions = np.zeros(4)
        for a in range(0, 4):
            _, sp = gridworld(s, a)
            actions[a] = v[sp]
        pi[s] = np.argmax(actions)

    v = np.reshape(v, (5, 5))
    pi = np.reshape(pi, (5, 5))

    x, y = np.meshgrid(np.arange(1, 6, 1), np.arange(1, 6,1))

    ax = np.zeros_like(pi)
    ax = np.where(pi==3, 1, ax) - np.where(pi==4, 1, ax)

    ay = np.zeros_like(pi)
    ay = np.where(pi==2, 1, ay) - np.where(pi==1, 1, ay)

    plt.quiver(x, y, ax, ay)

    plt.show()