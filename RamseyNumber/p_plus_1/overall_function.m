% -- FOR P+1 --
% overall_function(): wrapper to compute dimension and signature
% Input: p -- dimension of K_p
% Output: result_basis -- basis of generated Lie algebra
%         printed: dimension and signature
% NOTE: Valid for p >= 3.
function result_basis = overall_function(p)
% submatrices for E and F
E_1 = [0 1; 0 0];
E_2 = [0 2; 0 0];
E_3 = [0 (p+1); 0 0];
F_1 = [0 0; 1 0];
% concatenate submatrices along diagonal
E = blkdiag(E_1,E_2,E_3);
F = blkdiag(F_1,F_1,F_1);
gen_mat = {E,F};
gen_names = {'E','F'};
% write E and F to output file
gen_file_name = strcat(mat2str(p),'_plus_1_gen.txt');
mat_to_txt(gen_mat,gen_file_name);
% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
% computes Killing form of generated Lie algebra
killing_mat = killing_form(result_basis);
% computes signature of generated Lie algebra
sig = signature(killing_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
end