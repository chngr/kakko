% ramsey_eigen_dist(): computes distribution of A_r for given r and k
% Input: r -- number of vertices in graph
%        k -- number of elements selected
% Output: plot of distribution of A_r, with:
%         x-axis: number of monochromatic K_{red} and K_{blue}
%         y-axis: number of graphs with x-value
%         eigenlist -- list of eigenvalues
function eigenlist = ramsey_eigen_dist(r,k)
basis = gen_mat_basis(r);
k_tuples = gen_k_tuples(r,k);
mult = zeros([1, nchoosek(r,k) + 1]);
% for each element in basis
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
            lambda = lambda + 1;
        end
    end
    mult(lambda + 1) = mult(lambda + 1) + 1;
end
x = [];
for i = 0:nchoosek(r,k)
    x = [x, i];
end
fprintf('Number of K_m: %d\n', dot(x, mult));
plot(x, mult);
eigenlist = mult;
end