# irrep.py

from random import randint

# compute_random_element(): computes random matrix element, random linear
#                           combination of basis vectors
# Input: basis -- basis of Lie algebra
# Output: random_elem -- random element of Lie algebra
def compute_random_element(basis):
    mat_size = basis[0].ncols()
    scaling = [randint(1,100) for p in range(0,len(basis))]
    random_elem = matrix(QQ,mat_size)
    for i in range(len(basis)):
        random_elem = random_elem + scaling[i] * basis[i]
    return random_elem

# simultaneous_diag(): simultaneously diagonalizes a commuting set of vectors
# Input: cartan_basis -- basis for Cartan subalgebra
# Output: P -- matrix P of P^{-1}AP that simultaneously diagonalizes
def simultaneous_diag(cartan_basis):
    valid_elem = False
    # find element that diagonalizes the Cartan basis
    while not valid_elem:
        # compute a random element of the Cartan subalgebra
        cartan_elem = compute_random_element(cartan_basis)
        # diagonalize random element
        D, P = cartan_elem.eigenmatrix_right()
        # assume the diagonalization works
        valid_elem = True
        # check if diagonalizes all elements
        for elem in cartan_basis:
            cur_diag_mat = P.inverse() * elem * P
            # check if each element is diagonalized
            if not is_diagonal(cur_diag_mat):
                valid_elem = False
                break
    return P

L = gap.LieAlgebra('Rationals', gens)
C = gap.CartanSubalgebra(L)
cartan_basis = gap.BasisVectors(gap.Basis(C))



