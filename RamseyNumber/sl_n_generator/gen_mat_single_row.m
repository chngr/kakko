% This file tests cases when each block has one row containing 1's


function result_set = gen_mat_single_row(partition,file_name)
result_E = gen_mat_single_row_helper(partition);
result_set = {};
for i = 1:length(result_E)
    cur_E = result_E{i};
    result_set{end+1} = [cur_E,cur_E'];
end
test_print(result_set, file_name)
end



% gen_mat_single_row: generate all possible matrices according to above
% trial
% input: partition
% output: set of all matrices satisfying single row of non-zeros
function result_mat = gen_mat_single_row_helper (partition)
result_mat = {};
whole_size = sum(partition);
temp_partition = partition;
temp_partition(length(temp_partition)) = [];

indices_set = gen_indices(temp_partition); % all selection of rows

str_set = gen_str(partition); % all selection of strings for filling
row_sum_set = get_sum_set_1(partition);

col_sum_set = get_sum_set_2(partition);

for i = 1:length(str_set)  % loop through all strings to fill in
    for j = 1:length(indices_set) % loop through all selection of indices
        cur_mat = zeros(whole_size);
        cur_indices = indices_set{j};
        cur_bin_str = str_set{i};
        % k is index of block, filling in blocks according to string
        for k = 1:length(partition)-1 % k: index of string set, indices set, and block
            % cur block index in string is 
            cur_head_col = col_sum_set(k)+ partition(1);
            cur_str_head = col_sum_set(k);
            cur_row = cur_indices(k)+row_sum_set(k);
            cur_block_length = partition(k+1);
            for p = 1:cur_block_length
                cur_mat(cur_row,cur_head_col + p) = str2num(cur_bin_str(cur_str_head+p));
            end
        end
        % finish filling in cur_mat, add to result_set
        result_mat{end+1} = cur_mat;
    end  
end
end

% gen_bin_str: generate all binary string sets according to test
% strings have lengths p(2)...p(k)
% input: partition
% output: set of all posssible binary strings
function str_set = gen_str(partition)
str_length = sum(partition) - partition(1);
str_set = gen_bin_str(str_length);
sum_set = get_sum_set_2(partition); % {0,p(2),...p(k)}
for index = length(str_set):-1:1
    cur_str = str_set{index};
    for j = 1: length(partition) - 1
        head = sum_set(j)+1;
        tail = sum_set(j+1);
        if is_all_0(cur_str(head:tail))
            str_set(index) = [];
            break;
        end
    end
end
end


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

