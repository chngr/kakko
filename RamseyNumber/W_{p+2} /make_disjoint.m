% make_disjoint(): takes list of partitions and makes disjoint sets out of
% them
% Input: initial -- cell array with list of nondisjoint partitions
%        basis_length -- length of basis 
% Output: cell array with disjoint partitions
function result = make_disjoint(initial,basis_length)

for i = 1:basis_length
    index_set = [];
    for j = 1:length(initial)
        cur_list = initial{j};
        if ismember(i,cur_list)
            index_set = [index_set,j];
        end
    end
    initial = multi_merge(initial,index_set);
end
result = initial;
end

% function: multi_merge
% takes in cell of all arrays, and merge the ones with indices indicated by
% index_set
% output: resulting cell_arr
function result = multi_merge(cell_arr, index_set)
% index_set unique element, do nothing
index_set = sort(index_set);
for i = 2 : length(index_set)
    cell_arr{index_set(1)} = unique([cell_arr{index_set(1)},cell_arr{index_set(i)}]);
end
for i = length(index_set):-1:2
    cell_arr(index_set(i)) = [];
end
result = cell_arr;
end

