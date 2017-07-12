% ramsey_eigen_k_tuples(): computes eigenvalue multiplicities for H for 
%                          k-tuples
% Input: r -- number of vertices 
%        k -- number of elements selected
% Output: eigenlist -- cell array of eigenvalue multiplicities
function eigenlist = ramsey_eigen_k_tuples(r,k)
basis = gen_mat_basis(r);
k_tuples = gen_k_tuples(r,k);
mult = zeros([1, 2 * nchoosek(r,k) + 1]);
% for each element in the basis
for i = 1:length(basis)
    basis_mat = basis{i};
    lambda = 0;
    % for each tuple
    for j = 1:length(k_tuples)
        cur_k_tuple = k_tuples{j};
        sum = 0;
        for p = 1:k
            for q = p+1:k
                sum = sum + basis_mat(cur_k_tuple(p), cur_k_tuple(q));
            end
        end
        % check for K_{red}
        if sum == nchoosek(k,2)
            lambda = lambda + 1;
        end
        % check for K_{blue}
        if sum == 0
            lambda = lambda - 1;
        end
    end
    mult(lambda + nchoosek(r,k) + 1) = mult(lambda + nchoosek(r,k) + 1) + 1;
end
eigenlist = mult;
end