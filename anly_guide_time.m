%% Guidance Analysis -- Runtime

% user inputs
n = 3:25;   % number of random waypoints
m = 10000;  % number of random waypoint sets to generate

M = 3;      % number of methods
methods = {@(mat) tsp_nn(squeeze(mat)), ...
           @(mat) tsp_bf(squeeze(mat)), ...
           @(mat) tsp_dp(squeeze(mat))};
runtime = zeros(length(n),M);

for i = 1:length(n)

% generate random waypoints uniformly in [-5,5]x[-5,5]x[0,2]
waypoint_sets = zeros(m,3,n(i));
adj_matrix = zeros(m,n(i),n(i));
for j = 1:m
    waypoint_sets(j,:,:) = (rand(3,n(i))-[0.5;0.5;0]).*[10;10;2];
    waypoint_sets(j,:,1) = [0;0;1]; % default start
    waypoint_sets(j,:,n(i)) = [0;0;1]; % default end
    adj_matrix(j,:,:) = make_graph(squeeze(waypoint_sets(j,:,:)));
end

for k = 1:M
    j = 0;
    time_st = tic;
    while j < m && toc(time_st) < 1
        j = j+1;
        [~,~] = methods{k}(adj_matrix(j,:,:));
    end
    runtime(i,k) = toc(time_st)/j;
end

end

%% Plots

method_names = ["Nearest Neighbor", "Brute Force", "Dynamic Programming"];
rt_threshold = max(runtime(12:end,2))*(1+eps);

fig_rt = figure(Position=[500,300,560*1.5,420]);
for k = 1:M
    plt_idx = runtime(:,k) > rt_threshold;
    semilogy(n(plt_idx),runtime(plt_idx,k),'-o', ...
        DisplayName=method_names(k));
    hold on;
end
hold off;
xlabel("Waypoints");
ylabel("Runtime [s]");
title("Time Complexity Curve for 3 SHP Methods");
grid on;
legend(Location="northwest");

exportgraphics(fig_rt,"report/figs/guide-rt.png",Resolution=300);