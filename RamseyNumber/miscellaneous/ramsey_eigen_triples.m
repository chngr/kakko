% ramsey_eigen_triples(): computes eigenvalue multiplicities for H for 
% triples
% Input: order of graph r 
% Output: cell object of eigenvalue multiplicities
function eigenlist = ramsey_eigen_triples(r)
basis = gen_mat_basis(r);
triples = gen_3_tuples(r);
mult = zeros([1, 2 * nchoosek(r,3) + 1]);
for i = 1:length(basis)
    basis_mat = basis{i};
    lambda = 0;
    for j = 1:length(triples)
        cur_triple = triples{j};
        a = cur_triple(1);
        b = cur_triple(2);
        c = cur_triple(3);
        if (basis_mat(a,b) + basis_mat(a,c) + basis_mat(b,c) == 3)
            lambda = lambda + 1;
        end
        if (basis_mat(a,b) + basis_mat(a,c) + basis_mat(b,c) == 0)
            lambda = lambda - 1;
        end
    end
    mult(lambda + nchoosek(r,3) + 1) = mult(lambda + nchoosek(r,3) + 1) + 1;
end
eigenlist = mult;
end