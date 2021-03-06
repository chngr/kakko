% gen_str_basis(): generates basis of 2^{n choose 2} binary strings of 
%                  length (n choose 2) representing matrix basis
% Input: n -- number of vertices in graph
% Output: basis -- cell array of string basis
function basis = gen_str_basis(n)
str_length = nchoosek(n,2);
dim = 2^(str_length);
basis = cell([1,dim]);
% up to length of dimension
for i = 0:(dim-1)
    % convert decimal to binary
    bin_str = dec2bin(i);
    % pad string with 0s if not long enough
    if length(bin_str) < str_length
        bin_str = sprintf('%0*s', str_length, bin_str);
    end
    basis{i+1} = bin_str;
end
end