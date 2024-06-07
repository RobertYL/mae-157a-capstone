%% Guidance Example -- Sequencing Waypoint Samples

% finds optimal waypoint sequence using example waypoints
% assumes drone starts at (0,0,1)---by appending it to waypoint list---and
% ends when last waypoint is reached

waypoint_map = import_waypoint('data/waypoints_example.csv');
n = size(waypoint_map,2);
origin = [0;0;1];
adj_matrix = make_graph([waypoint_map,origin]);
[order,min_dist] = tsp_dp(adj_matrix,n+1);
order(1) = [];

fprintf("Optimal order:")
orderu

% send order to sim =>>

%% Visualizing the Path

path = waypoint_map(:,order);
dist = vecnorm(diff(path,1,2)); % distances between each waypoint
frms = floor(dist.*24); % frames per waypoint connection
viz_path = zeros(3,sum(frms)+1);

% discretize path for animation
j = 1;
for i = 1:n-1
    viz_path(1,j:j+frms(i)) = linspace(path(1,i),path(1,i+1),frms(i)+1);
    viz_path(2,j:j+frms(i)) = linspace(path(2,i),path(2,i+1),frms(i)+1);
    viz_path(3,j:j+frms(i)) = linspace(path(3,i),path(3,i+1),frms(i)+1);
    j = j+frms(i);
end

% plot as comet
fig = figure(Position=[200,200,560*1.5,420*1.5]);

view(-65,20);
axis equal
axis vis3d
grid on

scatter3(path(1,:),path(2,:),path(3,:),'o');
hold on
comet3(viz_path(1,:),viz_path(2,:),viz_path(3,:))
hold off