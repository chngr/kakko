% print_blocks(): prints subblocks of E and F
% Input: block_map -- map from sublocks [E_sub,F_sub] to frequency
% Output: printed: each subblock [E_sub,F_sub] followed by its frequency
function print_blocks(block_map)
key_set = keys(block_map);
for i = 1:length(key_set)
   mat = eval(key_set{i});
   freq = block_map(key_set{i});
   fprintf('frequency: %d\n', freq);
   disp(mat);
   fprintf('\n');
end
[sum, total_size] = freq_sum(block_map);
fprintf('sum of frequencies: %d\n', sum);
fprintf('total size of E and F: %d\n', total_size);
end

% freq_sum(): computes sum of frequencies of subblocks
% Input: block_map -- map from sublocks [E_sub,F_sub] to frequency
% Output: sum -- sum of frequencies of subblocks
%         total_size -- size of E and F (sanity check)
function [sum, total_size] = freq_sum(block_map)
key_set = keys(block_map);
sum = 0;
total_size = 0;
for i = 1:length(key_set)
    cur_mat = eval(key_set{i});
    row_size = size(cur_mat,1);
    sum = sum + block_map(key_set{i});
    total_size = total_size + row_size * block_map(key_set{i});
end
end