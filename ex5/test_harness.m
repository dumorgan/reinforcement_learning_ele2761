rise_time = zeros(10, 1);
performance = zeros(10, 1);

for i=1:10
    [ep, rt, network] = ac();
    performance(i) = ep;
    if isempty(rt)
        rise_time(i) = 200;
    else
        rise_time(i) = rt;    
    end
end

mean_perf = mean(performance);
std_perf = std(performance);

mean_rt = mean(rise_time);
std_rt = std(rise_time);

figure();
errorbaralpha(performance, ones(10, 1) * std_perf);
title('End performance');

figure()
errorbaralpha(rise_time, ones(10, 1) * std_rt);
title('Rise Time');
