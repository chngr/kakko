% rand_block_gen(): generates a random block of size dim_1 by dim_2
% Input: dim_1 -- one dimension of random block rectangle
%        dim_2 -- other dimension of random block rectangle
%        max_value -- random sampling from 1 to max_value
% Output: result -- cell array with random block matrix and its transpose
function result = rand_block_gen(dim_1, dim_2, max_value)

block = zeros(dim_1,dim_2);

% find half of indices to fill randomly
num_of_values = dim_1 * dim_2;
samp_size = (dim_1 * dim_2)/2;
index_samp = randsample(num_of_values, samp_size);







end