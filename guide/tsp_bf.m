function [order,min_dist] = tsp_bf(edges)
% TSP_BF Traveling salesman problem brute force solution
%   Given a weighted, dense graph EDGES, find the order of nodes for the
%   shortest tour starting from node 1 to node n
arguments
    edges (:,:) double
end

n = size(edges,1);
if n > 13
%     warning("Greater than 13 nodes, algorithm may be slow")
    order = -ones(1,n);
    min_dist = inf;
    return
end
st = 1;
ed = n;

p = perms(1:(n-2))+1;
N = size(p,1);

min_dist = inf;
order = zeros(1,n);
order(1) = st;
order(n) = ed;
for i = 1:N
    dist = edges(st,p(i,1)) + edges(p(i,n-2),ed);
    for j = 2:(n-2)
        dist = dist + edges(p(i,j-1),p(i,j));
    end
    if dist < min_dist
        min_dist = dist;
        order(2:n-1) = p(i,:);
    end
end

end

