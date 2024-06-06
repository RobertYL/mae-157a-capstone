function [order,dist] = tsp_nn(edges,source)
% TSP_NN Traveling salesman problem nearest neighbor solution
%   Given a weighted, dense graph EDGES, find the order of nodes for the
%   greedy, nearest neighbor tour starting from SOURCE
arguments
    edges (:,:) double
    source (1,1) double
end

n = size(edges,1);
if source < 1 || source > n
    error("Invalid source index")
end

order = zeros(1,n);
order(1) = source;
vis = false(1,n);
vis(source) = true;
dist = 0;

for i = 2:n
    j_dist = min(edges(order(i-1),find(~vis)));
    dist = dist + j_dist;
    j = find(j_dist == edges(order(i-1),:),1);
    order(i) = j;
    vis(j) = true;
end

end

