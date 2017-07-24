% place_block(): places a block inside of a matrix inside of the index
%                range
% Input: whole_mat -- bigger matrix to place block in
%        block -- block to place
%        index_range -- array of four indices (row_1,row_2,col_1,col_2); 
%        specifies block should be from row_1 to row_2 and from 
%        col_1 to col_2
% Output: result -- whole_mat with block placed inside
function result = place_block(whole_mat, block, index_range)
row_coord_1 = index_range(1);
row_coord_2 = index_range(2);
col_coord_1 = index_range(3);
col_coord_2 = index_range(4);
whole_mat(row_coord_1:row_coord_2,col_coord_1:col_coord_2) = block;
result = whole_mat;
end