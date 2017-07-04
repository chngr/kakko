% in_span(): checks whether matrix entry is in the span of
% the matrices in list
% Input: cell array list of matrices, entry to check independence of
% Output: boolean true if in span, false otherwise
function result = in_span(list, entry)
% build composite matrix with list matrices as column vectors
comp_mat = [];
for i = 1:length(list)
    cur_mat = list{i};
    comp_mat = [comp_mat, cur_mat(:)];
end
% add entry to composite matrix
comp_mat = [comp_mat, entry(:)];
% if rank is not equal to the number of columns, then entry is in the span
result = rank(comp_mat) ~= size(comp_mat, 2);
end