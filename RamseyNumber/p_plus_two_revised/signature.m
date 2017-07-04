% signature(): computes signature of Lie algebra
% Input: basis for rho_{p+r}(a_p)
% Output: counts for positive, negative, and zero eigenvalues for 
% matrix of Killing form
function sig = signature(basis)
killing_mat = killing_form(basis);
eigenvalues = eig(killing_mat);
% count eigenvalue signs
pos_count = 0; zero_count = 0; neg_count = 0;
for i = 1:length(eigenvalues)
    if eigenvalues(i) > 0
        pos_count = pos_count + 1;
    elseif eigenvalues(i) < 0
        neg_count = neg_count + 1;
    else
        zero_count = zero_count + 1;
    end
end
disp(eigenvalues)
fprintf('positive eigenvalue count: %d\n', pos_count);
fprintf('negative eigenvalue count: %d\n', neg_count);
fprintf('zero eigenvalue count: %d\n', zero_count);
sig = pos_count - neg_count;
end

% killing_form(): computes killing form of Lie algebra
% Input: basis for rho_{p+r}(a_p)
% Output: matrix of Killing form
function result = killing_form(basis)
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
result = killing_mat;
end