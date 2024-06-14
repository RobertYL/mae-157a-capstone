%% Guidance Analysis -- Relative Path Length

% user inputs
n = 3:12;   % number of random waypoints
m = 1000;  % number of random waypoint sets to generate

M = 3;      % number of methods
methods = {@(mat) tsp_nn(squeeze(mat)), ...
           @(mat) tsp_bf(squeeze(mat)), ...
           @(mat) tsp_dp(squeeze(mat))};
rpl_avg = zeros(1,length(n));
rpl_1q = zeros(1,length(n));
rpl_3q = zeros(1,length(n));
rpl = zeros(1,m);

for i = 1:length(n)

% generate random waypoints uniformly in [-5,5]x[-5,5]x[0,2]
for j = 1:m
    waypoints = (rand(3,n(i))-[0.5;0.5;0]).*[10;10;2];
    waypoints(:,1) = [0;0;1]; % default start
    waypoints(:,n(i)) = [0;0;1]; % default end
    adj_matrix = make_graph(waypoints);

    [~,dist_nn] = tsp_nn(adj_matrix);
    [~,dist_dp] = tsp_dp(adj_matrix);
    rpl(j) = (dist_nn-dist_dp)/dist_dp;
end

rpl_avg(i) = mean(rpl);
rpl_1q(i) = rpl_avg(i)-quantile(rpl,0.25);
rpl_3q(i) = quantile(rpl,0.75)-rpl_avg(i);

end

%% Plots

fig_rpl = figure(Position=[500,300,560*1.5,420]);
errorbar(n,rpl_avg,rpl_1q,rpl_3q,"-o",LineWidth=1)
xlabel("Waypoints");
ylabel("Relative Added Path Length [%]");
title("Nearest Neighbor SHP Relative Error");
grid on;

exportgraphics(fig_rpl,"report/figs/guide-rpl.png",Resolution=300);