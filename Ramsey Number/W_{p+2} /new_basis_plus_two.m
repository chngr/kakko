% new_basis_plus_two(): generates basis using (a,b,c,d) scheme with 
% triangles of 1s and 0s; size of basis = 4 * ((p + 3) choose 3)
% Input: dimension of space p
% Output: cell array of basis elements
function result = new_basis_plus_two(p)
basis = cell(0);
tuples_list = gen_tuple_sum(p);
for i = 0:1
    for j = 1:length(tuples_list)
        cur_mat_ones = ones(p+2) - eye(p+2);
        cur_mat_zeros = zeros(p+2);
        cur_tuple = tuples_list{j};
        bound_1 = cur_tuple(1);
        bound_2 = cur_tuple(1) + cur_tuple(2);
        bound_3 = cur_tuple(1) + cur_tuple(2) + cur_tuple(3);
        % fill in the (1,1)
        for a = 1:bound_1
            cur_mat_ones(a,p+1) = 1;
            cur_mat_ones(a,p+2) = 1;
            cur_mat_zeros(a,p+1) = 1;
            cur_mat_zeros(a,p+2) = 1;
        end 
        % fill in the (1,0)
        for b = (bound_1 + 1):bound_2
            cur_mat_ones(b,p+1) = 1;
            cur_mat_ones(b,p+2) = 0;
            cur_mat_zeros(b,p+1) = 1;
            cur_mat_zeros(b,p+2) = 0;
        end
        % fill in the (0,1)
        for c = (bound_2 + 1):bound_3
            cur_mat_ones(c,p+1) = 0;
            cur_mat_ones(c,p+2) = 1;
            cur_mat_zeros(c,p+1) = 0;
            cur_mat_zeros(c,p+2) = 1;
        end
        % fill in the (0,0)
        for d = (bound_3 + 1):p
            cur_mat_ones(d,p+1) = 0;
            cur_mat_ones(d,p+2) = 0;
            cur_mat_zeros(d,p+1) = 0;
            cur_mat_zeros(d,p+2) = 0;
        end
        % fill in the last entry 
        cur_mat_ones(p+1,p+2) = i;
        cur_mat_zeros(p+1,p+2) = i;
        basis{end+1} = triu(cur_mat_ones,1)' + triu(cur_mat_ones);
        basis{end+1} = triu(cur_mat_zeros,1)' + triu(cur_mat_zeros);
    end
end
result = basis;

end

