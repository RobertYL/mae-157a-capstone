function [edges] = make_graph(waypoint_map)
% MAKE_GRAPH Make adjacency matrix EDGES given 3D cartesian points
arguments
    waypoint_map (3,:) double
end

n = size(waypoint_map,2);
edges = zeros(n,n);

for i = 1:3
    edges = edges + (waypoint_map(i,:)-waypoint_map(i,:)').^2;
end
edges = sqrt(edges);

end

