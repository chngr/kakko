% mult_E_F(): performs E and F in sequence to given basis matrix
% Input: basis matrix A
% Output: cell with group of matrices after E and F ops

% mat_2_index: map from matrix to index
% index_2_mat: index to matrix
function result = mult_E_F(index,p,basis)
odd_op = '';
even_op = '';
old_list = [];
new_list = [index];

if isempty(gen_opr_index(index,'F',p,basis))
    odd_op = 'E';
    even_op = 'F';
else
    odd_op = 'F';
    even_op = 'E';
end
for i = 1:intmax
    temp_list = [];
    for j = 1:length(new_list)
        cur_index = new_list(j);
        if mod(i,2) ~= 0
            temp_list = [temp_list, gen_opr_index(cur_index,odd_op,p,basis)];
        else
            temp_list = [temp_list, gen_opr_index(cur_index,even_op,p,basis)];
        end
    end
    temp_list = unique(temp_list);
    temp_list = setdiff(temp_list, [old_list, new_list]);
    old_list = [old_list, new_list];
    new_list = temp_list;
    if isempty(temp_list)
        result = old_list;
        break;
    end
end
end