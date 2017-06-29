% gen_tuple_sum(): solves a + b + c + d = p in integers
% Input: value of p
% Output: (p + 3) choose 3 solutions (a,b,c,d) in cell array
function result = gen_tuple_sum(p)
tuples = cell(0);
for a = p:-1:0
    for b = (p-a):-1:0
        for c = (p-a-b):-1:0
            tuples{end+1} = [a, b, c, p-a-b-c];
        end
    end
end
result = tuples;
end