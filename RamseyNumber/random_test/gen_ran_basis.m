% gen_ran_basis: generate all possible random basis elements
% input: size of matrices
% output: random basis of corresponding size

function result_basis = gen_ran_basis(size)
result_basis = {};
binary_set = gen_ran_binary(size);
for i =  1:length(binary_set)
    cur_matrix = zeros(size);
    cur_binary = binary_set{i};
    fprintf("current_binary:\n")
    disp(cur_binary)
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
                fprintf("cur_digit:\n")
                disp(cur_binary(count))
                fprintf("cur_matrix:\n")
                disp(cur_matrix)
            end  
        end
    end
    fprintf("current matrix:\n")
    disp(cur_matrix)
    if ~isequal(cur_matrix, cur_matrix')
        result_basis{end+1} = cur_matrix;
    end
end
end

