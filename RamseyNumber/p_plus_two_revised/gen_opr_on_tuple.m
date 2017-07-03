% gen_opr_on_tuple(): general funciton  E_p and F_p
% Input: tuple, opr = 'E' or 'F', k: number of vertices in operation//
% Output:
% result -- set of matrices generated
% binary -- set of binary strings denoting 2 vertices
% result_mat -- set of transformed matrices

function result_tuple_set = gen_opr_on_tuple(tuple,opr,p,r)
% !!!!! W = mapping (tuple)
% W = zeros(r);
% TO BE CHANGED !!!!
W = tuple_to_matrix(tuple);
k_tuples = gen_k_tuples(r,p); % set of all possible tuples
result_tuple_set = cell(0);
set_all = 1:r;
flag = false;

% iterate through all k_tuples
for j = 1:length(k_tuples)
    % ---------------- initialization ----------------
    % entering jth tuple
    flag = false;
    % get current tuple
    cur_k_tuple = k_tuples{j};
    new_mat = W;
    % diff: vertices not in k_tuple
    diff = setdiff(set_all,cur_k_tuple);
    % err check
    if size(diff) < r - p
        fprintf('exceed bound for r-p vertices (2 in this case)!')
        break;
    end
    
    % ---------------- Do Operation (flip K_p) ----------------
    
    % init new_tuple, inversed traingle in upper
    new_tuple = tuple;
    
    % --- check k tuple same color ---
    sum = 0;
    for x = 1:p
        for y = x+1:p
            sum = sum + W(cur_k_tuple(x), cur_k_tuple(y));
        end
    end
    
    % --- operation E: if find K_p_1 ---
    if opr == 'E' && sum == nchoosek(p,2)
        flag = true;
    end
    
    % --------------- F ----------------
    % operation F: if find K_p_2
    if opr == 'F' && sum == 0
        flag = true;
    end
    
    % ---------------Construct new_tuple ---------------
    
    % generate (a,b,c,d,e): a:11, b:10, c:01; d:00, e: bool
    if flag == true
        a = 0; b=0; c=0; d=0;
        for i = 1:p
            if W(diff(1),cur_k_tuple(i)) == 1 && W(diff(2),cur_k_tuple(i)) == 1
                a = a + 1;
            elseif W(diff(1),cur_k_tuple(i)) == 1 && W(diff(2),cur_k_tuple(i)) == 0
                b = b + 1;
            elseif W(diff(1),cur_k_tuple(i)) == 0 && W(diff(2),cur_k_tuple(i)) == 1
                c = c + 1;
            elseif W(diff(1),cur_k_tuple(i)) == 0 && W(diff(2),cur_k_tuple(i)) == 0
                d = d + 1;
            end
        end
        
        if c > b
            [b,c] = deal(c,b);
        end
        e = W(diff(1),diff(2));
        
        if opr == 'E'
            temp_tuple = [0,a,b,c,d,e];
        else
            temp_tuple = [1,a,b,c,d,e];
        end
        result_tuple_set{end+1} = temp_tuple;
        % TODO: result_tuple_set{end+1} = mapping(temp_tuple);
        
        % Eleminate duplicates in result_tuple_set (matrices with same result)
        str = cellfun(@mat2str, result_tuple_set, 'UniformOutput', false);
        str = unique(str);
        result_tuple_set = cellfun(@eval,str, 'UniformOutput', false);
    end
end
end