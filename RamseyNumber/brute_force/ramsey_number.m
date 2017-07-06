% ramsey_number(): computes Ramsey number R(m,n) for m, n >= 2
% Input: sizes m and n of monochromatic cliques
% Output: R(m,n) with current progress printed
function result = ramsey_number(m,n)
% loop over number of vertices
for i = max(m,n):intmax
    fprintf('Current value of loop: %d\n',i);
    % counter for number of graphs with a monochromatic clique
    passed_count = 0;
    m_tuples = gen_k_tuples(i,m);
    n_tuples = gen_k_tuples(i,n);
    basis = gen_mat_basis(i);
    % for each basis matrix
    for j = 1:length(basis)
        basis_mat = basis{j};
        % boolean for single basis matrix
        mat_boolean = false;
        % for each of the m-tuples
        for k = 1:length(m_tuples)
            cur_m_tuple = m_tuples{k};
            sum = 0;
            for p = 1:m
                for q = p+1:m
                    sum = sum + basis_mat(cur_m_tuple(p), cur_m_tuple(q));
                end
            end
            if sum == nchoosek(m,2)
                mat_boolean = true;
                passed_count = passed_count + 1;
                break;
            end
        end
        % for each of the n-tuples
        if mat_boolean == false
            for k = 1:length(n_tuples)
                cur_n_tuple = n_tuples{k};
                sum = 0;
                for p = 1:n
                    for q = p+1:n
                        sum = sum + basis_mat(cur_n_tuple(p), cur_n_tuple(q));
                    end
                end
                if sum == 0
                    mat_boolean = true;
                    passed_count = passed_count + 1;
                    break;
                end
            end
        end
        % if none of the m- and n-tuples passed for a given basis matrix,
        % move on to next i (Note: passed_count ~= length(basis))
        if mat_boolean == false
            break;
        end
    end
    % if all the matrices passed, we have that R(m,n) = i and the
    % passed_count is at the number of basis matrices
    if passed_count == length(basis)
        break;
    end
end
result = i;
end
