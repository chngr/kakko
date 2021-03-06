% bracket_operation(): repeatedly computes brackets of E and F until 
%                      an independent basis is generated
% Input: gen_mat -- cell array of generator matrices
%        gen_names -- cell array of generator names
% Output: dim -- dimension of generated Lie algebra
%         result_basis -- basis for generated Lie algebra
function [dim,result_basis] = bracket_operation(gen_mat,gen_names)
% old_list stores old group
old_list = {};
% name_old_list stores string names of old group
name_old_list = {};
% new_list stores new group
new_list = {};
for i = 1:length(gen_mat)
    new_list{end+1} = gen_mat{i};
end
% name_new_list stores string names of new group
name_new_list = {};
for i = 1:length(gen_names)
    name_new_list{end+1} = gen_names{i};
    disp(gen_names{i});
end
% perform until no new independent elements are generated
while true
    % temp_list stores newly calculated entries
    temp_list = {};
    name_temp_list = {};
    % take pairwise brackets for all elements in new_list
    for i = 1:length(new_list)
        for j = i+1:length(new_list)
            new_entry = bracket(new_list{i},new_list{j});
            name_new_entry = name_bracket(name_new_list{i},name_new_list{j});
            % if not in the span of previous elements
            if ~in_span([old_list,new_list,temp_list], new_entry)
                % add new entry               
                temp_list{end+1} = new_entry;
                name_temp_list{end+1} = name_new_entry;
                disp(name_new_entry);
            end
        end
    end
    % take pairwise brackets of old_list and new_list
    for i = 1:length(old_list)
        for j = 1:length(new_list)
            new_entry = bracket(old_list{i},new_list{j});
            name_new_entry = name_bracket(name_old_list{i},name_new_list{j});
            % if not in the span of previous elements
            if ~in_span([old_list,new_list,temp_list], new_entry)
                % add new entry
                temp_list{end+1} = new_entry;
                name_temp_list{end+1} = name_new_entry;
                disp(name_new_entry);
            end
        end
    end
    % update lists for new iteration of loop
    old_list = [old_list, new_list];
    new_list = temp_list;
    name_old_list = [name_old_list, name_new_list];
    name_new_list = name_temp_list;
    % if temp_list is empty, we have generated an independent basis
    if isempty(temp_list)
        dim = length(old_list);
        fprintf('number of independent matrices: %d\n', dim);
        result_basis = old_list;
        break;
    end
end
end

% name_bracket(): function to compute string names for brackets
% Input: matrix string names 'E' and 'F'
% Output: bracket string '[E,F]'
function result = name_bracket(E,F)
result = strcat('[',E,',',F,']');
end