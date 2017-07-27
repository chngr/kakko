% -- FOR P+2 --
% overall_function(): wrapper to compute dimension and signature
% Input: p -- dimension of K_p  
% Output: result_basis -- basis of generated Lie algebra
%         printed: dimension and signature
% NOTE: Valid for p >= 4.
function result_basis = overall_function(p)
% find basis of unlabelled graphs with K_p
[map, basis] = gen_basis(p);
% find groups after performing E and F repeatedly
groups = grouping_basis(p,basis,map);
% convert to operator matrices E and F
[E,F] = grouping_to_mat(groups,p,map);
% create cell array of generators
gen_mat = {E,F};
gen_names = {'E','F'};
% write E and F to .txt file
%gen_file_name = strcat(mat2str(p),'_plus_2.txt');
gen_file_name = strcat(mat2str(p),'_plus_2_irrep.py');
%mat_to_txt(gen_mat,gen_file_name,p);
print_E_F(gen_mat,gen_file_name);

%{
% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
% computes Killing form of generated Lie algebra
[basis_mat, kil_mat, determinant] = killing_form(result_basis);
basis_2_txt({kil_mat},'killing.txt')
% computes signature of generated Lie algebra
[eigenvalues, sig] = signature(kil_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
fprintf('determinant of Killing matrix: %d\n', determinant);
% finds Cartan basis
cartan_basis = find_cartan_basis(result_basis, basis_mat);
root_mat = diagonal_to_mat(cartan_basis, result_basis, basis_mat);
pos_roots = find_pos_roots(root_mat);
cartan_mat = find_cartan_mat(pos_roots);
%}
end