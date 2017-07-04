% overall_function(): wrapper to compute dimension, signature, and 
%                     Cartan matrix
% Input: p -- dimension of K_p
% Output: dimension, signature, and Cartan matrix of Lie algebra
function [dim, sig, cartan] = overall_function(p)
% finds basis of unlabelled graphs with K_p
[map,basis] = gen_basis(p);
% finds groups after performing E and F repeatedly
groups = grouping_basis(p,basis,map);
% converts to operator matrices E and F
[E,F] = grouping_to_mat(groups,p,map);
gen_mat = {E,F};
gen_names = {'E','F'};
% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
fprintf('dimension: %d\n', dim);
% computes signature of generated Lie algebra
sig = signature(result_basis);
fprintf('signature: %d\n', sig);
cartan = cartan_mat();
end