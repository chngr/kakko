% create_map(): create map from tuple to cell array with representative
% tuple and matrix of representative tuple
% Input: set of mixed_tuples to be further processed 
% Output: map from set of mixed_tuples to cell arrays
function [map, unique_values] = create_map(mixed_tuples,p)
tuple_map = containers.Map;
% for each mixed tuple
for i = 1:length(mixed_tuples)
    cur_mixed = mixed_tuples{i};
    % matrix for cur_mixed (current mixed tuple)
    init_mat = tuple_to_matrix(cur_mixed);
    % generate all possible p-tuples 
    tuple_set = gen_k_tuples(p+2,p);
    % stores the tuples that correspond to valid K_p
    tuple_image = {};
    % for each tuple in the tuple set
    for j = 1:length(tuple_set)
        % get the current tuple
        cur_tuple = tuple_set{j};
        % check if edge subset forms a monochromatic K_p
        sum = 0;
        for k = 1:length(cur_tuple)
            for l = (k+1):length(cur_tuple)
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
    alphabet_values = {};
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
            % if there are more (0,1) than (1,0), flip b and c
            if c > b
                [b,c] = deal(c,b);
            end
        end 
        alphabet_values{end+1} = [x,a,b,c,d,y];
    end
    rep_tuple = compare_tuples(alphabet_values);
    tuple_map(mat2str(cur_mixed)) = rep_tuple;
end
map = tuple_map;
map_values = values(map);
fprintf('Number of values in map: %d\n', length(map_values));
str_values = unique(cellfun(@mat2str,map_values,'UniformOutput',false));
unique_values = cellfun(@eval,str_values,'UniformOutput',false);
fprintf('Number of unique values in map: %d\n', length(unique_values));
end

% compare_tuples: finds the largest tuple in set lexicographically:
% compare a's for largest first, then b's, c's, d's
% Input: cell array of tuples
% Output: largest tuple
function result = compare_tuples(tuple_list)
mat_of_tuples = [];
for i = 1:length(tuple_list)
    mat_of_tuples(i,:) = tuple_list{i};
end
sorted_mat = sortrows(mat_of_tuples);
rep_tuple = sorted_mat(end,:);
result = rep_tuple;
end