% construct_generator(): construct generators E and F for random testing
% Input: max_value -- max value for random int selection
%        partition_arr -- array with partitions
% Output: E and F matrices
function [E,F] = construct_generator(max_val,partition_arr)
mat_size = sum(partition_arr);
E_mat = zeros(mat_size);
F_mat = zeros(mat_size);
num_partitions = length(partition_arr);
% build E and F
for i = 1:num_partitions       % height coord of block
    for j = 1:num_partitions   % length coord of block
        block_height = partition_arr(i);
        block_length = partition_arr(j);            
        if j == i+1 % superdiag
            temp_cell = block_gen(block_height,block_length,max_val);
            % range for the row coordinates
            row_coord_1 = 0;
            row_coord_2 = 0;
            for p = 1:i-1
                row_coord_1 = row_coord_1 + partition_arr(p);
            end
            row_coord_2 = row_coord_1 + partition_arr(i);
            row_coord_1 = row_coord_1 + 1;
            % range for the column coordinates
            col_coord_1 = 0;
            col_coord_2 = 0;
            for q = 1:j-1
                col_coord_1 = col_coord_1 + partition_arr(q);
            end
            col_coord_2 = col_coord_1 + partition_arr(j);
            col_coord_1 = col_coord_1 + 1;
            % put the blocks in the bigger matrix
            E_mat = place_block(E_mat,temp_cell{1},[row_coord_1,row_coord_2,col_coord_1,col_coord_2]);
            F_mat = place_block(F_mat,temp_cell{2},[col_coord_1,col_coord_2,row_coord_1,row_coord_2]);
        end
    end
end
E = E_mat;
F = F_mat;
end