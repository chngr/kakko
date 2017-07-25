% this file is for testing a hypothesis on power of sl_2 generated
% Hypothesis is wrong...

% get_test_dim: test dimension of matrix with #rows with different 1's
% input: bin_str of block, h, l
% output: result number
function result = get_test_dim (bin_str, h,l)
if strlength(bin_str) ~= h*l
    fprintf('ERR, dimension not match')
    return
end
num_set = [];
temp_str = bin_str;
for i = 1:h 
    cur_row = temp_str((i-1)*l+1:i*l);
    cur_count = count_1(cur_row);
    if isempty(find(num_set == cur_count)) && cur_count ~= 0
        num_set = [num_set, cur_count];
    end
end
result = length(num_set);
end


% count_1: subroutine for counting 1's
% input: bin_str
% output: counting of 1's
function count = count_1(bin_str)
count = 0;
for i = 1:length(bin_str)
    count = count + str2num(bin_str(i));
end
end