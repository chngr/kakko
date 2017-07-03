% gen_mat_basis(): generates basis of 2^{n choose 2} symmetric adjacency 
% matrices 
% Input: dimension of vector space n // Output: cell object with matrices
function basis = gen_mat_basis(n)
str_length = nchoosek(n,2);
dim = 2^(str_length);
basis = cell([1,dim]);
for cell_idx = 0:(dim-1)
    bin_str = dec2bin(cell_idx);
    if length(bin_str) < str_length
        bin_str = sprintf('%0*s', str_length, bin_str);
    end
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
    A = triu(A,1)' + A;
    basis{cell_idx+1} = A;
end
end