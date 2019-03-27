%PLOTV Plot grid world value function and induced policy.
%   PLOTV(V) plots the grid world value function V and its induced policy.
%
%   NOTE:
%       If multiple actions are optimal, only one is plotted.
function plotv(v)

    pi = zeros(1, 25);
    for s = 1:25
        actions = zeros(1, 4);
        for a = 1:4
            [~, sp] = gridworld(s, a);
            actions(a) = v(sp);
        end
        [~, pi(s)] = max(actions);
    end

    v = reshape(v, 5, 5);
    pi = reshape(pi, 5, 5);
    
    ax = -(pi==4) + (pi==3);
    ay = -(pi==1) + (pi==2);
    
    [x, y] = meshgrid(1:5, 1:5);
    
    quiver(x, y, ax, ay, 0.5);
    hold on
    
    for xx=1:5
        for yy=1:5
            text(xx, yy, num2str(v(yy, xx), '%5.1f'), 'horizontalalignment', 'center', 'backgroundcolor', 'white');
        end
    end
    
    hold off
    axis([0 6 0 6]);
    set(gca, 'xtick', 1:5, 'ytick', 1:5, 'ydir', 'reverse');
    
    title('Gridworld V(s) and \pi(s)');
    xlabel('Column');
    ylabel('Row');
    
end
