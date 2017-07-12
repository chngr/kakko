% find_cartan(): finds basis for a Cartan subalgebra 
% Input: lie_basis -- basis for Lie algebra g
% Output: cartan_basis -- basis for a Cartan subalgebra h in g
function cartan_basis = find_cartan(basis_mat,lie_basis)
% start checking at element [E,F]
for i = 3:length(lie_basis)
    cur_mat = lie_basis{i};
    if is_semisimple_elem(cur_mat,basis_mat,lie_basis)
        adj_mat = [];
        for j = 1:length(lie_basis)
          bracket_mat = bracket(cur_mat,lie_basis{j});
          % solve basis_mat [x] = bracket_mat to find coordinates wrt basis
          coord = basis_mat\(bracket_mat(:));
          adj_mat = [adj_mat, coord];
        end
        rank(adj_mat)
    end
end
end

% is_semisimple_elem(): checks whether an element of Lie algebra
% is a semisimple element (i.e. adjoint rep acts diagonalizably)
% Input: cur_mat -- element of Lie algebra
% Output: result -- boolean true if is semisimple, false otherwise
function result = is_semisimple_elem(cur_mat,basis_mat,lie_basis)
result = false;
adj_mat = [];
for i = 1:length(lie_basis)
  bracket_mat = bracket(cur_mat,lie_basis{i});
  % solve basis_mat [x] = bracket_mat to find coordinates wrt basis
  coord = basis_mat\(bracket_mat(:));
  adj_mat = [adj_mat, coord];
end
[V,~] = eig(adj_mat);
if rank(V) == length(V)
    result = true;
end
end