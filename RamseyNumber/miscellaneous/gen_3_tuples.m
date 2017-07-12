% gen_3_tuples(): generates list of increasing (unordered) 3-tuples using 
%                 elements from {1,2,...,n}
% Input: n -- upper bound for list  
% Output: k_tuples -- cell array with 3-tuples
function k_tuples = gen_3_tuples(n)
k_tuples = {};
for i = 1:n
    for j = 2:n
        for k = 3:n
            if (i < j) && (j < k)
                entry = [i,j,k];
                k_tuples = [k_tuples, entry];
            end
        end
    end
end
end