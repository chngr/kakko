# cartan.py

from math import *
from random import randint

# ----------------------------------
# --------- GENERATE BASIS ---------
# ----------------------------------

# sln_generator(): generates generator matrices and names for sl_n
# Input: n -- dimension of sl_n
# Output: list -- list[0] holds generator matrices, list[1] holds generator names
def sln_generator(n):
    gen_mat = []
    gen_names = []
    # create generators
    for i in range(n-1):
        # add (i,i+1) entry (superdiagonal)
        e_sup = matrix(QQ,n)
        e_sup[i,i+1] = 1
        gen_mat.append(e_sup)
        gen_names.append('e_' + str(i+1) + str(i+2))
        # add (i+1,i) entry (subdiagonal)
        e_sub = matrix(QQ,n)
        e_sub[i+1,i] = 1
        gen_mat.append(e_sub)
        gen_names.append('e_' + str(i+2) + str(i+1))
    return [gen_mat, gen_names]

# bracket(): bracket operator
# Input: Sage matrices A and B
# Output: Lie bracket [A,B]
def bracket(A,B):
    return A * B - B * A

# name_bracket(): function to compute string names for brackets
# Input: matrix string names 'A' and 'B'
# Output: bracket string '[A,B]'
def name_bracket(A,B):
    return "[" + A + "," + B + "]"

# bracket_operation(): compute basis from generators
# Input: gen_mat -- Sage generator matrices (list)
#        gen_names -- string names of generator matrices (list)
# Output: basis of Lie algebra generated
def bracket_operation(gen_mat,gen_names):
    # initialization
    old_list = [] 
    name_old_list = [] 
    new_list = [] 
    # initialize name_new_list
    name_new_list = [] 
    for gen in gen_mat:
        new_list.append(gen)
    for name in gen_names:
        name_new_list.append(name) 
        print(name)
    # loop until no new independent elements generated
    while True:
        temp_list = [] 
        name_temp_list = [] 
        # take pairwise brackets for all elements in new_list
        for i in range(len(new_list)):
            for j in range(i+1,len(new_list)):
                new_entry = bracket(new_list[i],new_list[j]) 
                name_new_entry = name_bracket(name_new_list[i],name_new_list[j]) 
                # if not in span of previous elements
                if not in_span(old_list + new_list + temp_list, new_entry):
                    # add new entry
                    temp_list.append(new_entry) 
                    name_temp_list.append(name_new_entry) 
                    print(name_new_entry)
        # take pairwise brackets of old_list and new_list
        for i in range(len(old_list)):
            for j in range(len(new_list)):
                new_entry = bracket(old_list[i], new_list[j]) 
                name_new_entry = name_bracket(name_old_list[i], name_new_list[j])          
                # if not in span of previous elements
                if not in_span(old_list + new_list + temp_list, new_entry):
                    # add new entry
                    temp_list.append(new_entry)
                    name_temp_list.append(name_new_entry)
                    print(name_new_entry)
        # update lists for new iteration of loop
        old_list = old_list + new_list
        new_list = temp_list
        name_old_list = name_old_list + name_new_list
        name_new_list = name_temp_list
        # if temp_list is empty, independent basis generated
        if len(temp_list) == 0:
            dim = len(old_list)
            print("Number of independent matrices: %d" % dim)
            return old_list

# in_span(): checks whether matrix entry is in the span of
# the matrices in list
# Input: cell array list of matrices, entry to check independence of
# Output: boolean true if in span, false otherwise
def in_span(in_list, entry):
    col_len = (in_list[0].ncols())**2
    comp_mat = matrix(QQ,col_len,0)
    for i in range(len(in_list)):
        cur_mat = vector(QQ,in_list[i].transpose().list())
        comp_mat = comp_mat.augment(cur_mat)
    entry_vec = vector(QQ,entry.transpose().list())
    comp_mat = comp_mat.augment(entry_vec)
    return rank(comp_mat) != comp_mat.ncols()

# killing_form(): computes Killing form of Lie algebra
# Input: basis for rho_{p+r}(a_p) (general)
# Output: matrix of Killing form
def killing_form(ad):
    kil = matrix(QQ,[[(g * h).trace() for g in ad] for h in ad])
    print_2_txt(kil,'killing_py.txt')
    return kil

# signature(): computes signature of Lie algebra
# Input: killing_mat -- matrix of Killing form
# Output: signature
#         printed: counts for positive, negative, and zero eigenvalues for 
#         matrix of Killing form
def signature(killing_mat):
    eig_vec = killing_mat.eigenvalues()
    pos_count = 0
    zero_count = 0
    neg_count = 0
    for i in range(len(eig_vec)):
        if eig_vec[i] > 0:
            pos_count += 1
        elif eig_vec[i] < 0:
            neg_count += 1
        else:
            zero_count += 1
    sig = pos_count - neg_count
    print("Positive eigenvalue count: %d"%pos_count)
    print("Negative eigenvalue count: %d"%neg_count)
    print("Zero eigenvalue count: %d"%zero_count)
    print("Signature: %d"%sig)
    return eig_vec

# classify_alg(): classifies Lie algebra given dim and sig
# Input: dimension and signature
# Output: list of candidates for Lie algebra
def classify_alg(dim, sig):
    solution_list = []
    dim_list = []
    sig_list = []
    # for later -- find sigs of remaining exceptionals
    # excep_dim = [14,56,78,133,248]
    # excep_sig = [-14,...]
    excep_dim = [14]
    excep_sig = [-14]
    max_len = floor((1 + sqrt(1+8*dim))/2)
    list_len = 3*max_len - 2 
    max_val = floor(dim/3)
    tuple_list = get_tuples(max_val,list_len)
    # for sl_n: start from n = 2
    for i in range(2,max_len+1):
        sig_list.append(i-1)
        dim_list.append(i**2 - 1)
    # for so_n: start from n = 3
    for i in range(3,max_len+1):
        sig_list.append(-i)
        dim_list.append(int(i*(i-1)/2))
    # for sp_{2n}: start from n = 1
    for i in range(1,max_len+1):
        sig_list.append(i)
        dim_list.append(2*i**2 + i)
    sig_list = sig_list + excep_sig
    dim_list = dim_list + excep_dim
    for k in range(len(tuple_list)):
        cur_dim = sum([i*j for (i,j) in zip(tuple_list[k], dim_list)])
        cur_sig = sum([i*j for (i,j) in zip(tuple_list[k], sig_list)])
        if cur_dim == dim and cur_sig == sig:
            solution_list.append(tuple_list[k])
    for i in range(len(solution_list)):
        cur_solution = solution_list[i]
    return solution_list

# get_tuples(): generates list of frequency tuples recursively
# Input: frequency max_value (floor(dim/3)) and length of list 
# Output: list of frequency tuples with entries from 0 to floor(dim/3),
#         each with length list_len
def get_tuples(max_val, list_len):
    test_list = []
    if list_len > 1:
        return tuple_helper(get_tuples(max_val,list_len-1),max_val)
    else:
        for i in range(max_val+1):
            test_list.append([i])
        return test_list

# tuple_helper(): helper function to perform recursion
# Input: old list and max value
# Output: list of tuples with (length + 1) with everything up to max value
def tuple_helper(old_list, max_val):
    new_list = []
    for i in range(len(old_list)):
        cur_tuple = old_list[i]
        for j in range(max_val+1):
            new_cur_tuple = []
            new_cur_tuple = cur_tuple + [j]
            new_list.append(new_cur_tuple)
    return new_list

# print_2_txt(): prints matrix to text file
# Input: mat -- matrix to print
#        name -- name of text file
# Output: textfile with matrix as string
def print_2_txt(mat, name):
    f = open(name, 'w')
    f.write(mat.str())
    f.close()


# ----------------------------
# ---------- CARTAN ----------
# ----------------------------

# find_cartan_basis(): computes basis for Cartan subalgebra 
# Input: basis -- basis for overall Lie algebra
# Output: mat_group -- basis for Cartan subalgebra
def find_cartan_basis(basis):
    mat_size = basis[0].ncols()
    elem_found = False
    # loop until valid element is found
    while not elem_found:
        cur_elem = compute_random_element(basis)
        # find kernel of adjoint^(dim of Lie algebra)
        adj = adjoint_mat(cur_elem, basis)
        kernel_col = (adj^(len(basis))).right_kernel().basis()
        mat_group = []
        for kernel_elem in kernel_col:
            mat_elem = matrix(QQ,mat_size)
            for i in range(len(basis)):
                mat_elem = mat_elem + kernel_elem[i] * basis[i]
            mat_group.append(mat_elem)
        # check if generated space is abelian
        if is_abelian(mat_group):
            elem_found = True
    return mat_group

# complete_basis(): completes the Cartan basis to the Lie algebra basis
# Input: lie_basis -- existing basis for Lie algebra
#        cartan_basis -- basis for Cartan subalgebra to be completed
# Output: cur_basis -- basis for Lie algebra which includes elements in
#                      the Cartan basis
def complete_basis(lie_basis, cartan_basis):
    cur_basis = cartan_basis
    for elem in lie_basis:
        if not in_span(cur_basis, elem):
            cur_basis.append(elem)
    return cur_basis

# compute_random_element(): computes random matrix element, inner 
#                           product of basis matrices with scaling
# Input: basis -- basis of Lie algebra
# Output: random_elem -- random element of Lie algebra
def compute_random_element(basis):
    mat_size = basis[0].ncols()
    scaling = [randint(1,100) for p in range(0,len(basis))]
    random_elem = matrix(QQ,mat_size)
    for i in range(len(basis)):
        random_elem = random_elem + scaling[i] * basis[i]
    return random_elem

# compute_random_vector(): computes random vector, inner product of 
#                          vectors with scaling
# Input: basis -- basis of Lie algebra
# Output: random_elem -- random element of Lie algebra
def compute_random_vector(basis):
    mat_size = basis[0].ncols()
    scaling = [randint(1,100) for p in range(0,len(basis))]
    random_elem = matrix(QQ,1,mat_size)
    for i in range(len(basis)):
        random_elem = random_elem + scaling[i] * basis[i]
    return random_elem

# is_abelian(): determines whether Lie algebra determined by basis is 
#               abliean
# Input: basis -- basis of Lie algebra
# Output: is_abelian -- boolean true if abelian, false otherwise
def is_abelian(basis):
    mat_size = basis[0].ncols()
    is_abelian = True
    for i in range(len(basis)):
        for j in range(i+1,len(basis)):
            if bracket(basis[i],basis[j]) != matrix(QQ,mat_size):
                is_abelian = False
    return is_abelian

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

# adjoint_mat(): computes adjoint representation matrix for matrix given
#                the basis set
# Input: mat -- matrix to compute adjoint rep matrix of 
#        basis -- basis for Lie algebra
# Output: adj_mat -- adjoint matrix
def adjoint_mat(input_mat, basis):
    basis_vec = []
    col_list = []
    # find matrix of basis
    for b in basis:
        basis_vec.append(b.transpose().list())
    basis_mat = matrix(QQ,basis_vec).transpose()
    # find adjoint rep matrices
    for elem in basis:
        bracket_vec = vector(QQ,bracket(input_mat,elem).transpose().list())
        coords = basis_mat.solve_right(bracket_vec)
        col_list.append(coords.list())
    adj_mat = matrix(QQ,col_list).transpose()
    return adj_mat

'''
TO RETURN TO LATER: FINISH CHECKING DIAGONALIZATION CONDITION

# diag_to_root_mat(): converts basis for Cartan subalgebra into root matrix
# Input: cartan_basis -- basis for Cartan subalgebra
#        alg_basis -- basis for original Lie algebra
# Output: root_mat -- root matrix of Cartan subalgebra
def diag_to_root_mat(cartan_basis, alg_basis):
    # compute basis matrix for Lie algebra
    basis_vec = []
    for b in alg_basis:
        basis_vec.append(b.transpose().list())
    basis_mat = matrix(QQ,basis_vec).transpose()
    # adjoint representation of Cartan on Lie basis
    cartan_ad = adjoint_rep(cartan_basis,alg_basis)
    mat_size = cartan_ad[0].ncols()
    valid_elem = False 
    # find element that diagonalizes the Cartan basis
    while not valid_elem:
        # compute a random element of the Cartan subalgebra
        cartan_elem = compute_random_element(cartan_ad)
        # diagonalize random element
        D, P = cartan_elem.eigenmatrix_right()
    # build the root matrix
    root_mat = matrix(QQ,0,mat_size)
    for elem in cartan_ad:
        cur_diag = (P.inverse() * elem * P).diagonal()
        root_mat = root_mat.stack(vector(cur_diag))
    root_mat = root_mat.stack(matrix(QQ,len(alg_basis)-len(cartan_basis),len(alg_basis)))
    return root_mat
'''

# find_simple_roots(): compute the simple roots of the Cartan subalgebra
# Input: root_mat -- unprocessed root matrix
# Output: simple_roots -- cell array of simple roots
def find_simple_roots(root_mat, kil_cartan_inv):
    num_rows = root_mat.nrows()
    num_cols = root_mat.ncols()
    for i in range(num_cols-1,-1,-1):
        cur_col = root_mat.transpose()[i]
        if cur_col == zero_vector(QQ,num_rows):
            root_mat = root_mat.delete_columns([i])
    # update num_cols
    num_cols = root_mat.ncols()
    is_valid = False
    root_array_vec = root_mat.columns()
    root_array_mat = []
    for col in root_array_vec:
        root_array_mat.append(matrix(col))
    while not is_valid:
        scaling = compute_random_vector(root_array_mat)
        is_valid = is_valid_scaling(root_mat,scaling,kil_cartan_inv)
    pos_roots = []
    for i in range(num_cols):
        cur_col = root_mat.transpose()[i]
        if inner_product(cur_col, scaling, kil_cartan_inv) > 0:
            pos_roots.append(cur_col)
    simple_roots = gen_simple_roots(pos_roots)
    return simple_roots

def simple_root_helper(pos_roots):
    simple_roots = []
    bad_roots = []
    for i in range(len(pos_roots)):
        for j in range(i+1,len(pos_roots)):
            for k in range(j+1,len(pos_roots)):
                if pos_roots[i] + pos_roots[j] == pos_roots[k]:
                    bad_roots.append(k)
                if pos_roots[j] + pos_roots[k] == pos_roots[i]: 
                    bad_roots.append(i)
                if pos_roots[k] + pos_roots[i] == pos_roots[j]: 
                    bad_roots.append(j)
    bad_roots_unique = sorted(list(set(bad_roots)))
    for i in range(len(bad_roots_unique)-1,-1,-1):
        pos_roots.pop(bad_roots_unique[i])
    simple_roots = pos_roots
    return simple_roots

# is_valid_scaling(): checks if scaling vector is valid
# valid condition: After removing zero rows of root matrix, all inner products
# should be nonzero.
# Input: root_mat -- root matrix with rows of zeros removed
#        scaling -- vector to take inner product with
# Output: is_valid -- boolean true if scaling vector is valid
def is_valid_scaling(root_mat,scaling,kil_cartan_inv):
    num_rows = root_mat.nrows()
    num_cols = root_mat.ncols()
    is_valid = True
    for i in range(num_cols):
        cur_col = root_mat.transpose()[i]
        if inner_product(cur_col,scaling,kil_cartan_inv) == 0:
            is_valid = False
            break
    return is_valid

# inner_product(): inner product defined by the Killing form
# Input: x, y -- row vectors 
#        M -- matrix in inner product 
# Output: x * M * y^T
def inner_product(x,y,M):
    result = matrix(x) * M * matrix(y).transpose()
    return result[0,0].real()

# find_cartan_mat(): finds Cartan matrix given a collection of positive
#                    roots
# Input: pos_roots -- positive roots of Cartan subalgebra
# Output: cartan_mat -- Cartan matrix for Lie algebra
def find_cartan_mat(pos_roots,kil_cartan_inv):
    cartan_mat = matrix(RR,len(pos_roots))
    for i in range(len(pos_roots)):
        for j in range(len(pos_roots)):
           entry = float((2 * inner_product(pos_roots[i],pos_roots[j],kil_cartan_inv)))/(inner_product(pos_roots[i],pos_roots[i],kil_cartan_inv))
           cartan_mat[i,j] = entry
    return cartan_mat

# # SL_2 TEST
# sl_2 = sln_generator(2)
# alg_basis = bracket_operation(sl_2[0],sl_2[1])

# SL_3 TEST
# sl_3 = sln_generator(3)
# alg_basis = bracket_operation(sl_3[0],sl_3[1])

# SL_4 TEST
# sl_4 = sln_generator(4)
# alg_basis = bracket_operation(sl_4[0],sl_4[1])

# SO_4 HARDCODE
# A = matrix([[0,1,0,0],[-1,0,0,0],[0,0,0,0],[0,0,0,0]])
# B = matrix([[0,0,1,0],[0,0,0,0],[-1,0,0,0],[0,0,0,0]])
# C = matrix([[0,0,0,1],[0,0,0,0],[0,0,0,0],[-1,0,0,0]])
# D = matrix([[0,0,0,0],[0,0,1,0],[0,-1,0,0],[0,0,0,0]])
# E = matrix([[0,0,0,0],[0,0,0,1],[0,0,0,0],[0,-1,0,0]])
# F = matrix([[0,0,0,0],[0,0,0,0],[0,0,0,1],[0,0,-1,0]])
# alg_basis = [A,B,C,D,E,F]
# cartan_basis = [A,F]


# Test for first block of p+3
mat_list = [ [ [ 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 1, 0, 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 ] ], 
  [ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 2, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 2, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 1, 0, 0, 0, 0, 2, 1, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 1, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 1, 0, 4, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 2 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ], 
      [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ] ]
gen_mat = []
for i in range(len(mat_list)):
    gen_mat.append(matrix(QQ,mat_list[i]))
gen_names = ['E','F']
basis = bracket_operation(gen_mat,gen_names)
ad = adjoint_rep(basis,basis)
kil_mat = killing_form(ad)
det = kil_mat.determinant()
print('determinant of block: %d' % det)

'''
SCRIPT FOR CARTAN

cartan_basis = find_cartan_basis(alg_basis)
comp_basis = complete_basis(alg_basis,cartan_basis)
adj = adjoint_rep(comp_basis,comp_basis)
kil_mat_comp = killing_form(adj)
kil_inv = kil_mat_comp.inverse()
print('kil_mat_comp:')
print(kil_mat_comp)
print('kil_inv:')
print(kil_inv)
root_mat = diag_to_root_mat(cartan_basis,comp_basis)
print('root_mat:')
print(root_mat)
pos_roots = find_pos_roots(root_mat,kil_inv)
print('simple_roots:')
print(pos_roots)
cartan_mat = find_cartan_mat(pos_roots,kil_inv)
print('cartan_mat:')
print(cartan_mat)
'''