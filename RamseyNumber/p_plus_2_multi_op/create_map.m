% create_map(): create map from tuple to its representative tuple
% Input: mixed_tuples -- set of tuples with potential duplicates
%        p -- dimension of K_p
% Output: map -- from tuple to representative 
%         unique_values -- set of unique tuples in basis
function [map, unique_values] = create_map(mixed_tuples,p)
tuple_map = containers.Map;
% for each mixed tuple
for i = 1:length(mixed_tuples)
    cur_mixed = mixed_tuples{i};
    init_mat = tuple_to_matrix(cur_mixed);
    % generate all possible p-tuples
    tuple_set = gen_k_tuples(p+2,p);
    % store the tuples that correspond to valid K_p
    tuple_image = {};
    % for each tuple in the tuple set
    for j = 1:length(tuple_set)
        % get the current tuple
        cur_tuple = tuple_set{j};
        % check if edge subset forms a monochromatic K_p
        sum = 0;
        for k = 1:length(cur_tuple)
            for l = k+1:length(cur_tuple)
                sum = sum + init_mat(cur_tuple(k),cur_tuple(l));
            end
        end
        if sum == nchoosek(p,2)
            tuple_image{end+1} = cur_tuple;
        end
        if sum == 0
            tuple_image{end+1} = cur_tuple;
        end
    end
    % store values of x, a, b, c, d, y
    alphabet_values = {};
    % for every tuple that forms a valid K_p
    for j = 1:length(tuple_image)
        k_p_indices = tuple_image{j};
        tuple_diff = setdiff([1:p+2],k_p_indices);
        % determine the values of x, a, b, c, d, y
        x = init_mat(k_p_indices(1), k_p_indices(2));
        y = init_mat(tuple_diff(1), tuple_diff(2));
        a = 0; b = 0; c = 0; d = 0;
        for k = 1:length(k_p_indices)
            if init_mat(k_p_indices(k),tuple_diff(1)) == 1 && ...
                    init_mat(k_p_indices(k),tuple_diff(2)) == 1
                a = a + 1;
            elseif init_mat(k_p_indices(k),tuple_diff(1)) == 1 && ...
                    init_mat(k_p_indices(k),tuple_diff(2)) == 0
                b = b + 1;
            elseif init_mat(k_p_indices(k),tuple_diff(1)) == 0 && ...
                    init_mat(k_p_indices(k),tuple_diff(2)) == 1
                c = c + 1;
            else 
                d = d + 1;
            end 
        end 
        % if there are more (0,1) than (1,0), flip b and c
        if c > b
            [b,c] = deal(c,b);
        end
        alphabet_values{end+1} = [x,a,b,c,d,y];
    end
    % find representative tuple and store in map
    rep_tuple = compare_tuples(alphabet_values);
    tuple_map(mat2str(cur_mixed)) = rep_tuple;
end
map = tuple_map;
map_values = values(map);
% find unique values
str_values = unique(cellfun(@mat2str,map_values,'UniformOutput',false));
unique_values = cellfun(@eval,str_values,'UniformOutput',false);
end

% compare_tuples(): finds the largest tuple in set lexicographically:
%                 compare x's for largest first, then a's, b's, c's, d's,
%                 y's
% Input: tuple_list -- cell array of tuples
% Output: result -- largest tuple by above ordering
function result = compare_tuples(tuple_list)
mat_of_tuples = [];
% fill matrix with tuples as rows
for i = 1:length(tuple_list)
    mat_of_tuples(i,:) = tuple_list{i};
end
% sort rows and return bottom row with largest tuple
sorted_mat = sortrows(mat_of_tuples);
rep_tuple = sorted_mat(end,:);
result = rep_tuple;
end