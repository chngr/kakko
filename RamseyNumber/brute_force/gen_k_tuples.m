% gen_k_tuples(): generates list of increasing (unordered) k-tuples using 
%                 elements from {1,2,...,n}
% Input: n -- upper bound for list 
%        k -- number of elements selected
% Output: k_tuples -- cell array with k_tuples
function k_tuples = gen_k_tuples(n,k)
test_cell = {};
% recursion
if k > 1
    k_tuples = cell_helper(gen_k_tuples(n,k-1),n); 
% base case
else
   for i = 1:n
       test_cell{i} = [i];
   end
   k_tuples = test_cell;
end
end

% cell_helper(): helper method to perform recursion
% Input: cell_old -- input list with tuples of length x
%        max -- max element (n)
% Output: cell_new -- output list with tuples of length (x + 1)
function cell_new = cell_helper(cell_old, max)
cell_new = {};
for i = 1:length(cell_old)
    cur_array = cell_old{i};
    last_num = cur_array(length(cur_array));
    for j = last_num+1:max
        new_cur_array = [cur_array, j];
        cell_new{end+1} = new_cur_array;
    end
end
end