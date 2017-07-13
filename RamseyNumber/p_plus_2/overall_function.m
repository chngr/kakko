% -- FOR P+2 --
% overall_function(): wrapper to compute dimension and signature
% Input: p -- dimension of K_p
% Output: dimension and signature of generated Lie algebra
function [cartan_basis, cartan_mat] = overall_function(p)
% finds basis of unlabelled graphs with K_p
[map,basis] = gen_basis(p);
% finds groups after performing E and F repeatedly
groups = grouping_basis(p,basis,map);
% converts to operator matrices E and F
[E,F] = grouping_to_mat(groups,p,map);
% Write result_basis to .txt file
basis_2_txt({E,F},'E_F.txt');

% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
% output all basis to txt file
basis_2_txt(result_basis,'basis.txt')
% computes Killing form of generated Lie algebra
[basis_mat, kil_mat] = killing_form(result_basis);
basis_2_txt({kil_mat},'killing.txt')
% computes signature of generated Lie algebra
[eigenvalues, sig] = signature(kil_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
% finds Cartan basis
cartan_basis = find_cartan_basis(result_basis, basis_mat);
assignin('base','cartan_basis',cartan_basis);
root_mat = diagonal_to_mat(cartan_basis, result_basis, basis_mat);
assignin('base','root_mat',root_mat);
pos_roots = find_pos_roots(root_mat);
assignin('base','pos_roots',pos_roots);
cartan_mat = find_cartan_mat(pos_roots);
assignin('base','cartan_mat',cartan_mat);
end