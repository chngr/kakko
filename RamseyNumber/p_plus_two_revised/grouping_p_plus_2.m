function [E,F] = grouping_p_plus_2(p)
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
E_col = {};
F_col = {};
for i = 1:length(disjoint_parts)
    E_col{end+1} = opr_on_index_array(disjoint_parts{i},'E',p,basis);
    F_col{end+1} = opr_on_index_array(disjoint_parts{i},'F',p,basis);
end
E = E_col{1};
F = F_col{1};
for i = 2:length(E_col)
    E = blkdiag(E,E_col{i});
    F = blkdiag(F,F_col{i});
end

dlmwrite('E_file.txt',E)
f = fopen('E_file.txt','a');
fprintf(f, '\n\n');
fclose(f);
dlmwrite('E_file.txt',E','-append')

dlmwrite('F_file.txt',F)
g = fopen('F_file.txt','a');
fprintf(g, '\n\n');
fclose(g);
dlmwrite('F_file.txt',F','-append')
end