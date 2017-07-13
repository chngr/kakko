% in_span(): checks whether matrix entry is in the span of
%            the matrices in list
% Input: list -- cell array list of matrices
%        entry -- entry to check independence of
% Output: result -- boolean true if in span, false otherwise
function result = in_span(list, entry)
comp_mat = [];
for i = 1:length(list)
    cur_mat = list{i};
    comp_mat = [comp_mat, cur_mat(:)];
end
comp_mat = [comp_mat, entry(:)];
result = rank(comp_mat) ~= size(comp_mat, 2);
end