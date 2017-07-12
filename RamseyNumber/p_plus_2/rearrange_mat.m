% function: rearrange the matrix to block form
% input: matrix (N*n) N: dimension of g, n: dimension of cartan h
% output: rearranged matrix in block form
function result = rearrange_mat(mat)
% get range_pair for each column
range_pair_set = {};
head_flag = false;
tail_flag = false;
head = 0;
tail = 0;
for i = 1:size(mat,2) % iterate through each column
    cur_col = mat(:,i);
    % going through elements ith column
    for j = 1:length(cur_col)
        head_flag = false;
        tail_flag = false;
        if cur_col(j) ~= 0 && head_flag == false
            head_flag = true;
            head = j;
        end
        if cur_col(j) == 0 && head_flag == false
            continue
        end
        
    end
end
end


% function: get_block_index --
% input: cell array of range-pairs(i.e the range of non-zero entries in each column)
% output: cell array of the indice tuples of columns in each block
function get_block_index(range_arr)
for i = 1:length(range_arr)
    
end
end