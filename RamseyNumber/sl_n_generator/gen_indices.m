% gen_indices: generate all array of indices from range (2) to p(k)
% input: partition
% output: set of index tuples
function result_indices = gen_indices(partition)
result_indices = {};
list_len = length(partition);
old_partition = partition;
if list_len > 1
    len = length(old_partition);
    last_val = old_partition(len);
    old_partition(len) = [];
    result_indices = tuple_helper(gen_indices(old_partition),last_val);
else
    for i = 1:partition(1)
        result_indices{end+1} = [i];
    end
end
end

% subroutine for above recursion function
function new_indices = tuple_helper(old_indices,last_val)
new_indices = {};
for i = 1:length(old_indices)
    cur_tuple = old_indices{i};
    for j = 1:last_val
        new_cur_tuple = [cur_tuple,j];
        new_indices{end+1} = new_cur_tuple;
    end
end
end


% helper function: check bin_str all zero
function result = is_all_0(bin_str)
result = true;
for i = 1:length(bin_str)
    if bin_str(i) == '1'
        result = false;
    end
end
end

% helper function with indexing matrix
function sum_set = get_sum_set_2(partition)
sum_set = [0];
cur_sum = 0;
for i = 2:length(partition)
    cur_sum = cur_sum + partition(i);
    sum_set = [sum_set,cur_sum];
end
end

% helper function with indexing matrix
function sum_set = get_sum_set_1(partition)
sum_set = [0];
cur_sum = 0;
for i = 1:length(partition)-1
    cur_sum = cur_sum + partition(i);
    sum_set = [sum_set,cur_sum];
end
end
