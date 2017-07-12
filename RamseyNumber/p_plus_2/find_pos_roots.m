% find_pos_roots(): compute the positive roots
% Input: root_mat -- unprocessed root matrix
% Output: pos_roots -- cell array of positive roots
function pos_roots = find_pos_roots(root_mat)
num_rows = size(root_mat,1);
num_cols = size(root_mat,2);
for i = 1:num_rows
    cur_row = root_mat(i,:);
    if isequal(cur_row,zeros(1,num_cols))
        root_mat(i,:) = [];
    end
end
is_valid = false;
index = 0;
while ~is_valid
    scaling = generate_scaling(index);
    index = index + 1;
    is_valid = is_valid_scaling(root_mat,scaling);
end
pos_roots = {};
for i = 1:num_rows
    cur_row = root_mat(i,:);
    if dot(cur_row,scaling) > 0
        pos_roots{end+1} = cur_row;
    end
end
end

% is_valid_scaling(): checks if scaling vector is valid
% Condition: after removing zero rows of root matrix, all inner products
% should be nonzero
% Input: root_mat -- root matrix with rows of zeros removed
%        scaling -- vector to take inner product with
% Output: result -- boolean true if scaling vector is valid
function result = is_valid_scaling(root_mat, scaling)
num_rows = size(root_mat,1);
num_cols = size(root_mat,2);
is_valid = true;
for i = 1:num_rows
   cur_row = root_mat(i,:);
   if isequal(dot(cur_row,scaling),zeros(1,num_cols))
       is_valid = false;
   end
end
result = is_valid;
end

% generate_scaling(): generates a scaling vector to dot with
% Input: index -- offset of vector (starting from 0)
% Output: result -- scaling vector
function result = generate_scaling(index)
scaling = 1:n;
for i = 1:length(scaling)
    scaling(i) = i + index;
end
result = scaling;
end