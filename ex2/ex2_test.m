%% Initialization
par.maxvoltage = 3;
[par, learner] = sarsa(par);

disp('Sanity checking sarsa.m');

%% Parameters
if (par.epsilon <= 0 || par.epsilon >= 1)
    error('Random action rate out of bounds, check get_parameters/par.epsilon');
end
if (par.gamma <= 0 || par.gamma > 1)
    error('Discount rate out of bounds, check get_parameters/par.gamma');
end
if (par.alpha <= 0 || par.alpha > 1)
    error('Learning rate out of bounds, check get_parameters/par.alpha');
end
if (par.pos_states <= 1 || par.pos_states > 1000)
    error('Number of discretized positions out of bounds, check get_parameters/par.pos_states');
end
if (par.vel_states <= 1 || par.vel_states > 1000)
    error('Number of discretized velocities out of bounds, check get_parameters/par.vel_states');
end
if (par.actions <= 1 || par.actions > 100)
    error('Number of actions out of bounds, check get_parameters/par.actions');
end

disp('...Parameters are within bounds');

%% Q value initialization
learner.init_Q();
Q = learner.get_Q();
if isempty(Q)
    error('Q value initialization unimplemented, check init_Q');
end

if ndims(Q) ~= 3
    error('Q dimensionality error, check init_Q/Q');
end

if not(all(size(Q)==[par.pos_states, par.vel_states, par.actions]))
    error('Q size error, check init_Q/Q');
end

disp('...Q value dimensionality OK');

%% State discretization
x0 = [0 0];
s = learner.discretize_state(x0);

if isempty(s)
    error('State discretization unimplemented, check discretize_state');
end

disp('...State discretization is implemented');

%% Position discretization
pc = -5:0.1:5;
pd = zeros(size(pc));
for pp = 1:length(pc)
    x0(1) = pc(pp);
    s = learner.discretize_state(x0);
    pd(pp) = s(1);
end

if any((pd < 1) | (pd > par.pos_states) | (pd-fix(pd) ~= 0))
    error('Position discretization out of bounds, check discretize_state/s(1)');
end

subaxis(2, 3, 1, 'SV', 0.15, 'SH', 0.1, 'MR', 0.05);
set(gcf, 'name', 'Test results');
plot(pc, pd);
title('Position discretization');
xlabel('Continuous position');
ylabel('Discrete position');

disp('......Position discretization is within bounds');

%% Velocity discretization
vc = -50:0.1:50;
vd = zeros(size(vc));
for vv = 1:length(vc)
    x0(2) = vc(vv);
    s = learner.discretize_state(x0);
    vd(vv) = s(2);
end

if any((vd < 1) | (vd > par.vel_states) | (vd-fix(vd) ~= 0))
    error('Velocity discretization out of bounds, check discretize_state/s(2)');
end

subaxis(2, 3, 2);
plot(vc, vd);
title('Velocity discretization');
xlabel('Continuous velocity');
ylabel('Discrete velocity');

disp('......Velocity discretization is within bounds');

%% Action execution
u = learner.take_action(1);
if isempty(u)
    error('Action execution unimplemented, check take_action');
end

for aa = 1:par.actions
    u(aa) = learner.take_action(aa);
end

if any((u(aa) < -par.maxvoltage) | (u(aa) > par.maxvoltage))
    error('Action out of bounds, check take_action/u');
end

subaxis(2, 3, 3)
plot(1:par.actions, u, '.');
title('Action execution');
xlabel('Action');
ylabel('Applied voltage');

disp('...Action execution is within bounds');

%% Reward observation
r = learner.observe_reward(1, s);
if isempty(r)
    error('Reward observation unimplemented, check observe_reward');
end

r = zeros(par.pos_states,par.vel_states);
for pp = 1:par.pos_states
    for vv = 1:par.vel_states
        for aa = 1:par.actions
            s = [pp vv];
            r(pp,vv,aa) = learner.observe_reward(aa, s);
        end
    end
end

subaxis(2, 3, 1, 2, 2, 1);
[x, y] = meshgrid(1:par.pos_states, 1:par.vel_states);
surf(x, y, mean(r, 3)');
title('Average reward');
xlabel('Position');
ylabel('Velocity');
view(0,90);
axis tight
colorbar

disp('...Reward observation is implemented');

%% Termination criterion
t = learner.is_terminal(s);
if isempty(t)
    error('Termination criterion unimplemented, check is_terminal');
end

t = zeros(par.pos_states,par.vel_states);
for pp = 1:par.pos_states
    for vv = 1:par.vel_states
        s = [pp vv];
        t(pp,vv) = learner.is_terminal(s);
    end
end
t = logical(t)+0;

subaxis(2, 3, 6);
[x, y] = meshgrid(1:par.pos_states, 1:par.vel_states);
surf(x, y, t');
title('Termination criterion');
xlabel('Position');
ylabel('Velocity');
view(0,90);
axis tight

disp('...Termination criterion is implemented');

%% Action selection
a = learner.execute_policy(s);
if isempty(a)
    error('Action selection unimplemented, check execute_policy');
end

for pp = 1:par.pos_states
    for vv = 1:par.vel_states
        s = [pp vv];
        a = learner.execute_policy(s);
        if (isempty(a) || a < 1) || (a > par.actions) || (a-fix(a)) ~= 0
            error('Action selection out of bounds, check execute_policy/a');
        end
    end
end

disp('...Action selection is within bounds');

%% Q update rule
learner.update_Q(s, a, 100, s, a);
Q2 = learner.get_Q();
if all(Q == Q2)
    error('Q update rule unimplemented, check update_Q');
end

disp('...Q update rule is implemented');

disp('Sanity check successfully completed');
