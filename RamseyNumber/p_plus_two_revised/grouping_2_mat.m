% grouping_2_mat(grouping)
% input: grouping: cell array of groups of basis 
% output: E/F -- matrices representing E and F on the bases 

function [E,F] = grouping_2_mat(grouping,p,map)
E = [];
F = [];
for i = 1:length(grouping)
    [E_sub,F_sub] = opr_in_sub(grouping{i},p,map);
    E = blkdiag(E,E_sub);
    F = blkdiag(F,F_sub);
end
end

% function: matrix of E and F in each subgroup
% input: cell array of subgroup
% output: matrix E_sub and F_sub
function [E_sub,F_sub] = opr_in_sub(group,p,map)
E_sub = zeros(length(group));
F_sub = zeros(length(group));
    for i = 1:length(group)
        % ith element in group
        cur_tuple = group{i};
        E_result_arr = gen_opr_on_tuple(cur_tuple,'E',p,p+2,map);
        F_result_arr = gen_opr_on_tuple(cur_tuple,'F',p,p+2,map);
        for j = 1:length(E_result_arr)
            result_index = get_index_in_group(E_result_arr{j},group);
            E_sub(result_index,i) = 1;
        end
        for j = 1:length(F_result_arr)
            result_index = get_index_in_group(F_result_arr{j},group);
            F_sub(result_index,i) = 1;
        end
    end
end

% function: get index of a tuple within a subgroup
% input: tuple 
%        group: cell array of tuple (subgroup)
% output: index of tuple within subgroup
function index = get_index_in_group(tuple, group)
count = 1;
    for i = 1 : length (group)
        if isequal(tuple, group{i})
            index = count;
            break;
        end
        count = count + 1;
    end    
end

