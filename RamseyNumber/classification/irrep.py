# irrep.py

# weight_space_gen(): generates root spaces
# Input: cartan_basis -- list with Cartan basis set
#        diag_mat_list -- list of diagonal matrices corresponding to Cartan basis
#                         (with corresponding indices)
#        alg_dim -- dimension of overall Lie algebra
# Output: weight_space_list -- ker((rho(H_i) - a{ij} * id)^{dim V}) for all i and j
def weight_space_gen(cartan_basis, diag_mat_list, alg_dim):
    weight_space_list = []
    mat_size = cartan_basis[0].ncols()
    # for each element in Cartan basis
    for i in range(len(cartan_basis)):
        elem = cartan_basis[i]
        cur_diag = diag_mat_list[i].diagonal()
        sub_list = []
        # for each eigenvalue
        for eigenvalue in cur_diag:
            cur_space = ((elem - eigenvalue * matrix.identity(mat_size))^alg_dim).kernel()
            # add to list for given i and j
            sub_list.append(cur_space)
        # add sublist for given i to overall list
        weight_space_list.append(sub_list)
    return weight_space_list

# weight_space_decomp(): calculates root space decomposition 
# Input: weight_space_list -- list with sublists: each sublist has root spaces for 
#                           given element in Cartan basis
# Output: decomp_list -- list with spaces in root space decomposition
def weight_space_decomp(weight_space_list):
    # max_index for tuple set of indices
    max_index = len(weight_space_list[0]) - 1
    # length of each tuple in tuple set of indices
    basis_size = len(weight_space_list)
    index_set = get_tuples(max_index,basis_size)
    # direct_sum stores all of the intersections
    to_direct_sum = []
    # for each index
    for index in index_set:
        list_to_intersect = []
        # pair index with each sublist
        for i in range(len(index)):
            cur_index = index[i]
            list_to_intersect.append(weight_space_list[i][cur_index])
        cur_intersection = intersect_spaces(list_to_intersect)
        to_direct_sum.append(cur_intersection)
    to_direct_sum = list(set(to_direct_sum))
    for elem in to_direct_sum:
        if elem.dimension() == 0:
            to_direct_sum.remove(elem)
    return to_direct_sum

# get_tuples(): generates all possible tuples from 0 to max_val, inclusive
# Input: max_val -- maximum value in tuple 
#        list_len -- length of each tuple
# Output: tuple_list -- list of all possible tuples within range
def get_tuples(max_val, list_len):
    tuple_list = []
    # perform recursion
    if list_len > 1:
        return tuple_helper(get_tuples(max_val,list_len-1),max_val)
    # base case
    else:
        for i in range(max_val+1):
            tuple_list.append([i])
        return tuple_list

# tuple_helper(): helper function to perform recursion for get_tuples()
# Input: old_list -- list before current step of the recursion
#        max_val -- maximum value in tuple
# Output: new_list -- list after current step of the recursion
def tuple_helper(old_list, max_val):
    new_list = []
    for i in range(len(old_list)):
        cur_tuple = old_list[i]
        for j in range(max_val+1):
            new_cur_tuple = []
            new_cur_tuple = cur_tuple + [j]
            new_list.append(new_cur_tuple)
    return new_list

# adjoint_rep(): computes adjoint representation matrices of 
#                Lie algebra
# Input: input_elems -- set of matrices to compute adjoint rep of 
#        basis -- compute with respect to this basis 
# Output: ad -- list of adjoint representation matrices
def adjoint_rep(input_elems, basis):
    basis_vec = []
    ad = []
    # find matrix of basis 
    for b in basis:
        basis_vec.append(b.transpose().list())
    basis_mat = matrix(QQ,basis_vec).transpose()
    # find adjoint rep matrices
    for mat_elem in input_elems:
        mat_list = []
        for basis_elem in basis:
            bracket_vec = vector(QQ,bracket(mat_elem,basis_elem).transpose().list())
            coords = basis_mat.solve_right(bracket_vec)
            mat_list.append(coords.list())
        adj_mat = matrix(QQ,mat_list).transpose()
        ad.append(adj_mat)
    return ad

# ------------------------------------------------------------------------------------------

from random import randint

# simultaneous_diag(): simultaneously diagonalizes a commuting basis set
# Input: basis -- commuting basis
# Output: P -- matrix P of D = P^{-1} * A * P that simultaneously diagonalizes
#         diag_mat_list -- list of diagonalized matrices
def simultaneous_diag(basis):
    valid_elem = False
    # common P and unique D for each element in Cartan
    P = None
    diag_mat_list = []
    # find element that diagonalizes the Cartan basis
    while not valid_elem:
        diag_mat_list = []
        # compute a random element of the Cartan subalgebra
        cartan_elem = compute_random_element(basis)
        # diagonalize random element
        D, P = cartan_elem.eigenmatrix_right()
        # assume the diagonalization works
        valid_elem = True
        # check if diagonalizes all elements
        for elem in basis:
            cur_diag_mat = P.inverse() * elem * P
            diag_mat_list.append(cur_diag_mat)
            # check if each element is diagonalized
            if not gap.IsDiagonalMat(cur_diag_mat):
                valid_elem = False
                break
    return P, diag_mat_list

# compute_random_element(): computes random matrix element, random linear
#                           combination of basis vectors
# Input: basis -- basis of Lie algebra
# Output: random_elem -- random element of Lie algebra
def compute_random_element(basis):
    mat_size = basis[0].ncols()
    # choose coefficients from 1 to 100 inclusive
    scaling = [randint(1,100) for p in range(len(basis))]
    random_elem = matrix(QQ,mat_size)
    for i in range(len(basis)):
        random_elem = random_elem + scaling[i] * basis[i]
    return random_elem

# extract_weights(): determines a list of weights 
# Input: diag_mat_list -- set of diagonal matrices after simultaneously 
#        diagonalizing basis for the Cartan
# Output: weight_vec_list -- list of weights
def extract_weights(diag_mat_list):
    # extract the diagonals from the diagonalized matrices
    diag_vec_list = []
    for elem in diag_mat_list:
        diag_vec_list.append(elem.diagonal())
    # dim_H is the dimension of Cartan subalgebra
    # dim_V is the dimension of the entire space
    dim_H = len(diag_vec_list)
    dim_V = len(diag_vec_list[0])
    weight_vec_list = []
    # for ith index in each diagonal 
    for i in range(dim_V):
        # for jth diagonal vector, create a vector across a common index
        cur_vec = []
        for j in range(dim_H):
            cur_vec.append(diag_vec_list[j][i])
        weight_vec_list.append(cur_vec)
    return weight_vec_list

# highest_weight_gen(): determines direct sum of highest weight spaces
# Input: pos_root_vec -- set of positive root vectors
# Output: highest_weight_intersection -- direct sum of highest weight spaces
def highest_weight_gen(pos_root_vec):
    spaces_to_intersect = []
    for elem in pos_root_vec:
        spaces_to_intersect.append(elem.right_kernel())
    highest_weight_intersection = intersect_spaces(spaces_to_intersect)
    return highest_weight_intersection

# intersect_spaces(): computes intersection of vector spaces in space_list
# Input: space_list -- list of vector spaces over common base ring
# Output: inter_space -- intersection of spaces
def intersect_spaces(space_list):
    inter_space = space_list[0]
    for space in space_list:
        inter_space = inter_space.intersection(space)
    return inter_space

# find_highest_weights(): finds the weights in weight_list which are highest weights
# Input: highest_weight_intersection -- intersection of the highest weight spaces
#        weight_list -- list of all weights
#        P -- matrix of simultaneous eigenvectors
# Output: highest_weights -- weights in weight_list which are highest weights
def find_highest_weights(highest_weight_intersection, weight_list, P):
    highest_weights = []
    col_list = P.columns()
    for i in range(len(col_list)):
        cur_weight_space = span([col_list[i]],QQ)
        if highest_weight_intersection.intersection(cur_weight_space).dimension() != 0:
            highest_weights.append(weight_list[i])
    return highest_weights

# find_irreps(): finds the multiplicities of irreps
# Input: simple_roots -- list of simple roots
#        highest_weights -- list of highest weights
# Output: irrep_dict -- dictionary mapping irrep identifier to frequency
def find_irreps(simple_roots, highest_weights):
    # map from tuple to frequency
    irrep_dict = {}
    # build matrix of simple roots
    simple_root_mat = matrix(QQ,simple_roots).transpose()
    # solve for int coordinates of highest_weights wrt simple_root_mat
    for elem in highest_weights:
        coords = tuple(simple_root_mat.solve_right(vector(QQ,elem)))
        if coords not in irrep_dict:
            irrep_dict[coords] = 1
        else:
            irrep_dict[coords] += 1
    return irrep_dict

# --------------------- MAIN SCRIPT ---------------------

# SL_3 Test
# e_1 = matrix([[0,1,0],[0,0,0],[0,0,0]])
# e_2 = matrix([[0,0,0],[1,0,0],[0,0,0]])
# e_3 = matrix([[0,0,0],[0,0,1],[0,0,0]])
# e_4 = matrix([[0,0,0],[0,0,0],[0,1,0]])
# gens = [e_1,e_2,e_3,e_4]

# SO_4 Test 
# e_1 = matrix([[0,0,1,0],[0,0,0,0],[0,0,0,0],[0,0,0,0]])
# e_2 = matrix([[0,0,0,0],[0,0,0,1],[0,0,0,0],[0,0,0,0]])
# e_3 = matrix([[0,0,0,0],[0,0,0,0],[1,0,0,0],[0,0,0,0]])
# e_4 = matrix([[0,0,0,0],[0,0,0,0],[0,0,0,0],[0,1,0,0]])
# gens = [e_1,e_2,e_3,e_4]

# In GAP -- Compute:
#   Lie algebra
#   dimension of Lie algebra
#   Cartan subalgebra
#   basis for Cartan subalgebra
#   root System for Lie algebra
#   simple roots of Lie algebra
#   positive root vectors of Lie algebra
gens = [E,F]
lie_alg = gap.LieAlgebra('Rationals',gens)
lie_type = gap.SemiSimpleType(lie_alg)
alg_dim = gap.Dimension(lie_alg)
cartan_alg = gap.CartanSubalgebra(lie_alg)
cartan_basis = gap.BasisVectors(gap.Basis(cartan_alg))
root_sys = gap.RootSystem(lie_alg)
simple_roots = gap.SimpleSystem(root_sys)
pos_root_vec = gap.PositiveRootVectors(root_sys)

# convert from GAP to Sage format: cartan_basis
sage_cartan_basis = []
for elem in cartan_basis:
    sage_cartan_basis.append(matrix(QQ,elem))
# convert from GAP to Sage format: pos_root_vec
sage_pos_root_vec = []
for elem in pos_root_vec:
    sage_pos_root_vec.append(matrix(QQ,elem))
# convert from GAP to Sage format: simple_roots
sage_simple_roots = []
for elem in simple_roots:
    sage_simple_roots.append(list(elem))

# simultaneously diagonalize the Cartan basis
P, diag_mat_list = simultaneous_diag(sage_cartan_basis)
# extract the weights from the diagonalized matrices
weight_list = extract_weights(diag_mat_list)
# find the intersection of highest weight spaces
highest_weight_intersection = highest_weight_gen(sage_pos_root_vec)
# find the highest weights
highest_weights = find_highest_weights(highest_weight_intersection, weight_list, P)
# find coordinates of highest weights wrt simple roots
irrep_dict = find_irreps(sage_simple_roots, highest_weights)