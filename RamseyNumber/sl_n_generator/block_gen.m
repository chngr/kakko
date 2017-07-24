% block_gen(): generates a random block of size dim_1 by dim_2 with
%              values ranging from 0 to max_value
% Input: dim_1 -- first dimension of block
%        dim_2 -- second dimension of block
%        max_value -- upper bound for random number selection
% Output: result -- cell array with block and its transpose 
% Note: Block and transpose have corresponding indices filled with 
%       nonzeros, but not necessarily corresponding values.
function result = block_gen(dim_1,dim_2,max_value)
block_1 = zeros(dim_1,dim_2);
block_2 = zeros(dim_2,dim_1);
% number of entries in block
total_num = dim_1 * dim_2;
% sample to find indices of the entries to fill
samp = randsample(total_num, randi(total_num));
% for each randomly selected index
for i = 1:length(samp)
    cur_coord = samp(i);
    % find coordinates
    coord_1 = ceil(cur_coord/dim_2);
    coord_2 = rem(cur_coord,dim_2);
    % fix case where remainder is 0 by switching offset to end of line
    if coord_2 == 0
        coord_2 = dim_2;
    end
    % fill the block and its transpose
    block_1(coord_1,coord_2) = randi(max_value);
    block_2(coord_2,coord_1) = randi(max_value);
end
result = {block_1, block_2};
end