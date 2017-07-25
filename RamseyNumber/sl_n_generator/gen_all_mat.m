% gen_all_mat
% input: partition
% output: all possible set of blocks corresponding to binary string

function result_set = gen_all_mat(partition)
result_set = {};
str_length = length_helper(partition);
bin_str_set = gen_bin_str(str_length);
for i = 1:length(bin_str_set)
    cur_bin_str = bin_str_set{i};
    result_set{end+1} = gen_blocks(cur_bin_str,partition);
end
end



function blocks = gen_blocks(bin_str,partition)
blocks = {};
sum = 0;
for i = 1:length(partition)-1
    % head and tail index within string
    cur_head = sum+1;
    cur_h = partition(i);
    cur_l = partition(i+1);
    sum = sum + cur_h * cur_l;
    cur_tail = sum;
    cur_bin = bin_str(cur_head:cur_tail);
    blocks{end+1} = bin_2_mat(cur_bin,cur_h,cur_l);
end
end


% convert binary string to matrix for single matrix
% input: h -- h; l -- length
function mat = bin_2_mat(bin_str,h,l)
mat = zeros(h,l);
for i = 1:h
    for j = 1: l
        cur_index = (i-1)*l + j;
        mat(i,j) = str2num(bin_str(cur_index));
    end
end
end

% gen_sub_block(): generate all possible blocks with entries 0/1
% input: h, length
% output: array of all possible
function result_cell = gen_bin_str(str_length)
result_cell = {};
dim = 2^(str_length)-1;
% generate all possible binary string
for i = 0:dim
    % convert decimal to binary
    bin_str = dec2bin(i);
    % pad string with 0s if not long enough
    if length(bin_str) < str_length
        bin_str = sprintf('%0*s', str_length, bin_str);
    end
    result_cell{end+1} = bin_str;
end
end

