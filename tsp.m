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

% all eight of the subtour elimination constraints
P = [zeros(1,3) 1 zeros(1, 23) 1 zeros(1, 53); % ad, da:4 and 28
    zeros(1, 21) 1 zeros(1, 7) 1 zeros(1, 51); % cd, dc: 22 and 30
    zeros(1, 11) 1 zeros(1, 7) 1 zeros(1, 61); % bc, cb: 12, 20
    zeros(1, 16) 1 zeros(1, 47) 1 zeros(1, 16); % bx, xb: 17, 65
    zeros(1, 42) 1 zeros(1, 15) 1 zeros(1, 22); % pr, rp: 43, 59
    zeros(1, 41) 1 zeros(1, 7) 1 zeros(1, 31); % pq, qp: 50, 42
    zeros(1, 52) 1 zeros(1, 15) 1 zeros(1, 12); % qx, xq: 53, 69
    zeros(1, 41) 1 zeros(1, 9) 1 zeros(1, 6) 1 zeros(1, 22);  % pqr: pq(42) + rp(59) + qr(52) 
    0 1 zeros(1, 9) 1 zeros(1, 9) 1 zeros(1, 5) 1 zeros(1, 53); % abcd: ab(2) + bc(12) + cd(22) + da(28)
    zeros(1, 11) 1 zeros(1, 13) 1 zeros(1, 45) 1 0 1 zeros(1, 7)]; % bcxy: bc(12) cx(26) xy(72) yb(74)
    
s = [1; 1;1;1;1;1;1;2;3;3];


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

B = zeros(36, 81); % 81 - 9 = 72, since we do not want any x_aa + x_aa <= 1
row_count = 1; % write each constraint in the next row
for i = 1:9
    for j = 1:9
        if i ~= j && j > i % we want to have x_ij + x_ji <= 1
            if row_count == 33
                disp('at 33')
                disp(i)
                disp(j)
                disp(9 * (i - 1) + j)
                disp(9 * (j - 1) + i)
            end
            B(row_count, 9 * (i - 1) + j) = 1;
            B(row_count, 9 * (j - 1) + i) = 1;
            row_count = row_count + 1;
        end
    end
end
%B(33, :)
%S = B(1:33, :); % subtour elimination constraints
b = ones(9,1)*2; % adjusted since there are now new constraints to eliminate subtours

% zeros(81, 1) are lower bounds
% ones(81, 1) are upper bounds
% c is the objective function value, which will weight all of the uses of
% there are no constraints Ax <= b, so we have two empty brackets as the
% third and fourth parameters
% we have Ax = b
[xopt,fopt]=intlinprog(c,intcon,P,s,A,b,zeros(81,1),ones(81,1));
cost = fopt;
edges = xopt;
edges_used = sum(edges)
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