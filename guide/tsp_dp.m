function [order, min_dist] = tsp_dp(edges)
% TSP_DP Traveling salesman problem dynamic programming solution
%   Given a weighted, dense graph EDGES, find the order of nodes for the
%   shortest path

n = size(edges,1);
if n > 25
    warning("Greater than 25 nodes, algorithm may be slow")
end

dist = inf(2^n-1, n);
par = zeros(2^n-1, n);
for mask = 1:(2^n-1)
    vis = find(bitget(mask,1:n));

    if length(vis) == 1
        dist(mask,vis(1)) = 0;
        par(mask,vis(1)) = vis(1);
        continue;
    end

    for i = 1:length(vis)
        submask = bitset(mask,vis(i),0);
        for j = 1:length(vis)
            if i == j
                continue;
            end
            if dist(submask,vis(j)) + edges(vis(j),vis(i)) ...
                    < dist(mask,vis(i))
                dist(mask,vis(i)) = dist(submask,vis(j)) ...
                    + edges(vis(j),vis(i));
                par(mask,vis(i)) = vis(j);
            end
        end
    end
end

min_dist = inf;
order = zeros(1,n);
mask = 2^n-1;
for i = 1:n
    if dist(mask,i) < min_dist
        min_dist = dist(mask,i);
        order(n) = i;
    end
end

for i = n-1:-1:1
    order(i) = par(mask,order(i+1));
    mask = bitset(mask,order(i+1),0);
end

end

