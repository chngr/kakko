% overall_function(): wrapper to compute dimension and signature
% Input: input_file -- name of input_file with graphs on p+3 vertices
%        p -- dimension of K_p  
% Output: dimension and signature of Lie algebra
function [dim, sig] = overall_function(input_file,p)
p_str = int2str(p);
% finds basis of unlabelled graphs with K_p
[map,basis] = gen_basis(input_file,p);
% finds groups after performing E and F repeatedly
groups = grouping_basis(p,basis,map);
% converts to operator matrices E and F
[E,F] = grouping_to_mat(groups,p,map);
gen_mat = {E,F};
% Write result_basis to .txt file
file_name = strcat(p,'_plus_3.g');
mat_to_txt({E,F},file_name,p);
%{
disp('Finished writing to .txt')
gen_names = {'E','F'};
% computes dimension and basis of generated Lie algebra 
[dim,result_basis] = bracket_operation(gen_mat,gen_names);
% computes Killing form of generated Lie algebra
killing_mat = killing_form(result_basis);
% computes signature of generated Lie algebra
sig = signature(killing_mat);
fprintf('dimension: %d\n', dim);
fprintf('signature: %d\n', sig);
%}
end