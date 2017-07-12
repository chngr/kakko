% find_cartan_basis(): computes basis for Cartan subalgebra 
% Input: basis -- basis for overall Lie algebra
%        adj_group -- group of adjoint rep matrices corresponding to
%        basis elements
% Output: cartan_basis -- basis for Cartan subalgebra
function cartan_basis = find_cartan_basis(basis, basis_mat) 
elem_found = false;
while ~elem_found
    cur_elem = compute_random_element(basis);
    adj = adjoint_mat(cur_elem, basis, basis_mat);
    kernel = null(adj^(length(basis)));
    kernel_col = num2cell(kernel,1);
    kernel_mat = {};
    for i = 1:length(kernel_col)
        elem = 0;
        for j = 1:length(basis)
            elem = elem + kernel_col{i}(j) * basis{j};
        end
        kernel_mat{end+1} = elem;
    end
    if is_abelian(kernel_mat)
        elem_found = true;
    end
end
cartan_basis = kernel_mat;
end

% compute_random_element(): computes random element, inner product of 
%                           basis vectors with scaling
% Input: basis -- basis of Lie algebra
% Output: random element of Lie algebra
function result = compute_random_element(basis)
% generate [length(basis, 1] array of random ints sampled from {1,...,100}
scaling = randi(100,length(basis),1);
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
        if ~isequal(bracket(basis{i},basis{j}),zeros(length(basis{1})))
            is_abelian = false;
        end
    end
end
result = is_abelian;
end