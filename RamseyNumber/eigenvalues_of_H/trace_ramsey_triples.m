% trace_ramsey_triples(): computes eigenvalue multiplicities for H for 
%                         triples (alternative method using trace formula)
% Input: r -- number of vertices
% Output: eigenlist -- cell array of eigenvalue multiplicities
function eigenlist = trace_ramsey_triples(r)
basis = gen_mat_basis(r);
mult = zeros([1, 2 * nchoosek(r,3) + 1]);
% for each basis element
for i = 1:length(basis)
    basis_mat = basis{i};
    % complement of basis matrix
    basis_mat_comp = ~(basis_mat + eye(r));
    % trace formula
    lambda = (1/6) * trace(basis_mat^3) - (1/6) * trace(basis_mat_comp^3);
    mult(lambda + nchoosek(r,3) + 1) = mult(lambda + nchoosek(r,3) + 1) + 1;
end
eigenlist = mult;
end