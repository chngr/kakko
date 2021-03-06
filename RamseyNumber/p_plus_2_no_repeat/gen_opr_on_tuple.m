% gen_opr_on_tuple(): function to apply E_p and F_p
% Input: tuple -- represents graph
%        opr -- 'E' or 'F' (string)
%        p -- dimension of K_p
%        r -- order of graph (number of vertices)
%        map -- from tuple to representative tuple
% Output: unique_tuple_set -- tuple set of unique basis
%         duplicate_tuple_set -- tuple set with duplicates 
% NOTE: E turns monochromatic "1" to "0"
%       F turns monochromatic "0" to "1"
function [unique_tuple_set, duplicate_tuple_set] = gen_opr_on_tuple(tuple,opr,p,r,map)
W = tuple_to_matrix(tuple);
% find set of all possible tuples
k_tuples = gen_k_tuples(r,p); 
unique_tuple_set = {};
duplicate_tuple_set = {};
set_all = 1:r;
% flag stores if operation changes graph (K_p found to switch)
flag = false;
% iterate through all k_tuples
for j = 1:length(k_tuples)
    % --------------- Initialization ---------------
    % entering jth tuple
    flag = false;
    cur_k_tuple = k_tuples{j};
    % diff: vertices not in k_tuple
    diff = setdiff(set_all,cur_k_tuple);
    % error check
    if size(diff) < r - p
        fprintf('Exceeds bound for r-p vertices!\n')
        break;
    end
    
    % --------------- Do Operation (flip K_p) ---------------
    
    % --------------- Check k-tuple same color ---------------
    sum = 0;
    for x = 1:p
        for y = x+1:p
            sum = sum + W(cur_k_tuple(x), cur_k_tuple(y));
        end
    end
    
    % --------------- operation E: if find K_p_1 ---------------
    if opr == 'E' && sum == nchoosek(p,2)
        flag = true;
    end
    
    % --------------- operation F: if find K_p_2 ---------------
    if opr == 'F' && sum == 0
        flag = true;
    end
    
    % --------------- Construct new_tuple ---------------
    % Generate (a,b,c,d,e): a:11, b:10, c:01; d:00, e: bool
    if flag == true
        a = 0; b= 0; c = 0; d = 0;
        for i = 1:p
            if W(diff(1),cur_k_tuple(i)) == 1 && ... 
                    W(diff(2),cur_k_tuple(i)) == 1
                a = a + 1;
            elseif W(diff(1),cur_k_tuple(i)) == 1 && ...
                    W(diff(2),cur_k_tuple(i)) == 0
                b = b + 1;
            elseif W(diff(1),cur_k_tuple(i)) == 0 && ...
                    W(diff(2),cur_k_tuple(i)) == 1
                c = c + 1;
            else
                d = d + 1;
            end
        end
        % switch b and c if c > b
        if c > b
            [b,c] = deal(c,b);
        end
        e = W(diff(1),diff(2));
        
        if opr == 'E'
            temp_tuple = [0,a,b,c,d,e];
        else
            temp_tuple = [1,a,b,c,d,e];
        end
        duplicate_tuple_set{end+1} = map(mat2str(temp_tuple)); 
    end
end
% Eleminate duplicates in unique_tuple_set (mat with same result)
str = unique(cellfun(@mat2str,duplicate_tuple_set,'UniformOutput',false));
unique_tuple_set = cellfun(@eval,str,'UniformOutput',false);
end