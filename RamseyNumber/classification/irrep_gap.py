gens := [mat_1, mat_2];
lie_alg := LieAlgebra(Rationals,gens);
alg_dim := Dimension(lie_alg);
cartan_alg := CartanSubalgebra(lie_alg);
cartan_basis := BasisVectors(Basis(cartan_alg));
root_sys := RootSystem(lie_alg);
simple_roots := SimpleSystem(root_sys);
pos_root_vec := PositiveRootVectors(root_sys);

PrintTo("pre_sage.txt", "cartan_basis = ", cartan_basis, "\n", "pos_root_vec = ", pos_root_vec, "\n", "simple_roots = ", simple_roots)