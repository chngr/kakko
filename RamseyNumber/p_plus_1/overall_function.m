% -- FOR P+1 --
% overall_function(): wrapper to compute dimension and signature
% Input: p -- dimension of K_p  
% Output: dimension and signature of Lie algebra
function [dim, sig] = overall_function(p)
% submatrices for E and F
E_0 = [0 1; 0 0];
E_1 = [0 2; 0 0];
E_2 = [0 (p+1); 0 0];
F_0 = [0 0; 1 0];
% concatenate submatrices along diagonal
E = blkdiag(E_0,E_1,E_2);
F = blkdiag(F_0,F_0,F_0);
gen_mat = {E,F};
gen_names = {'E','F'};
% write to output file
basis_2_txt(gen_mat);
% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
% computes Killing form of generated Lie algebra
killing_mat = killing_form(result_basis);
% computes signature of generated Lie algebra
sig = signature(killing_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
end