% gen_sub_block(): generate all possible blocks with entries 0/1
% all zero case is deleted for failure in trial
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
% delete first element from result(all 0 case fail in gap)
result_cell(1) = [];
end