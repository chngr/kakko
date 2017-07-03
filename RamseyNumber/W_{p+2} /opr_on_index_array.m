% opr_on_index_array(index_arr, opr):
% Input: index_arr, opr: 'E' or 'F'
% Output:
% result_mat -- resulting mat corresponding to operation on index_arr
% Using subfunction: gen_opr_index()

function result_mat = opr_on_index_array(index_arr, opr, p,basis)
arr_size = length(index_arr);
result_mat = zeros(arr_size);
for i = 1:arr_size
    [result_list,~,~] = gen_opr_index(index_arr(i),opr,p,basis);
    for j = 1 : length(result_list)
        result_mat (find(index_arr == result_list(j)),i) = 1;
    end
end
end