function result = grouping_p_plus_2(p)
% basis: whole basis
basis = new_basis_plus_two(p);
index_array = [];
partitions = {};
for i = 1:length(basis)
   [~, index] = mat_2_tuple(basis{i});
   index_array = [index_array, index];
end
while ~isempty(index_array)
    new_group = mult_E_F(index_array(1),p,basis);
    partitions{end+1} = new_group;
    index_array = setdiff(index_array, new_group);
end
disjoint_parts = make_disjoint(partitions,length(basis));
result = disjoint_parts;
celldisp(result);
end