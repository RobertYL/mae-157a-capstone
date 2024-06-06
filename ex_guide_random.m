%% Guidance Example -- Random Waypoints

n = [3,10,23];
n = 23;
m = 20000; % number of random permutations to sample

for i = 1:length(n)
    % generate random waypoints uniformly in [-5,5]x[-5,5]x[0,2]
    waypoints = (rand(3,n(i))-[0.5;0.5;0]).*[10;10;2];
    waypoints(:,1) = [0;0;1]; % default origin
    adj_matrix = make_graph(waypoints);
    tic
    [order,min_dist] = tsp_dp(adj_matrix,1);
    toc

    rand_dist = zeros(1,m);
    for j = 1:m
        rand_ord = [1,randperm(n(i)-1)+1];
        rand_dist(j) = sum(vecnorm(diff(waypoints(:,rand_ord),1,2)));
    end
    fig_hist = figure(Position=[200,200,560,420*0.75]);
    histogram(rand_dist);
    hold on;
    xline(min_dist,'--r',sprintf("(d_{min}) %.1f",min_dist), ...
        LineWidth=1.5);
    xline(mean(rand_dist),'--r', ...
        sprintf("%.1f",mean(rand_dist)), ...
        LineWidth=1.5);
    hold off;
    xlabel("Path Length");
    ylabel("Occurrences");
    grid on
    set(gca,GridAlpha=0.5);

    exportgraphics(fig_hist,"figs/hist_rand_seq.png",Resolution=300);
end

%% viz

path = waypoints(:,order);
dist = vecnorm(diff(path,1,2));
frms = floor(dist.*6);
viz_path = zeros(3,sum(frms)+1);
j = 1;
for i = 1:n(end)-1
    viz_path(1,j:j+frms(i)) = linspace(path(1,i),path(1,i+1),frms(i)+1);
    viz_path(2,j:j+frms(i)) = linspace(path(2,i),path(2,i+1),frms(i)+1);
    viz_path(3,j:j+frms(i)) = linspace(path(3,i),path(3,i+1),frms(i)+1);
    j = j+frms(i);
end

k_max = size(viz_path,2);
dk = 48;
daz = 4;

% fig
fig = figure(Position=[200,200,560*1.5,420*1.5]);
scatter3(path(1,:),path(2,:),path(3,:),'o');
hold on
plt3 = plot3(path(1,:),path(2,:),path(3,:),'r');
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

for k = 1:k_max+dk
    idx = max(1,k-dk):min(k_max,k);

    set(plt3,XData=viz_path(1,idx),YData=viz_path(2,idx), ...
        ZData=viz_path(3,idx));

    f = getframe(fig);
    im(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end

% fig
set(plt3,XData=path(1,:),YData=path(2,:),ZData=path(3,:));

im2(1,1,1,360/daz) = 0;

for k = 1:360/daz
    [az,el] = view;
    view(az-daz,el);

    f = getframe(fig);
    im2(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end
set(plt3,XData=0,YData=0,ZData=0);

im3(1,1,1,360/daz) = 0;

for k = 1:360/daz
    [az,el] = view;
    view(az-daz,el);

    f = getframe(fig);
    im3(:,:,1,k) = rgb2ind(f.cdata,map,'nodither');
end

imwrite(im,map,'figs/comet.gif','DelayTime',0,'LoopCount',inf)
imwrite(im2,map,'figs/spin.gif','DelayTime',0,'LoopCount',inf)
imwrite(im3,map,'figs/spin_empty.gif','DelayTime',0,'LoopCount',inf)