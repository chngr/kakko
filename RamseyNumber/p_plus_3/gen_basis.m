% gen_basis(): basis for all unlabelled graphs on (p+3) vertices with
% at least one K_p
% Input: input_file -- name of input_file with graphs on p+3 vertices
%        p -- dimension of K_p
% Output: map with basis, set of representative basis tuples
function [map, unique_values] = gen_basis(input_file,p)
tuple_map = containers.Map;
% generate set of unique basis elements
basis = parse_data(input_file,p);
% all possible permutations of 3 indices
permute_indices = {[1,2,3],[1,3,2],[2,1,3],[2,3,1],[3,1,2],[3,2,1]};
% for each basis element
for i = 1:length(basis)
    cur_mat = basis{i};
    % set of candidates to check for K_p
    tuple_candidates = gen_k_tuples(p+3,p);
    tuple_image = {};
    % for each candidate
    for j = 1:length(tuple_candidates)
        cur_tuple = tuple_candidates{j};
        % check if candidate forms a monochromatic K_p
        sum = 0;
        for k = 1:length(cur_tuple)
            for l = (k+1):length(cur_tuple)
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
        tuple_diff = setdiff(1:p+3,k_p_indices);
        for q = 1 : length(permute_indices) % go through all permutations of last 3 columns
            % compute a through h
            a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0;
            for k = 1:length(k_p_indices)
                if cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 1
                    a = a + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 0
                    b = b + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 1
                    c = c + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 0
                    d = d + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 1
                    e = e + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 1 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 0
                    f = f + 1;
                elseif cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(1))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(2))) == 0 && ...
                        cur_mat(k_p_indices(k),tuple_diff(permute_indices{q}(3))) == 1
                    g = g + 1;
                else
                    h = h + 1;
                end
            end
        end
        % compute x, y, z
        x = cur_mat(k_p_indices(1),k_p_indices(2));
        y = 2 * cur_mat(tuple_diff(1),tuple_diff(2)) + ...
            cur_mat(tuple_diff(1),tuple_diff(3));
        z = cur_mat(tuple_diff(2),tuple_diff(3));
        alphabet_values{end+1} = [x,a,b,c,d,e,f,g,h,y,z];
    end
    % find representative tuple
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