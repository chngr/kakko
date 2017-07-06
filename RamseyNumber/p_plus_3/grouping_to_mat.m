% grouping_to_mat(): constructs large E and F matrices (generators for
%                    space)
% Input: grouping -- cell array of groups of basis
%        p -- dimension of K_p
%        map -- map from tuple to its representative
% Output: E, F -- matrices representing E and F on the bases
function [E,F] = grouping_to_mat(grouping,p,map)
E = [];
F = [];
E_F = {};
E_cell = {};
F_cell = {};
E_test = [];
F_test = [];
comp_col = {};
for i = 1:length(grouping)
    [E_sub,F_sub] = opr_in_sub(grouping{i},p,map);
    present = false;
    for j = 1:length(comp_col)
        if isequal([E_sub,F_sub],comp_col{j})
            present = true;
        end
    end
    if present == false
        E = blkdiag(E,E_sub);
        F = blkdiag(F,F_sub);
    end
    E_cell{end+1} = E_sub;
    F_cell{end+1} = F_sub;
    E_test = blkdiag(E_test,E_sub);
    F_test = blkdiag(F_test,F_sub);
end
assignin('base','E_cell',E_cell);
assignin('base','F_cell',F_cell);
assignin('base','comp_col', comp_col);
end

%{
E_F_combo = {}; % each element is a cell array (pair) of sub_E and sub_F
% and elemenate duplicates from the set
E_cell = {};
F_cell = {};
% E_cell and F_cell shares same indexing
for i = 1:length(grouping)
    [E_sub,F_sub] = opr_in_sub(grouping{i},p,map);
    E_cell{end+1} = E_sub;
    F_cell{end+1} = F_sub;
    E_F{end+1} = blkdiag(E_sub,F_sub);
end
% eleminate duplicate blocks of E and F
E_F_str = unique(cellfun(@mat2str, E_F, 'UniformOutput',false));
E_F = cellfun(@eval,E_F_str,'UniformOutput',false);
assignin('base','E_cell',E_cell);
assignin('base','F_cell',F_cell);
assignin('base','E_F', E_F);
%}

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
    [E_result_uniq, E_result_dup] = gen_opr_on_tuple(cur_tuple,'E',p,p+3,map);
    [F_result_uniq, F_result_dup] = gen_opr_on_tuple(cur_tuple,'F',p,p+3,map);
    for j = 1:length(E_result_uniq)
        result_index = get_index_in_group(E_result_uniq{j},group);
        E_sub(result_index,i) = get_freq(E_result_uniq{j},E_result_dup);
    end
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

% get_freq(): get frequence of tuple in result of operation
function freq = get_freq(tuple,dup_set)
freq = 0;
for i = 1: length(dup_set)
    if isequal(tuple,dup_set{i})
        freq = freq + 1;
    end
end
end