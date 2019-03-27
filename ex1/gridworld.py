from math import floor, ceil


def gridworld(s, a):
    """
    returns the reward R and next state SP when
    starting in state S and taking action A.
    :param s: current state
    :param a: action taken
    :return: tuple reward and next state
    """
    s = s - 1
    x = floor(s / 5) if  (s / 5 >= 0) else ceil(s / 5) 
    y = s - x * 5

    if y == 0:
        if x == 1:
            r = 10
            sp = 1 * 5 + 4 + 1
            return r, sp
        elif x == 3:
            r = 5
            sp = 3 * 5 + 2 + 1
            return r, sp

    if a == 1:
        y = y - 1
    elif a == 2:
        y = y + 1
    elif a == 3:
        x = x + 1
    elif a == 4:
        x = x - 1
    
    r = 0

    if x < 0:
        r = -1
        x = 0
    elif x > 4:
        r = -1
        x = 4
    elif y < 0:
        r = -1
        y = 0
    elif y > 4:
        r = -1
        y = 4

    sp = x * 5 + y + 1
    return r, sp