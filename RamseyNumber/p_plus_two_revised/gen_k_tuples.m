% gen_k_tuples(): generates list of unordered k-tuples using 
% elements from {1,2,...,n}
% Input: upper bound for list n, number of elements selected k
% Output: cell object with k-tuples
function k_tuples = gen_k_tuples(n,k)
test_cell = {};
% perform recursion
if k > 1
    k_tuples = cell_helper(gen_k_tuples(n,k-1),n); 
% else, base case 
else
   for i = 1:n
       test_cell{i} = [i];
   end
   k_tuples = test_cell;
end
end

% cell_helper(): helper method to perform recursion
% Input: list of (x - 1)-tuples in cell_old 
% Output: list of x-tuples going up to the max item
function cell_new = cell_helper(cell_old, max)
cell_new = {};
for i = 1:length(cell_old)
    cur_array = cell_old{i};
    last_num = cur_array(length(cur_array));
    for j = (last_num+1):max
        new_cur_array = [cur_array, j];
        cell_new{end+1} = new_cur_array;
    end
end
end