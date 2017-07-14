# cartan.py

from math import *
from random import randint

# ----------------------------------
# --------- GENERATE BASIS ---------
# ----------------------------------

# sln_generator(): generates generator matrices and names for sl_n
# Input: n -- dimension of sl_n
# Output: list -- list[0] holds gen_mat, list[1] holds gen_names
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

# adjoint_rep(): computes adjoint representation matrices of 
#                Lie algebra
# Input: basis for Lie algebra 
# Output: list of adjoint representation matrices
def adjoint_rep(basis):
    basis_vec = []
    ad = []
    for b in basis:
        basis_vec.append(b.transpose().list())
    basis_mat = matrix(QQ,basis_vec).transpose()
    for left in basis:
        mat_list = []
        for right in basis:
            bracket_vec = vector(QQ,bracket(left,right).transpose().list())
            coords = basis_mat.solve_right(bracket_vec)
            mat_list.append(coords.list())
        new_mat = matrix(QQ,mat_list).transpose()
        ad.append(new_mat)
    return ad

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
#        adj_group -- group of adjoint rep matrices corresponding to
#        basis elements
# Output: cartan_basis -- basis for Cartan subalgebra
def find_cartan_basis(basis):
    mat_size = basis[0].ncols()
    elem_found = False
    while not elem_found:
        cur_elem = compute_random_element(basis)
        adj = adjoint_mat(cur_elem, basis)
        kernel_col = (adj^(len(basis))).right_kernel().basis()
        mat_group = []
        for kernel_elem in kernel_col:
            mat_elem = matrix(QQ,mat_size)
            for i in range(len(basis)):
                mat_elem = mat_elem + kernel_elem[i] * basis[i]
            mat_group.append(mat_elem)
        if is_abelian(mat_group):
            elem_found = True
    return mat_group

# compute_random_element(): computes random element, inner product of 
#                           basis vectors with scaling
# Input: basis -- basis of Lie algebra
# Output: random element of Lie algebra
def compute_random_element(basis):
    mat_size = basis[0].ncols()
    scaling = [randint(0,100) for p in range(0,len(basis))]
    random_elem = matrix(QQ,mat_size)
    for i in range(len(basis)):
        random_elem = random_elem + scaling[i] * basis[i]
    return random_elem

# is_abelian(): determines whether Lie algebra determined by basis is 
#               abliean
# Input: basis -- basis of Lie algebra
# Output: result -- boolean true if abelian, false otherwise
def is_abelian(basis):
    mat_size = basis[0].ncols()
    is_abelian = True
    for i in range(len(basis)):
        for j in range(i+1,len(basis)):
            if bracket(basis[i],basis[j]) != matrix(QQ,mat_size):
                is_abelian = False
    return is_abelian

# adjoint_mat(): computes adjoint representation matrix for matrix given
#                basis set and basis matrix
# Input: mat -- matrix to compute adj of 
#        basis -- basis for Lie algebra
# Output: result -- adjoint matrix
def adjoint_mat(input_mat,basis):
    basis_vec = []
    col_list = []
    for b in basis:
        basis_vec.append(b.transpose().list())
    basis_mat = matrix(QQ,basis_vec).transpose()
    for elem in basis:
        bracket_vec = vector(QQ,bracket(input_mat,elem).transpose().list())
        coords = basis_mat.solve_right(bracket_vec)
        col_list.append(coords.list())
    adj_mat = matrix(QQ,col_list).transpose()
    return adj_mat

# diag_to_root_mat(): converts basis for Cartan subalgebra into root matrix
# Input: h_basis -- basis for Cartan subalgebra
#        g_basis -- basis for original Lie algebra
#        g_basis_mat -- basis matrix for original Lie algebra
# Output: root_mat -- root matrix of Cartan subalgebra
def diag_to_root_mat(cartan_basis, alg_basis):
    # compute basis matrix for Lie algebra
    basis_vec = []
    for b in alg_basis:
        basis_vec.append(b.transpose().list())
    basis_mat = matrix(QQ,basis_vec).transpose()
    # adjoint representation of H1 on original basis
    ad_H1 = adjoint_mat(cartan_basis[0],alg_basis)
    mat_size = ad_H1.ncols()
    # diagonalize matrix
    D, P = ad_H1.eigenmatrix_right()
    root_mat = matrix(QQ,0,mat_size)
    for i in range(len(cartan_basis)):
        adj_mat = adjoint_mat(cartan_basis[i],alg_basis)
        cur_diag = (P.inverse() * adj_mat * P).diagonal()
        # extract real and imag parts of eigenvalues
        real_diag = []
        imag_diag = []
        for j in range(len(cur_diag)):
            real_diag.append(cur_diag[j].real())
            imag_diag.append(cur_diag[j].imag())
        root_mat = root_mat.stack(vector(real_diag))
        root_mat = root_mat.stack(vector(imag_diag))
    print(root_mat)
    return root_mat

# find_pos_roots(): compute the positive roots
# Input: root_mat -- unprocessed root matrix
# Output: pos_roots -- cell array of positive roots
def find_pos_roots(root_mat):
    num_rows = root_mat.nrows()
    num_cols = root_mat.ncols()
    for i in range(num_cols-1,-1,-1):
        cur_col = root_mat.transpose()[i]
        if cur_col == zero_vector(QQ,num_rows):
            root_mat = root_mat.delete_columns([i])
    # update num_cols
    num_cols = root_mat.ncols()
    is_valid = False
    while not is_valid:
        scaling = vector(QQ,[randint(0,100) for p in range(0,num_rows)])
        is_valid = is_valid_scaling(root_mat,scaling)
    pos_roots = []
    for i in range(num_cols):
        cur_col = root_mat.transpose()[i]
        if cur_col.dot_product(scaling) > 0:
            pos_roots.append(cur_col)
    print(pos_roots)
    return pos_roots


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
    for i in range(num_cols):
        cur_col = root_mat.transpose()[i]
        if cur_col.dot_product(scaling) == 0:
            is_valid = False
            break
    return is_valid


def inner_product(a,b):
    pass

def inverse_killing(kil):    
    pass

# find_cartan_mat(): finds Cartan matrix given a collection of positive
#                    roots
# Input: pos_roots -- positive roots of Cartan subalgebra
# Output: cartan_mat -- Cartan matrix for Lie algebra
def find_cartan_mat(pos_roots):
    cartan_mat = matrix(QQ,len(pos_roots))
    for i in range(len(pos_roots)):
        for j in range(len(pos_roots)):
           entry = float((2 * pos_roots[i].dot_product(pos_roots[j])))/(pos_roots[i].dot_product(pos_roots[i]))
           cartan_mat[i,j] = entry
    return cartan_mat

'''
# SL_2 TEST
sl_2 = sln_generator(2)
alg_basis = bracket_operation(sl_2[0],sl_2[1])
'''

# SL_3 TEST
sl_3 = sln_generator(3)
alg_basis = bracket_operation(sl_3[0],sl_3[1])

adj = adjoint_rep(alg_basis)
kil_mat = killing_form(adj)
print(kil_mat)


cartan_basis = find_cartan_basis(alg_basis)
root_mat = diag_to_root_mat(cartan_basis,alg_basis)
pos_roots = find_pos_roots(root_mat)
cartan_mat = find_cartan_mat(pos_roots)
print(cartan_mat)