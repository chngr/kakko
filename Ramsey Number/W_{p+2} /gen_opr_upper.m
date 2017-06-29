% gen_opr_to_binary(): general funciton  E_p and F_p
% Input: matrix W, opr = 'E' or 'F', k: number of vertices in operation//
% Output:
% result -- set of matrices generated
% binary -- set of binary strings denoting 2 vertices
% result_mat -- set of transformed matrices

function result_mat = gen_opr_upper(W,opr,k)
r = size(W,1);
k_tuples = gen_k_tuples(r,k);
result = cell(0);
result_mat = cell(0);
set_all = 1:r;
flag = false;

% iterate through all k_tuples
for j = 1:length(k_tuples)
    flag = false;
    % get current tuple
    cur_k_tuple = k_tuples{j};
    % diff: vertices not in k_tuple
    diff = setdiff(set_all,cur_k_tuple);
    disp(diff)
    % err check
    if size(diff) <2
        fprintf('exceed bound for p+2 vertices!')
        break;
    end
    % init new trans mat (normal form), inversed traingle in upper
    
    %?????
    new_trans_mat = ones(r)-eye(r)-W;
    
    % --- check k tuple same color ---
    sum = 0;
    for p = 1:k
        for q = p+1:k
            sum = sum + W(cur_k_tuple(p), cur_k_tuple(q));
        end
    end
    
    % --- operation E: if find K_p_1 ---
    if opr == 'E' && sum == nchoosek(k,2)
        flag = true;
        % generate new matrix (not transformed after opr)
        new_mat = W;
        for p = 1:k
            for q = p+1:k
                % perform E
                new_mat(cur_k_tuple(p),cur_k_tuple(q)) = 0;
                new_mat(cur_k_tuple(q),cur_k_tuple(p)) = 0;
            end
        end
        % add to result list (non-transformed)
        result{end+1} = new_mat;
    end
    
    
    % --------------- F ----------------
    % operation F: if find K_p_2
    if opr == 'F' && sum == 0
        flag = true;
        new_mat = W;
        for p = 1:k
            for q = p+1:k
                % perform F
                new_mat(cur_k_tuple(p),cur_k_tuple(q)) = 1;
                new_mat(cur_k_tuple(q),cur_k_tuple(p)) = 1;
            end
        end
        result{end+1} = new_mat;
    end
    
    % ---------------Transform to Normal Form ---------------
    
    % generate (a,b,c,d,e): a:11, b:10, c:01; d:00, e: bool
    if flag == true
        a = 0; b=0; c=0; d=0;
        for i = 1:k
            if new_mat(diff(1),cur_k_tuple(i)) == 1 && new_mat(diff(2),cur_k_tuple(i)) == 1
                a = a + 1;
            elseif new_mat(diff(1),cur_k_tuple(i)) == 1 && new_mat(diff(2),cur_k_tuple(i)) == 0
                b = b + 1;
            elseif new_mat(diff(1),cur_k_tuple(i)) == 0 && new_mat(diff(2),cur_k_tuple(i)) == 1
                c = c + 1;
            elseif new_mat(diff(1),cur_k_tuple(i)) == 0 && new_mat(diff(2),cur_k_tuple(i)) == 0
                d = d + 1;
            end
        end
        
        fprintf('a = %i, b = %i, c = %i, d = %i\n', a, b, c, d)
        % make new_trans_mat from abcde
        for i=1:a
            new_trans_mat(r-1,i) = 1;
            new_trans_mat(i,r-1) = 1;
            new_trans_mat(r,i) = 1;
            new_trans_mat(i,r) = 1;
        end
        for i= 1:b
            new_trans_mat(r-1,a+i) = 1;
            new_trans_mat(a+i,r-1) = 1;
            new_trans_mat(r,a+i) = 0;
            new_trans_mat(a+i,r) = 0;
        end
        for i= 1:c
            new_trans_mat(r-1,a+b+i) = 0;
            new_trans_mat(a+b+i,r-1) = 0;
            new_trans_mat(r,a+b+i) = 1;
            new_trans_mat(a+b+i,r) = 1;
        end
        for i= 1:d
            new_trans_mat(r-1,a+b+c+i) = 0;
            new_trans_mat(a+b+c+i,r-1) = 0;
            new_trans_mat(r,a+b+c+i) = 0;
            new_trans_mat(a+b+c+i,r) = 0;
        end
        
        new_trans_mat(r-1,r)= new_mat(diff(1),diff(2));
        new_trans_mat(r,r-1)= new_mat(diff(2),diff(1));
        
        % Add new binary and matric to cell arrays
        result_mat = [result_mat,new_trans_mat];
    end
end
end
