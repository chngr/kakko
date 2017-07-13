% generate_sln(): creates sl_n generator matrices and names
% Input: n -- dimension for sl_n
% Output: gen_mat -- generator matrices for sl_n
%         gen_names -- generator names 
function [gen_mat, gen_names] = generate_sln(n)
gen_mat = {};
gen_names = {};
% create generators
for i = 1:n-1
    % add (i,i+1) entry (superdiagonal)
    e_sup = zeros(n);
    e_sup(i,i+1) = 1;
    gen_mat{end+1} = e_sup;
    gen_names{end+1} = strcat('e_',int2str(i),int2str(i+1));
    % add (i+1,i) entry (subdiagonal)
    e_sub = zeros(n);
    e_sub(i+1,i) = 1;
    gen_mat{end+1} = e_sub;
    gen_names{end+1} = strcat('e_',int2str(i+1),int2str(i));
end
end