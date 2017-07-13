# ---------------------- find_cartan_basis --------------------
from random import randint

# find_cartan_basis(): computes basis for Cartan subalgebra 
# Input: basis -- basis for overall Lie algebra
#        adj_group -- group of adjoint rep matrices corresponding to
#        basis elements
# Output: cartan_basis -- basis for Cartan subalgebra
def find_cartan_basis(basis):
    elem_found = False;
    while not elem_found:
        cur_elem = compute_random_element(basis)
        adj = adjoint_mat(cur_elem, basis)
        kernel_space = kernel(adj**(len(basis)))
        kernel_col = kernel_space.basis()
        kernel_mat = []
        for i in range(len(kernel_col)):
            elem = 0
            for j in range(len(basis)):
                elem = elem + kernel_col[i][j] * basis[j]
            kernel_mat.append(elem)
        if is_abelian(kernel_mat):
            elem_found = True
    return kernel_mat


# compute_random_element(): computes random element, inner product of 
#                           basis vectors with scaling
# Input: basis -- basis of Lie algebra
# Output: random element of Lie algebra
def compute_random_element(basis):
    scaling = [randint(0,100) for p in range (0,len(basis))]
    random_elem = 0
    for i in range(len(basis)):
        random_elem = random_elem + scaling[i] * basis[i]
    return random_elem


# is_abelian(): determines whether Lie algebra determined by basis is 
#               abliean
# Input: basis -- basis of Lie algebra
# Output: result -- boolean true if abelian, false otherwise
def is_abelian(basis):
    matrix_size = basis[0].ncols()
    is_abelian = True
    for i in range(len(basis)):
        for j in range(i+1,len(basis)):
            if bracket(basis[i],basis[j]) != matrix(matrix_size):
                is_abelian = False
    return is_abelian


# adjoint_mat(): computes adjoint representation matrix for matrix given
#                basis set and basis matrix
# Input: mat -- matrix to compute adj of 
#        basis -- basis for Lie algebra
# Output: result -- adjoint matrix
def adjoint_mat(mat,basis):
    basis_vec = []
    for b in basis:
        basis_vec.append(b.list())
    vs = span(matrix(basis_vec),QQ)
    print(vs)
    mat_list = []
    for right in basis:
        bracket_vec = vector(QQ,bracket(mat,right).list())
        coords = vs.coordinates(bracket_vec)
        mat_list.append(coords)
    return matrix(QQ,mat_list).transpose()

# TODO:
# ---------------------- find_pos_roots --------------------
# find_pos_roots(): compute the positive roots
# Input: root_mat -- unprocessed root matrix
# Output: pos_roots -- cell array of positive roots
def find_pos_roots(root_mat):
    num_rows = root_mat.nrows()
    num_cols = root_mat.ncols()
    for i in range(num_cols,0,-1):
        cur_col = root_mat.transpose()[i]
        if cur_col == zero_vector(QQ,num_rows):
            root_mat = root_mat.delete_columns([i])
    # update num_cols
    num_cols = root_mat.ncols()
    is_valid = False
    while not is_valid:
        scaling = [randint(0,100) for p in range (0,num_rows)]
        is_valid = is_valid_scaling(root_mat,scaling)
    pos_roots = []
    for i in range(num_cols):
        cur_col = root_mat.transpose()[i]
        if cur_col.dot_product(scaling) == 1:
            pos_roots.append(cur_col)


# is_valid_scaling(): checks if scaling vector is valid
# Condition: after removing zero rows of root matrix, all inner products
# should be nonzero
# Input: root_mat -- root matrix with rows of zeros removed
#        scaling -- vector to take inner product with
# Output: result -- boolean true if scaling vector is valid
def is_valid_scaling(root_mat, scaling):
    num_rows = root_mat.nrows()
    num_cols = root_mat.ncols()
    is_valid = True
    print("Reached is_valid_scaling")
    for i in range(num_cols):
        cur_col = root_mat.transpose()[i]
        if cur_col.dot_product(scaling) == 0:
            is_valid = False
            break
    return is_valid


# ---------------------- find_cartan_mat --------------------

# find_cartan_mat(): finds Cartan matrix given a collection of positive
#                    roots
# Input: pos_roots -- positive roots of Cartan subalgebra
# Output: cartan_mat -- Cartan matrix for Lie algebra
def find_cartan_mat(pos_roots):
    cartan_mat = [] 
    for i in range(len(pos_roots)):
        cartan_mat.append([])
        for j in range(len(pos_roots)):
           #????
           entry = (2*pos_roots[i].dot_product(pos_roots[j]))/pos_roots[i].dot_product(pos_roots[j])
           cartan_mat[i].append(entry)
    return matrix(cartan_mat)
