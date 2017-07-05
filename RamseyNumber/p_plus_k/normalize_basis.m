function result = normalize_basis(input_file,r,p)
pre_basis = parse_data(input_file,r,p);
normal_basis = {};
for i = 1:length(pre_basis)
   normal_basis{end+1} = normalize_matrix(pre_basis{i}); 
end
 
end