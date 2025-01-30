x1 = [0 0.5 0.7 0.4 0 0 0 0 0]; % edges for node a
x2 = [0.5 0 0.45 0.8 2.1 0 0 0.37 0]; % edges for node b
x3 = [0.7 0.45 0 0.65 0 0 0 0.9 1.6]; % c
x4 = [0.4 0.8 0.65 zeros(1,6)]; % d
x5 = [0 2.1 0 0 0 0.55 0.6 0 0]; % p
x6 = [zeros(1,4) 0.55 0 1.2 0.5 1.8]; % q
x7 = [zeros(1,4) 0.6 1.2 zeros(1,3)]; % r
x8 = [0 0.37 0.9 0 0 0.5 0 0 1.4]; % x
x9 = [0 0 1.6 0 0 1.8 0 1.4 0]; % y

c = [x1 x2 x3 x4 x5 x6 x7 x8 x9]; % costs of all edges
b = ones(9,1)*2;

% all eight of the subtour elimination constraints
S = [zeros(1, 50) 1 zeros(1, 9) 1 zeros(1, 6) 1 zeros(1, 14) % x_pq + x_qr + x_rp <= 2
    ] 
% we will need to add the constraint Sx <= 2, so we can append S to A

A = zeros(9,81);
intcon = [1:81]; % says which variables have integer constraints (all of them)

% the constraint is that for all of the edges outgoing of a node, at most
% two can be used
for row = 1:9 % for each of the nine nodes
    columns = (row-1)*9+1:row*9;
    extract = c(columns);
    extract(extract~=0) = 1;
    A(row,columns) = extract;
end

% zeros(81, 1) are lower bounds
% ones(81, 1) are upper bounds
% c is the objective function value, which will weight all of the uses of
% there are no constraints Ax <= b, so we have two empty brackets as the
% third and fourth parameters
% we have Ax = b
[xopt,fopt]=intlinprog(c,intcon,[],[],A,b,zeros(81,1),ones(81,1));
cost = fopt;
edges = xopt;
edges_used = sum(edges);
rewrite_edges = zeros(edges_used,1);
count = 1;
for i = 1:size(edges,1)
    if(edges(i) == 1)
     rewrite_edges(count) = i;
     count = count + 1;
    end
end

rewrite_edges

size(edges,1)