% gen_basis(): basis for unlabelled graphs for p+2, p=3 case
% Input: input_file -- name of input_file with graphs on p+2 vertices
%        p -- dimension of K_p
% Output: map -- map with basis
%         unique_values -- set of representative basis tuples (including 
%         permutations within vertices p+1, p+2)
function [map, unique_values] = gen_basis(input_file,p)
tuple_map = containers.Map;
% generate set of unique basis elements
basis = parse_data(input_file,p);
% all possible permutations of 2 indices
permute_indices = {[1,2],[2,1]};
% for each basis element
for i = 1:length(basis)
    cur_mat = basis{i};
    % set of candidates to check for K_p
    tuple_candidates = gen_k_tuples(p+2,p);
    tuple_image = {};
    % for each candidate
    for j = 1:length(tuple_candidates)
        cur_tuple = tuple_candidates{j};
        % check if candidate forms a monochromatic K_p
        sum = 0;
        for k = 1:length(cur_tuple)
            for l = k+1:length(cur_tuple)
                sum = sum + cur_mat(cur_tuple(k),cur_tuple(l));
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
    % for each tuple representing a K_p
    for j = 1:length(tuple_image)
        k_p_indices = tuple_image{j};
        tuple_diff = setdiff(1:p+2,k_p_indices);
        % go through all permutations of last 2 columns
        for q = 1:length(permute_indices) 
            % compute a through d
            a = 0; b = 0; c = 0; d = 0;
            for k = 1:length(k_p_indices)
                if cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 1
                    a = a + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 0
                    b = b + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 1 
                    c = c + 1;
                else
                    d = d + 1;
                end
            end
            % compute x, y, z
            x = cur_mat(k_p_indices(1),k_p_indices(2));
            y = cur_mat(tuple_diff(permute_indices{q}(1)),tuple_diff(permute_indices{q}(2)));
            % add result tuple to alphabet_values (including every possible permutations)
            alphabet_values{end+1} = [x,a,b,c,d,y];
        end
    end
    % alphabet_values contains all permutations of {p+1,p+2} and all selections of K_p 
    
    % delete duplicates within alphabet_values 
    alphabet_values_str = unique(cellfun(@mat2str,alphabet_values,'UniformOutput',false));
    alphabet_values = cellfun(@eval,alphabet_values_str,'UniformOutput',false);
    
    % find representative tuple (from alphabet_values) by taking the "max"
    rep_tuple = compare_tuples(alphabet_values);
    for j = 1:length(alphabet_values)
        tuple_map(mat2str(alphabet_values{j})) = rep_tuple;
    end
end
map = tuple_map;
% find unique representative values
map_values = values(map);
str_values = unique(cellfun(@mat2str,map_values,'UniformOutput',false));
unique_values = cellfun(@eval,str_values,'UniformOutput',false);
end

% compare_tuples: finds the largest tuple in set lexicographically:
%                 compare x's for largest first, then a's, b's, etc.
% Input: cell array of tuples
% Output: largest tuple
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