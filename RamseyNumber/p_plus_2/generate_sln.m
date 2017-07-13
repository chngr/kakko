% function to generate sln basis matrices
% input: n
% output: dimension and basis for sl_n
function [result_basis, gen_names] = generate_sln(n)
basis = {};
gen_names = {};
% create e_ij
for i = 1: n
    for j = 1 : n 
        if j == i
            continue
        else
            e_ij = sym(zeros(n));
            e_ij(i,j) = 1;
            basis{end+1} = e_ij;
            gen_names{end+1} = strcat('e_',int2str(i),int2str(j));
        end
    end
end
result_basis = basis;
end