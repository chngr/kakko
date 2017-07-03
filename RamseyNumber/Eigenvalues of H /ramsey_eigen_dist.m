% ramsey_eigen_dist(): computes distribution of A_r for given r and k
% Input: order of graph r, number of elements selected k  
% Output: plot of distribution of A_r
% -- x-axis: number of monochromatic K_{red} and K_{blue}
% -- y-axis: number of graphs with x-value
function eigenlist = ramsey_eigen_dist(r,k)
basis = gen_mat_basis(r);
k_tuples = gen_k_tuples(r,k);
mult = zeros([1, nchoosek(r,k) + 1]);
for i = 1:length(basis)
    basis_mat = basis{i};
    lambda = 0;
    for j = 1:length(k_tuples)
        cur_k_tuple = k_tuples{j};
        sum = 0;
        for p = 1:k
            for q = p+1:k
                sum = sum + basis_mat(cur_k_tuple(p), cur_k_tuple(q));
            end
        end
        if sum == nchoosek(k,2)
            lambda = lambda + 1;
        end
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
assignin('base','mult',mult)
assignin('base','x',x)
eigenlist = mult;
end
