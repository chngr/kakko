% diagonal_to_mat(): converts basis for Cartan subalgebra into root matrix
% Input: h_basis -- basis for Cartan subalgebra
%        g_basis -- basis for original Lie algebra
%        g_basis_mat -- basis matrix for original Lie algebra
% Output: A -- root matrix of Cartan subalgebra
function A = diagonal_to_mat(h_basis, g_basis, g_basis_mat)
% adjoint representation of H1 on original basis
ad_H1 = adjoint_mat(h_basis{1},g_basis, g_basis_mat);
% diagonalize matrix
[P,~] = sym(eig(ad_H1)); % columns of P are Xi, P*Ad_H1*P-1 = diagonal
adj_matrix = {};
adj_diag_vec = {};
for i = 1:length(h_basis)
    adj_mat = adjoint_mat(h_basis{i},g_basis,g_basis_mat);
    adj_matrix{end+1} = sym(P * adj_mat * inv(P));
    adj_diag_vec{end+1} = diag(adj_matrix{end});
end
% construct A
for i = 1:length(h_basis)
    A(i,:) = adj_diag_vec{i};
end
end