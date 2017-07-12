% find_cartan_basis(): computes basis for Cartan subalgebra 
% Input: basis -- basis for overall Lie algebra
%        adj_group -- group of adjoint rep matrices corresponding to
%        basis elements
% Output: cartan_basis -- basis for Cartan subalgebra
function cartan_basis = find_cartan_basis(basis, basis_mat) 
elem_found = false;
index = 0;
while ~elem_found
    cur_elem = compute_random_element(basis, index);
    adj = adjoint_mat(cur_elem, basis, basis_mat);
    kernel = null(adj^(length(basis)));
    if is_abelian(kernel)
        elem_found = true;
    end
    index = index + 1;
end
cartan_basis = kernel;
end

% compute_random_element(): computes random element, inner product of 
%                           basis vectors with scaling
% Input: basis -- basis of Lie algebra
%        index -- index to keep track of which element to try;
%                 offset to add to 1:n (starting from 0, 1, ...)
% Output: random element of Lie algebra
function result = compute_random_element(basis, index)
scaling = 1:length(basis);
for i = 1:length(scaling)
    scaling(i) = i + index;
end
random_elem = 0;
for i = 1:length(basis)
    random_elem = random_elem + scaling(i) * basis{i};
end
result = random_elem;
end

% is_abelian(): determines whether Lie algebra determined by basis is 
%               abliean
% Input: basis -- basis of Lie algebra
% Output: result -- boolean true if abelian, false otherwise
function result = is_abelian(basis)
is_abelian = true;
for i = 1:length(basis)
    for j = i+1:length(basis)
        if ~isequal(bracket(basis{i},basis{j}),bracket(basis{j},basis{i}))
            is_abelian = false;
        end
    end
end
result = is_abelian;
end