% signature(): computes signature of Lie algebra
% Input: killing_mat -- matrix of Killing form
% Output: sig -- signature of Lie algebra
%         printed: list of eigenvalues of Killing form
%                  counts for positive, negative, and zero eigenvalues 
function sig = signature(killing_mat)
eigenvalues = eig(killing_mat);
% count eigenvalue signs
pos_count = 0; neg_count = 0; zero_count = 0;
for i = 1:length(eigenvalues)
    if eigenvalues(i) > 0
        pos_count = pos_count + 1;
    elseif eigenvalues(i) < 0
        neg_count = neg_count + 1;
    else
        zero_count = zero_count + 1;
    end
end
disp('eigenvalue list:');
disp(eigenvalues);
fprintf('positive eigenvalue count: %d\n', pos_count);
fprintf('negative eigenvalue count: %d\n', neg_count);
fprintf('zero eigenvalue count: %d\n', zero_count);
sig = pos_count - neg_count;
end