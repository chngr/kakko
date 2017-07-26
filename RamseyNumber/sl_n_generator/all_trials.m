% all_trials(): given partition, constructs all matrices with 0,1-blocks
%               on super- and subdiagonal
% Input: partition -- array of ints with partition 
%        file_name -- GAP file name
% Output: outputs GAP file
function test_set = all_trials(partition,file_name)
[result_set,test_set] = all_trials_helper(partition);
test_print(result_set, file_name)
end

function [result_set,test_set] = all_trials_helper(partition)
result_set = {}; % all possible [E,F] pairs, for printing
test_set = {}; % all possible {E,F} pairs, for calculation
whole_size = sum(partition);

% store index cuts of each block
index_pointers = [];
index_pointers = [index_pointers,0];
total = 0;
for i = 1:length(partition)
    total = total + partition(i);
    index_pointers = [index_pointers,total];
end

all_blocks = gen_all_mat(partition);
% iterate through all possible set of blocks
for i = 1:length(all_blocks)
    cur_E = zeros(whole_size);
    cur_block_set = all_blocks{i};
    % fill in each block
    for j = 1:length(cur_block_set)
        cur_block = cur_block_set{j};
        row_coord_1 = index_pointers(j)+1;
        row_coord_2 = index_pointers(j+1);
        col_coord_1 = index_pointers(j+1)+1;
        col_coord_2 = index_pointers(j+2);
        cur_E(row_coord_1:row_coord_2,col_coord_1:col_coord_2) = cur_block;
    end
    cur_F = cur_E';
    result_set{end+1} = [cur_E,cur_F];
    test_set{end+1} = {cur_E,cur_F};
end
end


