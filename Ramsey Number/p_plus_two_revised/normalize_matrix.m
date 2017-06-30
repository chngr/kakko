% normalize_matrix(): transforms matrix into normalized basis form
% (representative of isomorphism class)
% Input: initial matrix
% Output: normalized matrix
function result = normalize_matrix(init_mat)
% find the K_p
p = length(init_mat) - 2;
tuple_list = gen_k_tuples(p+2,p);
k_p_indices = [];
for i = 1:length(tuple_list)
    cur_tuple = tuple_list{i};
    sum = 0;
    % check if edge subset forms a monochromatic K_p
    for j = 1:length(cur_tuple)
        for k = (j+1):length(cur_tuple)
            sum = sum + init_mat(cur_tuple(j),cur_tuple(k));
        end
    end
    if sum == nchoosek(p,2)
        k_p_indices = cur_tuple;
        break;
    end
    if sum == 0
        k_p_indices = cur_tuple;
        break;
    end
end
% bring the K_p to the upper left
for i = 1:length(k_p_indices)
    % swap column i and column k_p_indices(i)
    init_mat(:,[i, k_p_indices(i)]) = init_mat(:,[k_p_indices(i), i]);
    % swap row i and row k_p_indices(i)
    init_mat([i, k_p_indices(i)],:) = init_mat([k_p_indices(i), i],:);
end
% determine values of a, b, c, and d
a = 0; b = 0; c = 0; d = 0;
for i = 1:p
    if init_mat(i,p+1) == 1 && init_mat(i,p+2) == 1
        a = a + 1;
    elseif init_mat(i,p+1) == 1 && init_mat(i,p+2) == 0
        b = b + 1;
    elseif init_mat(i,p+1) == 0 && init_mat(i,p+2) == 1
        c = c + 1;
    else
        d = d + 1;
    end
end
% if there are more (0,1) than (1,0), flip b and c
if c > b
    [b,c] = deal(c,b);
end
% order the 4-tuple (a,b,c,d) in the remaining two columns
bound_1 = a + b; bound_2 = a + b + c;
% set a coordinates: (1,1)
for i = 1:a
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 1;
end
% set b coordinates: (1,0)
for i = (a+1):bound_1
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 0;
end
% set c coordinates: (0,1)
for i = (bound_1+1):bound_2
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 1;
end
% set d coordinates: (0,0)
for i = (bound_2+1):p
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 0;
end
% leave y value alone and make matrix symmetric
result = triu(init_mat) + triu(init_mat)';
end