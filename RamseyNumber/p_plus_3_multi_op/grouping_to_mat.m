% grouping_to_mat(): constructs large E and F matrices (generators for
%                    space)
% Input: grouping -- cell array of groups of basis 
%        p -- dimension of K_p
%        map -- map from tuple to its representative tuple
% Output: E, F -- matrices representing E and F on the bases 
% NOTE: Removes duplicate pairs.
function [E,F] = grouping_to_mat(grouping,p,map)
E = [];
F = [];
block_map = containers.Map;
unique_comp_col = {};
for i = 1:length(grouping)
    [E_sub,F_sub] = opr_in_sub(grouping{i},p,map);
    pair_str = mat2str([E_sub,F_sub]);
    if isKey(block_map,pair_str)
        block_map(pair_str) = block_map(pair_str) + 1;
    else
        block_map(pair_str) = 1;
    end
    present = false;
    for j = 1:length(unique_comp_col)
        if isequal([E_sub,F_sub],unique_comp_col{j})
            present = true;
            break;
        end
    end
    if present == false
        E = blkdiag(E,E_sub);
        F = blkdiag(F,F_sub);
        unique_comp_col{end+1} = [E_sub,F_sub];
    end
end
file_name_g = strcat('blocks_',int2str(p),'_plus_3.txt');
print_to_gap(block_map,file_name_g);
end

% opr_in_sub(): constructs matrix of E and F in each subgroup
% Input: group -- subgroup to construct matrix of
%        p -- dimension of K_p
%        map -- from tuple to its representative
% Output: matrix E_sub and F_sub for subgroup
function [E_sub,F_sub] = opr_in_sub(group,p,map)
E_sub = zeros(length(group));
F_sub = zeros(length(group));
for i = 1:length(group)
    % ith element in group
    cur_tuple = group{i};
    % get unique and duplicate tuple sets for E and F
    [E_result_uniq, E_result_dup] = gen_opr_on_tuple(cur_tuple,'E',p,p+3,map);
    [F_result_uniq, F_result_dup] = gen_opr_on_tuple(cur_tuple,'F',p,p+3,map);
    % for each element in E subgroup
    for j = 1:length(E_result_uniq)
        result_index = get_index_in_group(E_result_uniq{j},group);
        E_sub(result_index,i) = get_freq(E_result_uniq{j},E_result_dup);
    end
    % for each element in F subgroup
    for j = 1:length(F_result_uniq)
        result_index = get_index_in_group(F_result_uniq{j},group);
        F_sub(result_index,i) = get_freq(F_result_uniq{j},F_result_dup);
    end
end
end

% get_index_in_group(): get index of a tuple within a subgroup
% Input: tuple -- tuple to get index of
%        group -- cell array of tuple (subgroup)
% Output: index of tuple within subgroup
function index = get_index_in_group(tuple,group)
for i = 1:length(group)
    if isequal(tuple,group{i})
        index = i;
        break;
    end
end
end

% get_freq_in_result(): get frequency of tuple in result of operation
% Input: tuple -- tuple to get frequency of
%        dup_set -- set of duplicate tuples
% Output: frequency
function freq = get_freq(tuple,dup_set)
freq = 0;
for i = 1:length(dup_set)
    if isequal(tuple,dup_set{i})
        freq = freq + 1;
    end
end
end