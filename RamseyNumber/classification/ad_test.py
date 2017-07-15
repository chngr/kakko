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


def bracket(A,B):
    return A * B - B * A

'''
e = matrix([[0,1],[0,0]])
f = matrix(([0,0],[1,0]))
h = bracket(e,f)
basis = [e,f,h]
'''

a = matrix([[0,1,0,0],[-1,0,0,0],[0,0,0,0],[0,0,0,0]])
b = matrix([[0,0,1,0],[0,0,0,0],[-1,0,0,0],[0,0,0,0]])
c = matrix([[0,0,0,1],[0,0,0,0],[0,0,0,0],[-1,0,0,0]])
d = matrix([[0,0,0,0],[0,0,1,0],[0,-1,0,0],[0,0,0,0]])
e = matrix([[0,0,0,0],[0,0,0,1],[0,0,0,0],[0,-1,0,0]])
f = matrix([[0,0,0,0],[0,0,0,0],[0,0,0,1],[0,0,-1,0]])
basis = [a,b,c,d,e,f]

adj_1 = adjoint_rep(basis)
for i in adj_1:
	print(i)
	print('\n')

print('\n')
print('\n')
print('\n')
for i in basis:
	print(adjoint_mat(i,basis))
	print('\n')