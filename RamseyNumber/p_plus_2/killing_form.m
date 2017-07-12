% killing_form(): computes killing form of Lie algebra
% Input: basis for rho_{p+r}(a_p) (general)
% Output: basis_mat -- matrix of basis
%         kil_mat -- matrix of Killing form
function basis_mat, kil_mat = killing_form(basis)
killing_mat = zeros(length(basis));
% create basis matrix with column vectors as basis elements
basis_mat = [];
for i = 1:length(basis)
    basis_mat(:,i) = basis{i}(:);
end
adj_group = {};
% compute adjoint representation matrices
for i = 1:length(basis)
    adj_mat = [];
    for j = 1:length(basis)
      bracket_mat = bracket(basis{i},basis{j});
      % solve basis_mat [x] = bracket_mat to find coordinates wrt basis
      coord = basis_mat\(bracket_mat(:));
      adj_mat = [adj_mat, coord];
    end
    adj_group{end+1} = adj_mat;
end
% create matrix for Killing form
for i = 1:length(adj_group)
    for j = 1:length(adj_group)
        killing_mat(i,j) = trace(adj_group{i} * adj_group{j});
    end
end
kil_mat = killing_mat;
end