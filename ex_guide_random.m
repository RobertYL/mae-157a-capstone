%% Guidance Example -- Random Waypoints

% user inputs
n = 12;     % number of random waypoints
m = 20000;  % number of random permutations to sample

% generate random waypoints uniformly in [-5,5]x[-5,5]x[0,2]
waypoints = (rand(3,n)-[0.5;0.5;0]).*[10;10;2];
waypoints(:,1) = [0;0;1]; % default start
waypoints(:,n) = [0;0;1]; % default end

%% Main Algorithms

% generate DP and NN solutions
adj_matrix = make_graph(waypoints);
tic
[order_dp,dist_dp] = tsp_dp(adj_matrix);
toc
fprintf("Optimal order:")
order_dp
[order_nn,dist_nn] = tsp_nn(adj_matrix);

% monte carlo random permutations
rand_dist = zeros(1,m);
for j = 1:m
    rand_ord = [1,randperm(n-1)+1];
    rand_dist(j) = sum(vecnorm(diff(waypoints(:,rand_ord),1,2)));
end

%% Monte Carlo Histogram

fig_hist = figure(Position=[200,200,560,420*0.75]);
histogram(rand_dist);
hold on;
xline(dist_dp,'--r',sprintf("(d_{min}) %.1f",dist_dp), ...
    LineWidth=1.5);
xline(dist_nn,'--r',sprintf("(d_{nn}) %.1f",dist_nn), ...
    LineWidth=1.5);
xline(mean(rand_dist),'--r', ...
    sprintf("%.1f",mean(rand_dist)), ...
    LineWidth=1.5);
hold off;
xlabel("Path Length");
ylabel("Occurrences");
grid on
set(gca,GridAlpha=0.5);

exportgraphics(fig_hist,sprintf("figs/%d-hist_rand_seq.png",n), ...
    Resolution=300);

%% 3D Waypoint Animations

path_dp = waypoints(:,order_dp);
path_nn = waypoints(:,order_nn);
dist = vecnorm(diff(path_dp,1,2)); % distances between each waypoint
frms = floor(dist.*6); % frames per waypoint connection
viz_path = zeros(3,sum(frms)+1);

% discretize path for animation
j = 1;
for i = 1:n-1
    viz_path(1,j:j+frms(i)) = linspace(path_dp(1,i),path_dp(1,i+1),frms(i)+1);
    viz_path(2,j:j+frms(i)) = linspace(path_dp(2,i),path_dp(2,i+1),frms(i)+1);
    viz_path(3,j:j+frms(i)) = linspace(path_dp(3,i),path_dp(3,i+1),frms(i)+1);
    j = j+frms(i);
end

k_max = sum(frms)+1; % total frames for animated trail
dk = 48; % delta-k for length of animated trail
daz = 4; % delta-az for spinning animation

% all animation: im (trail), im2 (spin with path), im3 (spin with no path)
fig = figure(Position=[200,200,560*1.5,420*1.5]);
scatter3(path_dp(1,:),path_dp(2,:),path_dp(3,:),'o');
hold on
plt3 = plot3(path_dp(1,:),path_dp(2,:),path_dp(3,:),'r',LineWidth=1.5);
plt3_nn = plot3(path_nn(1,:),path_nn(2,:),path_nn(3,:),'--',Color=[0.3 0.5 0.3],LineWidth=1.5);
hold off

view(-65,20);
axis equal
axis vis3d
xlim([-5,5]); ylim([-5,5]); zlim([0,2]);
xticks(-5:5); yticks(-5:5); zticks(0:2);
set(gca,GridAlpha=0.5);

f = getframe(fig);
[im,map] = rgb2ind(f.cdata,256,'nodither');
[im2,~] = rgb2ind(f.cdata,256,'nodither');
[im3,~] = rgb2ind(f.cdata,256,'nodither');
im(1,1,1,k_max) = 0;

set(plt3_nn,XData=0,YData=0,ZData=0);

for k = 1:k_max+dk
    idx = max(1,k-dk):min(k_max,k);

    set(plt3,XData=viz_path(1,idx),YData=viz_path(2,idx), ...
        ZData=viz_path(3,idx));

    f = getframe(fig);
    im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end

% fig
set(plt3,XData=path_dp(1,:),YData=path_dp(2,:),ZData=path_dp(3,:));
set(plt3_nn,XData=path_nn(1,:),YData=path_nn(2,:),ZData=path_nn(3,:));

im2(1,1,1,360/daz) = 0;

for k = 1:360/daz
    [az,el] = view;
    view(az-daz,el);

    f = getframe(fig);
    im2(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end
set(plt3,XData=0,YData=0,ZData=0);
set(plt3_nn,XData=0,YData=0,ZData=0);

im3(1,1,1,360/daz) = 0;

for k = 1:360/daz
    [az,el] = view;
    view(az-daz,el);

    f = getframe(fig);
    im3(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end

% write videos
imwrite(im,map,sprintf("figs/%d-comet.gif",n),'DelayTime',0,'LoopCount',inf)
imwrite(im2,map,sprintf("figs/%d-spin.gif",n),'DelayTime',0,'LoopCount',inf)
imwrite(im3,map,sprintf("figs/%d-spin_empty.gif",n),'DelayTime',0,'LoopCount',inf)