function [order,min_dist] = tsp_dp(edges)
% TSP_DP Traveling salesman problem dynamic programming solution
%   Given a weighted, dense graph EDGES, find the order of nodes for the
%   shortest tour starting from node 1 to node n
arguments
    edges (:,:) double
end

n = size(edges,1);
if n > 25
    warning("Greater than 25 nodes, algorithm may be slow")
end
st = 1;
ed = n;

dist = inf(2^(n-2)-1, n-2);
par = zeros(2^(n-2)-1, n-2);
for mask = 1:(2^(n-2)-1)
    vis = find(bitget(mask,1:n));

    if length(vis) == 1
        dist(mask,vis(1)) = edges(st,vis(1)+1);
        par(mask,vis(1)) = st-1;
        continue;
    end

    for i = 1:length(vis)
        submask = bitset(mask,vis(i),0);
        for j = 1:length(vis)
            if i == j
                continue;
            end
            if dist(submask,vis(j)) + edges(vis(j)+1,vis(i)+1) ...
                    < dist(mask,vis(i))
                dist(mask,vis(i)) = dist(submask,vis(j)) ...
                    + edges(vis(j)+1,vis(i)+1);
                par(mask,vis(i)) = vis(j);
            end
        end
    end
end

min_dist = inf;
order = zeros(1,n);
order(n) = ed;
mask = 2^(n-2)-1;
for i = 1:(n-2)
    if dist(mask,i) + edges(i+1,ed) < min_dist
        min_dist = dist(mask,i) + edges(i+1,ed);
        order(n-1) = i+1;
    end
end
for i = n-2:-1:2
    order(i) = par(mask,order(i+1)-1)+1;
    mask = bitset(mask,order(i+1)-1,0);
end
order(1) = st;

end

