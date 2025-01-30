% costs
x1 = [0 0.5 0.7 0.4 0 0 0 0 0];
x2 = [0.5 0 0.45 0.8 2.1 0 0 0.37 0];
x3 = [0.7 0.45 0 0.65 0 0 0 0.9 1.6];
x4 = [0.4 0.8 0.65 zeros(1,6)];
x5 = [0 2.1 0 0 0 0.55 0.6 0 0];
x6 = [zeros(1,4) 0.55 0 1.2 0.5 1.8];
x7 = [zeros(1,4) 0.6 1.2 zeros(1,3)];
x8 = [0 0.37 0.9 0 0 0.5 0 0 1.4];
x9 = [0 0 1.6 0 0 1.8 0 1.4 0];

c = [x1 x2 x3 x4 x5 x6 x7 x8 x9];
b = ones(9,1)*2;

A = zeros(9,81);
intcon = [1:81];

for row = 1:9
    columns = (row-1)*9+1:row*9;
    extract = c(columns);
    extract(extract~=0) = 1;
    A(row,columns) = extract;
end

% integer program w/o subtour constraint
[xopt,fopt]=intlinprog(c,intcon,[],[],A,b,zeros(81,1), ...
        ones(81,1));
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
%% 
elements = [1,2,3,4,5,6,7,8,9];
combnz = {1,1,1,1,1,1,1,1};
for chosen = 2:9
   combnz{chosen-1} = combnk(elements,chosen);
end
two_subsets = combnz{1};
trial = two_subsets(1:10,:);
trial_matrix = zeros(10,81)