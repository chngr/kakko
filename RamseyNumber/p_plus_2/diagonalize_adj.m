function A = diagonal_to_mat(h_basis, g_basis, g_basis_mat)
% adjoint representation of H1 on original basis
Ad_H1 = adjoint_mat(h_basis{1},g_basis, g_basis_mat);
% diagonalize matrix
[P,~] = sym(eig(mat)); % columns of P are Xi, P*Ad_H1*P-1 = diagonal
Adj_matrix = {};
Adj_diag_vec = {};
for i = 1:length(h_basis)
    adj_mat = adjoint_mat(h_basis{i},g_basis, g_basis_mat);
    Adj_matrix{end+1} = sym(P * adj_mat * inv(P));
    Adj_diag_vec{end+1} = diag(Adj_matrix{end});
end
% construct A
for i = 1: length(h_basis)
    A(i,:) = Adj_diag_vec{i};
end
end

% find random vector that's not orthogonal to any of the basis element
% input: trial_mat: trial matrix
%        basis: extracted basis vectors (positive + negative)
function result = not_orthogonal(trial_vec, basis)
for i = 1:length(basis)
    if dot(trial_mat, basis{i}) == 0
        result = false;
    end
end
result = true;
end

