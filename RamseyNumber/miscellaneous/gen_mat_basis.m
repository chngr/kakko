% gen_mat_basis(): generates basis of 2^{n choose 2} symmetric adjacency 
%                  matrices (basis for labelled graphs)
% Input: n -- number of vertices in graph
% Output: basis -- cell array of basis matrices
function basis = gen_mat_basis(n)
str_length = nchoosek(n,2);
dim = 2^(str_length);
basis = cell([1,dim]);
% generate all possible binary strings to fill above the diagonal
for cell_idx = 0:(dim-1)
    bin_str = dec2bin(cell_idx);
    % pad with zeros if not of proper length
    if length(bin_str) < str_length
        bin_str = sprintf('%0*s', str_length, bin_str);
    end
    % fill matrix with string
    A = zeros(n);
    idx_pointer = 0;
    for i = 1:n
        for j = 1:n
            if j > i
                idx_pointer = idx_pointer + 1;
                A(i,j) = str2double(bin_str(idx_pointer));
            end
        end
    end
    % make matrix symmetric
    A = triu(A,1)' + A;
    basis{cell_idx+1} = A;
end
end