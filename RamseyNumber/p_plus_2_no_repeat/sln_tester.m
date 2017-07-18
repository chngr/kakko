% sln_tester(): overall function performed on sl_n test cases
% Input: n -- dimension for sl_n
% Output: cartan_basis -- basis for Cartan subalgebra
%         cartan_matrix -- Cartan matrix
function [cartan_basis, cartan_matrix] = sln_tester(n)
% creates generators for sl_n
[gen_mat,gen_names] = generate_sln(n);
% computes dimension and basis of generated Lie algebra
[dim,lie_basis] = bracket_operation(gen_mat,gen_names);
% outputs basis matrices to txt file
basis_2_txt(lie_basis,'basis.txt');
% computes Killing form of generated Lie algebra
[basis_mat,kil_mat] = killing_form(result_basis);
% outputs Killing matrix to txt file
basis_2_txt({kil_mat},'killing.txt')
% computes signature of generated Lie algebra
sig = signature(kil_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
% finds Cartan basis
cartan_basis = find_cartan_basis(lie_basis, basis_mat);
assignin('base','cartan_basis',cartan_basis);
root_mat = diagonal_to_mat(cartan_basis, lie_basis, basis_mat);
assignin('base','root_mat',root_mat);
pos_roots = find_pos_roots(root_mat);
assignin('base','pos_roots',pos_roots);
cartan_mat = find_cartan_mat(pos_roots);
assignin('base','cartan_mat',cartan_mat);
end