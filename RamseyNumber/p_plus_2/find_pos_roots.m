% find_pos_roots(): compute the positive roots
% Input: root_mat -- unprocessed root matrix
% Output: pos_roots -- cell array of positive roots
function pos_roots = find_pos_roots(root_mat)
num_rows = size(root_mat,1);
num_cols = size(root_mat,2);
for i = num_cols:-1:1
    cur_col = root_mat(:,i);
    if isequal(cur_col,zeros(num_rows,1))
        root_mat(:,i) = [];
    end
end
% update num_cols
num_cols = size(root_mat,2);
is_valid = false;
while ~is_valid
    scaling = randi(100,num_rows,1);
    is_valid = is_valid_scaling(root_mat,scaling);
end
pos_roots = {};
for i = 1:num_cols
    cur_col = root_mat(:,i);
    if dot(cur_col,scaling) > 0
        pos_roots{end+1} = cur_col;
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
for i = 1:num_cols
   cur_col = root_mat(:,i);
   if dot(cur_col,scaling) == 0
       is_valid = false;
       break;
   end
end
result = is_valid;
end