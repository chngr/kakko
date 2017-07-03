% grouping_basis(p) -- grouping basis by operation of E and F
% Input: p -- number of vertices E and F operate on 
% output: cell array of grouped bases

function result = grouping_basis(p)
% basis: whole basis
tuple_basis = gen_basis(p); % generate basis of tuples
%tuple_basis = {[1,3,0,0,0,1],[0,0,0,0,3,0]};
partitions = {};

while ~isempty(tuple_basis)
    new_group = multi_opr_on_tuple(tuple_basis{1},p+2);
    partitions{end+1} = new_group;
    
    % set diff for basis and new_group generated
    basis_str = cellfun(@mat2str, tuple_basis, 'UniformOutput', false);
    new_group_str = cellfun(@mat2str, new_group, 'UniformOutput', false);
    basis_str = setdiff(basis_str, new_group_str);
    tuple_basis = cellfun(@eval, basis_str, 'UniformOutput',false);

end
result = partitions;
celldisp(result);
end