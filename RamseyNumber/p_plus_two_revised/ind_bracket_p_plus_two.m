% ind_bracket(): repeatedly computes bracket until computed collection 
% lies in span of previously computed collection
% Input: dimension of space p 
% Output: dimension (number of independent matrices)
function dimension = ind_bracket_p_plus_two(E,F)
vector_list = cell(0);
% old_list stores old group
old_list = cell(0);
old_list{end+1} = E;
disp('E')
disp(E)
old_list{end+1} = F;
disp('F')
disp(F)
% name_old_list stores string names of old group
name_old_list = cell(0);
name_old_list{1} = 'E';
name_old_list{2} = 'F';
% new_list stores new group
new_list = cell(0);
H = bracket(E,F);
disp('[E,F]')
disp(H)
new_list{end+1} = H;
% name_new_list stores string names of new group
name_new_list = cell(0);
name_new_list{1} = '[E,F]';
% comp_list stores composite of old and new lists
% check if column vectors are linearly independent
comp_list = [old_list, new_list];
for i = 1:length(comp_list)
    for j = 1:size(comp_list{i},2)
        new_col = comp_list{i}(:,j);
        if ~in_span(vector_list, new_col)
            vector_list{end+1} = new_col;
        end
    end
end
while true
    % temp_list stores newly calculated entries
    temp_list = {};
    name_temp_list = {};
    for i = 1:length(new_list)
        for j = i+1:length(new_list)
            new_entry = bracket(new_list{i}, new_list{j});
            name_new_entry = name_bracket(name_new_list{i}, name_new_list{j});
            if ~in_span([old_list, new_list, temp_list], new_entry)
                disp(name_new_entry)
                for k = 1:size(new_entry,2)
                    new_col = new_entry(:,k);
                    if ~in_span(vector_list, new_col)
                        vector_list{end+1} = new_col;
                    end
                end
                temp_list{end+1} = new_entry;
                name_temp_list{end+1} = name_new_entry;
            end
        end
    end
    for i = 1:length(old_list)
        for j = 1:length(new_list)
            new_entry = bracket(old_list{i}, new_list{j});
            name_new_entry = name_bracket(name_old_list{i}, name_new_list{j});
            % if entry not in the span, add it to the list
            if ~in_span([old_list, new_list, temp_list], new_entry)
                disp(name_new_entry)
                for k = 1:size(new_entry,2)
                    new_col = new_entry(:,k);
                    if ~in_span(vector_list, new_col)
                        vector_list{end+1} = new_col;
                    end
                end
                temp_list{end+1} = new_entry;
                name_temp_list{end+1} = name_new_entry;
            end
        end
    end
    % if temp_list is empty, we have generated independent basis
    if isempty(temp_list)
        fprintf('Number of independent vectors: %d\n', length(vector_list));
        dimension = length(old_list) + length(new_list);
        fprintf('Number of independent matrices: %d\n', dimension);
        break;
    end
    % update lists for new iteration of loop
    old_list = [old_list, new_list];
    new_list = temp_list;
    name_old_list = [name_old_list, name_new_list];
    name_new_list = name_temp_list;
end
end