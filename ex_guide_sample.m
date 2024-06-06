%% Guidance Example -- Sequencing Waypoint Samples

% finds optimal waypoint sequence using example waypoints
% assumes drone starts at (0,0,1) and ends when last waypoint is reached

waypoint_map = import_waypoint('data/waypoints_example.csv');
n = size(waypoint_map,2);
origin = [0;0;1];
adj_matrix = make_graph([waypoint_map,origin]);
[order,min_dist] = tsp_dp(adj_matrix,n+1);
order(1) = [];

% send order to sim =>>

%% Visualizing the Path

path = [waypoint_map(1,order);waypoint_map(2,order)];
dist = vecnorm(diff(path,1,2));
frms = floor(dist.*24);
viz_path = zeros(2,sum(frms)+1);
j = 1;
for i = 1:n-1
    viz_path(1,j:j+frms(i)) = linspace(path(1,i),path(1,i+1),frms(i)+1);
    viz_path(2,j:j+frms(i)) = linspace(path(2,i),path(2,i+1),frms(i)+1);
    j = j+frms(i);
end

fig = figure();
axis equal
hold on
comet(viz_path(1,:),viz_path(2,:))
hold off