%GRIDWORLD Grid world from Sutton & Barto, example. 3.8.
%   [R, SP] = GRIDWORLD(S, A) returns the reward R and next state SP when
%   starting in state S and taking action A.
function [r, sp] = gridworld(s, a)
    s = s - 1;
    x = fix(s/5);
    y = s-x*5;
    
    if y == 0
        if x == 1
            r = 10;
            sp = 1*5+4+1;
            return
        elseif x == 3
            r = 5;
            sp = 3*5+2+1;
            return
        end
    end

    switch a
        case 1
            y = y - 1;
        case 2
            y = y + 1;
        case 3
            x = x + 1;
        case 4
            x = x - 1;
    end

    r = 0;

    if x < 0
        r = -1;
        x = 0;
    elseif x > 4
        r = -1;
        x = 4;
    elseif y < 0
        r = -1;
        y = 0;
    elseif y > 4
        r = -1;
        y = 4;
    end

    sp = x*5+y+1;
end
