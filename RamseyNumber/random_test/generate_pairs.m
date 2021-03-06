% generate_pairs: get all possible pair of generators
% input: basis of matrices
% output: array of all pairs
function pair_basis = generate_pairs(size)
basis = gen_ran_basis(size);
temp_basis = basis;
pair_basis = {};
while ~isempty(temp_basis)
    cur_pair = {temp_basis{1},temp_basis{1}'};
    pair_basis{end+1} = cur_pair;
    % set diff for temp_basis and cur_pair 
    temp_basis_str = cellfun(@mat2str,temp_basis,'UniformOutput',false);
    cur_pair_str = cellfun(@mat2str,cur_pair,'UniformOutput',false);
    new_basis_str = setdiff(temp_basis_str,cur_pair_str);
    temp_basis = cellfun(@eval,new_basis_str,'UniformOutput',false);
end
end