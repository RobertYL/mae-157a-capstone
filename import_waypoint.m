%% waypoint_map
% imports a map of waypoints for the drone to follow
% assumes the waypoints are given in order (for now)

function waypoint_map = import_waypoint(filename)
    raw_waypoint_map = readmatrix(filename);
    
    % parse into X, Y, Z
    waypoint_X = raw_waypoint_map(1,:);
    waypoint_Y = raw_waypoint_map(2,:);
    waypoint_Z = raw_waypoint_map(3,:);
    
    waypoint_map = [waypoint_X; waypoint_Y; waypoint_Z];
end