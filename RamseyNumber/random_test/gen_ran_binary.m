% gen_ran_binary: generate all possible binary strings representing the
% random matrix
% input: size of matrix
% output: set of binary strings
function binary_set = gen_ran_binary(size)
binary_set = {};
str_len = size * (size - 1);
max_val = 2 ^ str_len - 1;
% generate all possible binary strings with length str_len
for i = 0: max_val
    % convert decimal to binary
    bin_str = dec2bin(i);
    % pad string with 0s if not long enough
    if length(bin_str) < str_len
        bin_str = sprintf('%0*s', str_len, bin_str);
    end
    binary_set{end+1} = bin_str;
end
end