% construct_generator() -- construct generators according to 
% Input: partition_arr
% Output: 

function [E,F] = construct_generator(max_val,partition_arr)
whole_size = sum(partition_arr);
E_block_mat = {};
F_block_mat = {};
num_partitions = length(partition_arr);

% get all blocks
for i = 1:num_partitions            % height coord of block
    for j = 1:num_partitions   % length corrd of block
        block_height = partition_arr(i);
        block_length = partition_arr(j);
        if j == i+1 % superdiag
            temp_cell = block_gen(block_height,block_length,max_val);
            E_block_mat{end+1} = temp_cell{1};
            F_block_mat{end+1} = temp_cell{2};
        end
    end
end

E = blocks_2_matrix(E_block_mat,num_partitions,whole_size);
F = blocks_2_matrix(F_block_mat,num_partitions,whole_size);
end


function result_mat = blocks_2_matrix(block_mat,num_partitions,whole_size, gen)
result_mat = zeros(whole_size);
for i = 1: length(num_partitions)
    % concatenate each block
    cur_row = 0;
    for j = 1: length(num_partitions)
        if gen == 'E' && j == i+1
            cur_block = block_mat{i};
        else gen == 'F' && j == i-1
            cur_block = block_mat{i};
        end
    end
    if i == 1
        result_mat = cur_row;
    else
        result_mat = [result_mat; cur_row];
    end
end
end


