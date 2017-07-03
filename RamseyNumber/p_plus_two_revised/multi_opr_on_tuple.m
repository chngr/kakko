% multi_opr_on_tuple(tuple)
% Input: tuple, r = size of matrix (p+2)
% Output: array of tuples generated by multiple E's and F's
% WARNING: all input of tuples in normal form!!!

function result = multi_opr_on_tuple(tuple,r,map)
odd_op = '';
even_op = '';
old_list = cell(0);
new_list = cell(0);
new_list{end+1} = tuple;
temp_list = cell(0);
p = r-2;

% Assign sequence of operations depending on x = (0/1)
if tuple(1) == 1
    odd_op = 'E';
    even_op = 'F';
else
    odd_op = 'F';
    even_op = 'E';
end

for i = 1:intmax
    temp_list = {};
    % Adding opr result to temp list
    for j = 1:length(new_list)
        cur_tuple = new_list{j};
        gen_opr_on_tuple(cur_tuple,'E',p,r,map);
        
        if mod(i,2) ~= 0
            temp_list = [temp_list, gen_opr_on_tuple(cur_tuple,odd_op,p,r,map)];
        else
            temp_list = [temp_list, gen_opr_on_tuple(cur_tuple,even_op,p,r,map)];
        end
    end
    % Eleminate duplicates in  temp_list
    str = cellfun(@mat2str, temp_list, 'UniformOutput', false);
    str = unique(str);
    temp_list = cellfun(@eval,str, 'UniformOutput', false);
    
    % !!!TOCHECK: Eleminate duplicates between temp and previous lists
    temp_str = cellfun(@mat2str, temp_list, 'UniformOutput', false);
    old_new_str = cellfun(@mat2str, [old_list,new_list], 'UniformOutput', false);
    temp_str = setdiff(temp_str,old_new_str);
    temp_list = cellfun(@eval, temp_str, 'UniformOutput',false);
    
    old_list = [old_list, new_list];
    new_list = temp_list;
    
    % no new elements generated, terminate
    if isempty(temp_list)
        result = old_list;
        break;
    end
end
end