% function: rearrange the matrix to block form
% input: matrix (N*n) N: dimension of g, n: dimension of cartan h
% output: rearranged matrix in block form
function result_mat = rearrange_mat(mat)
n = size(mat,2);
range_set = get_range_set(mat);
block_index_set = get_block_index(range_set,n);
result_mat = block_to_mat(block_index_set,mat);
if check_blocks(result_mat)
    fprintf('block matrix not square!!')
end
end

% function: check_blocks -- check if rearranged matrix has square
% input: mat
% output: boolean if the blocks qualify as square matrices
function check_blocks(mat)
    
end

% :)
% function: range_set -- get range set for all columns
% input: mat
% output: range set of all columns
function range_set = get_range_set(mat)
% get range_pair for each column
range_set = {};
head_flag = false;
for i = 1:size(mat,2) % iterate through each column
    cur_col = mat(:,i);
    % going through elements ith column
    head = 0; tail = 0;
    head_flag = false;
    for j = 1:length(cur_col)
        % mark head
        if cur_col(j) ~= 0 && head_flag == false
            head_flag = true;
            head = j;
            tail = j;
        end
        % mark tail
        if cur_col(j) ~= 0 && head_flag == true
            tail = j;
        end
    end
    range_set{end+1} = [head,tail];
end
end

%:)
% function: get_block_index -- partition columns into block groups
% input: cell array of range-pairs(i.e the range of non-zero entries in each column)
%        n: size of matrix
% output: cell array of the indice tuples of columns in each block
function block_index = get_block_index(pair_arr,n)
index_arr = (1:n);
block_index = {};
% init first column with head = 1
while ~isempty(index_arr)
    % set of indices in new_block
    min_index = find_min_head(index_arr, pair_arr);
    block_index{end+1} = find_block(min_index, pair_arr);
    index_arr = setdiff(index_arr, block_index{end});
end
end

%:)
% function find_block: find index array of block containing one column
% input: index of one column
% output: index_set of the block
function block_index = find_block(start_index, pair_arr)
block_index = [];
for i = 1:length(pair_arr)
    if intersect(pair_arr{start_index},pair_arr{i})
        block_index = [block_index, i];
    end
end
end

%:)
% function find_min_pair: finds index of column with min head in the column set
% input: pair_arr
% output: index of column with min_head
function min_index = find_min_head(index_arr, pair_arr)
% index of column with min head
min_index = index_arr(1);
min_head = pair_arr{index_arr(1)}(1);
for i = 1 : length(index_arr)
    if pair_arr{index_arr(i)}(1) < min_head
        min_index = index_arr(i);
    end
end
end

%:)
% function: block_to_mat -- block index set to result matrix
% input: block_index: index array of each block
% output: result matrix
function result_mat = block_to_mat(block_index,mat)
result_mat = [];
for i = 1:length(block_index)
    cur_block = block_index{i};
    for j = 1:length(cur_block)
        result_mat = [result_mat, mat(:,cur_block(j))];
    end
end
end

%:)
% function: intersect(A,B) -- check if ranges A B have intersection
% input: A, B
% output: boolean if they intersect
function result = intersect(A,B)
result = true;
if A(1) > B(2) || A(2) < B(1)
    result = false;
end
end