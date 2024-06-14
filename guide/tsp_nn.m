function [order,dist] = tsp_nn(edges)
% TSP_NN Traveling salesman problem nearest neighbor solution
%   Given a weighted, dense graph EDGES, find the order of nodes for the
%   greedy, nearest neighbor tour starting from node 1 to node n
arguments
    edges (:,:) double
end

n = size(edges,1);
st = 1;
ed = n;

order = zeros(1,n);
order(1) = st;
vis = false(1,n-1);
vis(st) = true;
dist = 0;

for i = 2:(n-1)
    j_dist = min(edges(order(i-1),find(~vis)));
    dist = dist + j_dist;
    j = find(j_dist == edges(order(i-1),1:(n-1)),1);
    order(i) = j;
    vis(j) = true;
end

order(n) = ed;
dist = dist + edges(order(n-1),ed);

end

