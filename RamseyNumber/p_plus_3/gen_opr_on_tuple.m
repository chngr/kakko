% gen_opr_on_tuple(): function to apply E_p and F_p to a graph
% Input: tuple -- represents graph
%        opr -- 'E' or 'F' (string)
%        p -- dimension of K_p
%        r -- order of graph (number of vertices)
%        map -- from tuple to representative tuple
% Output: resulting tuple set after operation
% NOTE: E turns monochromatic "1" to "0"
%       F turns monochromatic "0" to "1"
function result_tuple_set = gen_opr_on_tuple(tuple,opr,p,r,map)
W = tuple_to_matrix(tuple);
% find set of all possible tuples
k_tuples = gen_k_tuples(r,p); 
result_tuple_set = {};
set_all = 1:r;
% flag stores if operation changes graph (K_p found to switch)
flag = false;
% iterate through all k_tuples
for j = 1:length(k_tuples)
    % --------------- Initialization ---------------
    % entering jth tuple
    flag = false;
    cur_k_tuple = k_tuples{j};
    new_mat = W;
    % diff: vertices not in k_tuple
    diff = setdiff(set_all,cur_k_tuple);
    % error check
    if size(diff) < r - p
        fprintf('Exceeds bound for r-p vertices!\n')
        break;
    end
    
    % --------------- Do Operation (flip K_p) ---------------
    % init new_tuple, inversed triangle in upper
    new_tuple = tuple;
    
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
    % Generate [x,a,b,c,d,e,f,g,h,y,z]
    if flag == true
        a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0;
        for i = 1:p
            if W(cur_k_tuple(i),diff(1)) == 1 && ...
                   W(cur_k_tuple(i),diff(2)) == 1 && ...
                   W(cur_k_tuple(i),diff(3)) == 1
               a = a + 1;
            elseif W(cur_k_tuple(i),diff(1)) == 1 && ...
                   W(cur_k_tuple(i),diff(2)) == 1 && ...
                   W(cur_k_tuple(i),diff(3)) == 0
               b = b + 1;
            elseif W(cur_k_tuple(i),diff(1)) == 1 && ...
                   W(cur_k_tuple(i),diff(2)) == 0 && ...
                   W(cur_k_tuple(i),diff(3)) == 1
               c = c + 1;
            elseif W(cur_k_tuple(i),diff(1)) == 1 && ...
                   W(cur_k_tuple(i),diff(2)) == 0 && ...
                   W(cur_k_tuple(i),diff(3)) == 0
               d = d + 1;
            elseif W(cur_k_tuple(i),diff(1)) == 0 && ...
                   W(cur_k_tuple(i),diff(2)) == 1 && ...
                   W(cur_k_tuple(i),diff(3)) == 1
               e = e + 1;
            elseif W(cur_k_tuple(i),diff(1)) == 0 && ...
                   W(cur_k_tuple(i),diff(2)) == 1 && ...
                   W(cur_k_tuple(i),diff(3)) == 0
               f = f + 1;
            elseif W(cur_k_tuple(i),diff(1)) == 0 && ...
                   W(cur_k_tuple(i),diff(2)) == 0 && ...
                   W(cur_k_tuple(i),diff(3)) == 1
               g = g + 1;
            else
               h = h + 1;
            end
        end
        
        y = 2 * W(diff(1),diff(2)) + W(diff(1),diff(3));
        z = W(diff(2),diff(3));
        
        if opr == 'E'
            temp_tuple = [0,a,b,c,d,e,f,g,h,y,z];
        else
            temp_tuple = [1,a,b,c,d,e,f,g,h,y,z];
        end

        result_tuple_set{end+1} = map(mat2str(temp_tuple)); 
        % Eleminate duplicates in result_tuple_set (mat with same result)
        str = unique(cellfun(@mat2str, result_tuple_set, 'UniformOutput',false));
        result_tuple_set = cellfun(@eval,str,'UniformOutput',false);
    end
end
end