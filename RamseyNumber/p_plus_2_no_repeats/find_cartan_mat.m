% find_cartan_mat(): finds Cartan matrix given a collection of positive
%                    roots
% Input: pos_roots -- positive roots of Cartan subalgebra
% Output: cartan_mat -- Cartan matrix for Lie algebra
function cartan_mat = find_cartan_mat(pos_roots)
cartan_mat = [];
for i = 1:length(pos_roots)
    for j = 1:length(pos_roots)
        cartan_mat(i,j) = ...
        (2 * dot(pos_roots{i},pos_roots{j}))/dot(pos_roots{i},pos_roots{i});
    end
end
end