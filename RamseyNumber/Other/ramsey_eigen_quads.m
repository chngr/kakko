% ramsey_eigen_quads(): computes eigenvalue multiplicities for H for 
% quadruples
% Input: order of graph r 
% Output: cell object of eigenvalue multiplicities
function eigenlist = ramsey_eigen_quads(r)
basis = gen_mat_basis(r);
quads = gen_4_tuples(r);
mult = zeros([1, 2 * nchoosek(r,4) + 1]);
for i = 1:length(basis)
    basis_mat = basis{i};
    lambda = 0;
    for j = 1:length(quads)
        cur_quad = quads{j};
        a = cur_quad(1);
        b = cur_quad(2);
        c = cur_quad(3);
        d = cur_quad(4);
        if (basis_mat(a,b) + basis_mat(a,c) + basis_mat(a,d) + ...
            basis_mat(b,c) + basis_mat(b,d) + basis_mat(c,d) == 6)
            lambda = lambda + 1;
        end
        if (basis_mat(a,b) + basis_mat(a,c) + basis_mat(a,d) + ... 
            basis_mat(b,c) + basis_mat(b,d) + basis_mat(c,d) == 0)
            lambda = lambda - 1;
        end
    end
    mult(lambda + nchoosek(r,4) + 1) = mult(lambda + nchoosek(r,4) + 1) + 1;
end
eigenlist = mult;
end