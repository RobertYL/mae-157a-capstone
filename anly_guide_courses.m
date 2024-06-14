%% Guidance Analysis -- Flight Courses

C = 3;  % number of courses

for c = 1:C
    waypoints = import_waypoint(sprintf('data/course%d.csv',c));
    n = size(waypoints,2);
    adj_matrix = make_graph(waypoints);
    [order,min_dist] = tsp_dp(adj_matrix);
    waypoint_seq = waypoints(:,order);
    
    fprintf("Optimal order:");
    order
    fprintf("Min dist: %f\n", min_dist);

    % old algorithm
    [wrong_order,~] = tsp_dp_old(adj_matrix,1);
    wrong_order(2) = [];
    wrong_order(end+1) = n;
    wrong_waypoint_seq = waypoints(:,wrong_order);
    wrong_dist = sum(vecnorm(diff(wrong_waypoint_seq,1,2)));

    fprintf("Wrong order:");
    wrong_order
    fprintf("Wrong dist: %f\n", wrong_dist);
    fprintf("Path increase: %f%%\n", ...
        (wrong_dist-min_dist)/min_dist*100);

%% Plots

    fig_course = figure(Position=[200,200,560*1.5,420*1.5]);
    for i = 1:2
        subplot(2,1,i);
        scatter3(waypoints(1,:),waypoints(2,:),waypoints(3,:),'o', ...
            DisplayName="Waypoints");
        hold on
        plot3(waypoint_seq(1,:),waypoint_seq(2,:),waypoint_seq(3,:),'r', ...
            LineWidth=1.5,DisplayName="Opt. Path");
        plot3(wrong_waypoint_seq(1,:),wrong_waypoint_seq(2,:), ...
            wrong_waypoint_seq(3,:),'--',Color=[0.3 0.5 0.3], ...
            LineWidth=1.5,DisplayName="Subopt. Path");
        hold off
        
        axis equal
        axis vis3d
        xlim([floor(min(waypoints(1,:))),ceil(max(waypoints(1,:)))]);
        ylim([floor(min(waypoints(2,:))),ceil(max(waypoints(2,:)))]);
        zlim([0,2]);
        xticks(-10:10); yticks(-10:10); zticks(0:2);
        set(gca,GridAlpha=0.5);

        if i == 1
            legend(Location="eastoutside");
            view(-60,25);
        else
            view(-90,90);
        end
    end

    exportgraphics(fig_course, ...
        sprintf("report/figs/guide-course%d.png",c),Resolution=300);

end