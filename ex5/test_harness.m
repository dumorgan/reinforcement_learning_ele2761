xrise_time = zeros(10, 1);
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

mean_rt = mean(rt)
std_rt = std(rise_time)
