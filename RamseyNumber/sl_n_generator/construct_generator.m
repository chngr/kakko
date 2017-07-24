% construct_generator() -- construct generators according to 
% Input: partition_arr
% Output: 

function [E,F] = construct_generator(max_val,partition_arr)
E_block_mat = {};
F_block_mat = {};
num_blocks = length(partition_arr);

% get all blocks
for i = 1:num_blocks            % height coord of block
    for j = 1:num_blocks   % length corrd of block
        block_height = parition_arr(i);
        block_length = partition_arr(j);
        if j == i+1 % not subdiag block
            temp_cell = block_gen(block_height,block_length,max_val);
            E_block_mat{end+1} = temp_cell{1};
        else
            E_block_mat{end+1} = zeros(block_height,block_length);
        end
    end
end

for i = 1:num_blocks            % height coord of block
    for j = 1:num_blocks   % length corrd of block
        block_height = parition_arr(i);
        block_length = partition_arr(j);
        if j == i-1 % not subdiag block
            temp_cell = block_gen(block_height,block_length,max_val);
            E_block_mat{end+1} = temp_cell{2};
        else
            F_block_mat{end+1} = zeros(block_height,block_length);
        end
    end
end
E = blocks_2_matrix(E_block_mat);
F = blocks_2_matrix(F_block_mat);
end


function result_mat = blocks_2_matrix(block_mat)
result_mat = 0;
for i = 1: length(block_mat)
    % concatenate each block
    cur_row = block_mat{1};
    for j = 1: length(block_mat)
        cur_block = block_mat{(i-1)*num_blocks + j};
        cur_row = [cur_row, cur_block];
    end
    if i == 1
        result_mat = cur_row;
    else
        result_mat = [result_mat; cur_row];
    end
end
end


