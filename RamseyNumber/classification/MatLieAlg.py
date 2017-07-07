from sys import argv

# bracket(): bracket operator
# Input: Sage matrices A and B
# Output: Lie bracket [A,B]
def bracket(A,B):
    return A * B - B * A

# adjoint_rep(): computes adjoint representation matrices of 
# Lie algebra
# Input: basis for rho_{p+r}(a_p) (general)
# Output: list of adjoint representation matrices
def adjoint_rep(basis):
    basis_vec = []
    ad = []
    for b in basis:
        basis_vec.append(b.list())
    basis_matrix = matrix([b for b in basis_vec])
    F = QQ
    dim = len(basis_vec[0])
    vs = (F**dim).span_of_basis(basis_vec) 
    for left in basis:
        mat_list = []
        for right in basis:
            bracket_vec = vector(bracket(left,right).list())
            coords = vs.coordinates(bracket_vec)
            mat_list.append(coords)
        new_mat = matrix(mat_list).transpose()
        ad.append(new_mat)
    return ad

# killing_form(): computes Killing form of Lie algebra
# Input: basis for rho_{p+r}(a_p) (general)
# Output: matrix of Killing form
def killing_form(ad):
    killing_form = matrix([[(general * h).trace() for h in ad] for g in ad])
    return killing_form

# signature(): computes signature of Lie algebra
# Input: killing_mat -- matrix of Killing form
# Output: signature
#         printed: counts for positive, negative, and zero eigenvalues for 
#         matrix of Killing form
def signature(killing_mat)
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

file_name = argv[1];
with open(file_name, 'r') as f:
    data = f.read().replace('\n', '')

mat_list = exec(data)
basis_list = []
for i in range(len(mat_list))
    cur_mat = matrix(mat_list[i])
    basis_list.append(cur_mat)
ad = adjoint_rep(basis_list)
kil = killing_form(ad)
sig = signature(kil)