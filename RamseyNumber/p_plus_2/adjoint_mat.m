% adjoint_mat(): computes adjoint representation matrix for matrix given
%                basis set and basis matrix
% Input: mat -- matrix to compute adj of 
%        basis -- basis for Lie algebra
%        basis_mat -- basis matrix for Lie algebra
% Output: result -- adjoint matrix
function result = adjoint_mat(mat, basis, basis_mat)
adj_mat = [];
for i = 1:length(basis);
  bracket_mat = bracket(mat,basis{i});
  % solve basis_mat [x] = bracket_mat to find coordinates wrt basis
  coord = basis_mat\(bracket_mat(:));
  adj_mat = [adj_mat, coord];
end
result = adj_mat;
end