% basis_size(): computes the expected size of the basis
% Input: dimension of space p
% Output: expected size of basis
function result = basis_size(p)
solutions = {};
for a = p:-1:0
    for b = (p-a):-1:0
        for c = min(b,p-a-b):-1:0
            d = p - a - b - c;
            solutions{end+1} = [a,b,c,d];
        end
    end
end
result = length(solutions) - 2*p + 2;
end