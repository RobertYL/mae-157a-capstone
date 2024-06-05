%% waypoint_map
% imports a map of waypoints for the drone to follow
% assumes the waypoints are given in order (for now)

function waypoint_map = import_waypoint(filename)
    waypoint_table = readtable(filename,VariableNamingRule="preserve");
    [~,ord] = sort(waypoint_table.("seq num"));
    
    % parse into X, Y, Z
    waypoint_X = waypoint_table.x(ord)';
    waypoint_Y = waypoint_table.y(ord)';
    waypoint_Z = waypoint_table.z(ord)';
    
    waypoint_map = [waypoint_X; waypoint_Y; waypoint_Z];
end