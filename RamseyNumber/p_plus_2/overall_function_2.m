% -- FOR P+2 --
% overall_function_2(): wrapper to compute dimension and signature
% Input: p -- dimension of K_p
% Output: dimension and signature of generated Lie algebra
function [dim, sig] = overall_function_2(p)
% finds basis of unlabelled graphs with K_p
[map,basis] = gen_basis(p);
% finds groups after performing E and F repeatedly
groups = grouping_basis(p,basis,map);
% converts to operator matrices E and F
[E,F] = grouping_to_mat_2(groups,p,map);
gen_mat = {E,F};
gen_names = {'E','F'};
% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
%{
% computes Killing form of generated Lie algebra
killing_mat = killing_form(result_basis);
% computes signature of generated Lie algebra
sig = signature(killing_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
%}
end