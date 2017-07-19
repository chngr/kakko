% grouping_basis(): grouping basis by operations of E and F
% Input: p -- dimension of K_p
%        basis -- basis of elements 
%        map -- map from tuple to representative
% Output: groups -- cell array of grouped bases
function groups = grouping_basis(p,basis,map)
% basis of tuples
tuple_basis = basis;
partitions = {};
while ~isempty(tuple_basis)
    new_group = multi_opr_on_tuple(tuple_basis{1},p+2,map);
    partitions{end+1} = new_group;
    % set diff for basis and new_group generated
    basis_str = cellfun(@mat2str,tuple_basis,'UniformOutput',false);
    new_group_str = cellfun(@mat2str,new_group,'UniformOutput',false);
    basis_str = setdiff(basis_str,new_group_str);
    tuple_basis = cellfun(@eval,basis_str,'UniformOutput',false);
end
groups = partitions;
end