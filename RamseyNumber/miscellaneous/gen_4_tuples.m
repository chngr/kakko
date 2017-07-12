% gen_4_tuples(): generates list of increasing (unordered) 4-tuples using 
%                 elements from {1,2,...,n}
% Input: n -- upper bound for list
% Output: k_tuples -- cell array with 4-tuples
function k_tuples = gen_4_tuples(n)
k_tuples = {};
for i = 1:n
    for j = 2:n
        for k = 3:n
            for l = 4:n
                if (i < j) && (j < k) && (k < l)
                    entry = [i,j,k,l];
                    k_tuples = [k_tuples, entry];
                end
            end
        end
    end
end
end