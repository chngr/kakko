% find_pos_roots(): compute the positive roots
% Input: root_mat -- unprocessed root matrix
% Output: pos_roots -- cell array of positive roots
function pos_roots = find_pos_roots(root_mat)
num_rows = size(root_mat,1);
num_cols = size(root_mat,2);
for i = num_cols:-1:1
    cur_col = root_mat(:,i);
    if isequal(cur_col,sym(zeros(num_rows,1)))
        root_mat(:,i) = [];
    end
end
assignin('base','root_mat_2',root_mat);
% update num_cols
num_cols = size(root_mat,2);
is_valid = false;
while ~is_valid
    scaling = sym(randi(100,num_rows,1));
    is_valid = is_valid_scaling(root_mat,scaling);
end
pos_roots = {};
for i = 1:num_cols
    cur_col = root_mat(:,i);
    if isequal(sign(dot(cur_col,scaling)),sym(1))
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
disp('Reached is_valid_scaling')
for i = 1:num_cols
   cur_col = root_mat(:,i);
   fprintf('Current iteration: %d', i)
   tic
   if isequal(dot(cur_col,scaling),sym(zeros(1)))
       toc
       is_valid = false;
       break;
   end
   toc
end
result = is_valid;
end