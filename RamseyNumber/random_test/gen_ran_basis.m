% gen_ran_basis: generate all possible random basis elements
% input: size of matrices
% output: random basis of corresponding size

function result_basis = gen_ran_basis(size)
result_basis = {};
binary_set = gen_ran_binary(size);
flag = true;
for i =  1:length(binary_set)
    cur_matrix = zeros(size);
    cur_binary = binary_set{i};
    count = 0;
    for j = 1:size
        for k = 1 : size
            % if on diagonal, keep as zero
            if j == k
                continue
                % if not on diagonal, fill in corresponding to string
            else
                count = count + 1;
                cur_matrix(j,k) = str2num(cur_binary(count));
            end
        end
    end
    flag = true;
    for j = 1:size
        for k = j+1:size
            % delete cases where sysmetric entries same
            if cur_matrix(j,k) == cur_matrix(k,j)
                flag = false;
            end
        end
    end
    if flag
        result_basis{end+1} = cur_matrix;
    end
end
end


