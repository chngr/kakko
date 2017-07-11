from math import *

# CLASSIFY.PY

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
    for generator in gen_mat:
        new_list.append(generator) 
    # initialize name_new_list
    name_new_list = [] 
    for name in gen_names:
        name_new_list.append(name) 

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
        print("Number of basis vectors: %d"%len(old_list))
        # if temp_list is empty, independent basis generated
        if len(temp_list) == 0:
            dim = len(old_list)
            print("Number of independent matrices: %d" % dim)
            result_basis = old_list
            return result_basis

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
# Lie algebra
# Input: basis for rho_{p+r}(a_p) (general)
# Output: list of adjoint representation matrices
def adjoint_rep(basis):
    basis_vec = []
    ad = []
    for b in basis:
        basis_vec.append(b.list())
    vs = span(matrix(basis_vec),QQ)
    print("Our vector space looks like this!")
    print(vs)
    for left in basis:
        mat_list = []
        for right in basis:
            bracket_vec = vector(QQ,bracket(left,right).list())
            coords = vs.coordinates(bracket_vec)
            mat_list.append(coords)
        new_mat = matrix(QQ,mat_list).transpose()
        ad.append(new_mat)
    return ad

# killing_form(): computes Killing form of Lie algebra
# Input: basis for rho_{p+r}(a_p) (general)
# Output: matrix of Killing form
def killing_form(ad):
    killing_form = matrix(QQ,[[(g * h).trace() for h in ad] for g in ad])
    print(killing_form)
    return killing_form

# signature(): computes signature of Lie algebra
# Input: killing_mat -- matrix of Killing form
# Output: signature
#         printed: counts for positive, negative, and zero eigenvalues for 
#         matrix of Killing form
def signature(killing_mat):
    eig_vec = killing_mat.jordan_form().diagonal()
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

# center(): computes center of Lie algebra
# Input: adjoint representation matrices
# Output: center vector space
def center(adj):
    big_ad_col = []
    for i in range(len(adj))
        cur_mat = adj[i]
        big_ad_col.append(cur_mat.transpose.list())
    return big_ad.kernel().dim() 

# classify_alg(): classifies Lie algebra given dim and sig
# Input: dimension and signature
# Output: list of candidates for Lie algebra
def classify_alg(dim, sig):
    solution_list = []
    dim_list = []
    sig_list = []
    excep_dim = [14,56,78,133,248]
    max_len = floor((1 + sqrt(1+8*dim))/2)
    list_len = 3*max_len + 5
    tuple_list = get_tuples(dim,list_len)
    # for sl_n
    for i in range(max_len):
        # start from 2
        sig_list[i] = i+2
        dim_list[i] = (i+2)**2 - 1
    # for so_n
    for i in range(max_len):
        # start from 3
        sig_list[max_len+i] = -(i+3)
        dim_list[max_len+i] = (i+3)*(i+3-1)/2
    # for sp_{2n}
    for i in range(max_len):
        # start from 3
        sig_list[2*max_len+i] = i
        dim_list[2*max_len+i] = 2*(i+3)*(i+3)+i
    sig_list = sig_list + 
    dim_list = dim_list + excep_dim
    for k in range(len(tuple_list)):
        cur_dim = sum([i*j for (i,j) in zip(tuple_list, dim_list)])
        cur_sig = sum([i*j for (i,j) in zip(tuple_list, sig_list)])
        if cur_dim == dim and cur_sig == sig:
            solution_list.append(tuple_list[k])
    return solution_list

# gen_tuples(): generates list of frequency tuples recursively
# Input: dimension and length of list 
# Output: list of frequency tuples
def get_tuples(dim, list_len):
    max_val = floor(dim/3)
    test_list = []
    if list_len > 1:
        result_list = tuple_helper(get_tuples(max_val,list_len-1),max_val)
    else:
        for i in range(max_val+1):
            test_list[i] = [i]
        result_list = test_list
        return result_list

# tuple_helper(): helper function to perform recursion
# Input: old list and max value
# Output: list of tuples 
def tuple_helper(old_list, max_val):
    new_list = []
    for i in range(len(old_list)):
        cur_tuple = old_list[i]
        for j in range(max_val+1):
            new_cur_tuple = cur_tuple.append(j)
            new_list.append(new_cur_tuple)
            return new_list

# MAIN SCRIPT

# read in text file
file_name = "basis.txt"
with open(file_name, 'r') as f:
    data = f.read().replace('\n', '')
# read in generator list {E,F}
gen_list = eval(data)
mat_list = [];
for i in range(len(gen_list)):
    mat_list.append(matrix(QQ,gen_list[i]))
gen_names = ['E','F']
basis_list = bracket_operation(mat_list,gen_names)
# check what commutes
for i in range(len(basis_list)):
    if bracket(E,basis_list[i]) == matrix(E.ncols()) and \
    bracket(F,basis_list[i]) == matrix(F.ncols()):
        print(basis_list[i])
print('Reached -- above values are those that commute with E and F')
# compute adjoint rep, Killing form, and signature
ad = adjoint_rep(basis_list)
kil = killing_form(ad)
eig_vec = signature(kil)
print(eig_vec)