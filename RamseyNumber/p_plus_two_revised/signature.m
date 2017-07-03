% signature(): Computes signature of Lie algebra
% Input: basis for rho_{p+1}(a_p)
% Output: counts for positive, negative, and zero eigenvalues for 
% matrix of Killing form
function result = signature(basis)
killing_mat = killing_form(basis);
eigenvalues = eig(killing_mat);
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
fprintf('Positive eigenvalue count: %d\n', pos_count);
fprintf('Negative eigenvalue count: %d\n', neg_count);
fprintf('Zero eigenvalue count: %d\n', zero_count);
end

% killing_form(): computes killing form of Lie algebra
% Input: basis for rho_{p+1}(a_p)
% Output: matrix of Killing form
function result = killing_form(basis)
killing_mat = zeros(length(basis));
for i = 1:length(basis)
   for j = 1:length(basis)
      killing_mat(i,j) = trace(basis{i} * basis{j});
   end
end
result = killing_mat;
end