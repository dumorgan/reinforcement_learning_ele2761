simulated_experience = [20, 30, 50, 100, 200]

performance_per_exp = zeros(5, 1);
std_perf_per_exp = zeros(5, 1);

rt_per_exp = zeros(5, 1);
std_rt_per_exp = zeros(5, 1);

computation_time_per_exp = zeros(5, 1);
std_computation_time_per_exp = zeros(5, 1);

for s=1:5
    performance = zeros(10, 1);
    rise_time = zeros(10, 1);
    computation_time = zeros(10, 1);
    for r=1:10
        tic
        [ep, rt, network] = ac(simulated_experience(s));
        computation_time(r) = toc;
        performance(r) = ep;
        if isempty(rt)
            rise_time(r) = 200;
        else
            rise_time(r) = rt;    
        end
    end
    performance_per_exp(s) = mean(performance);
    std_perf_per_exp(s) = std(performance);
    
    rt_per_exp(s) = mean(rise_time);
    std_rt_per_exp(s) = std(rise_time);
    
    computation_time_per_exp(s) = mean(computation_time);
    std_computation_time_per_exp(s) = std(computation_time);
end


figure();
errorbaralpha(performance_per_exp, std_perf_per_exp);
title('End performance per simulated experience');
xlabel('Number of simulated transitions per episode');

figure()
errorbaralpha(rt_per_exp, std_rt_per_exp);
title('Rise Time per simulated experience');
xlabel('Number of simulated transitions per episode');

figure()
errorbaralpha(computation_time_per_exp, std_computation_time_per_exp);
title('Computation time per simulated experience');
xlabel('Number of simulated transitions per episode');
