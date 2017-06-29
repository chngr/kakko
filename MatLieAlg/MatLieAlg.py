class MatLieAlgElem:
    # Represents a matrix Lie algebra element.
    #   - size is an integer corresponding to the dimension of matrix;
    #   - mat is a list with size * size elements.
    def __init__(self,size,mat,name=None,base=QQ):
        if len(mat) != size * size:
            raise ValueError("Wrong size matrix for MatLieAlgElem!")
        self.size = size
        self._mat = mat
        self.base = base
        self.name = name

    def vec(self):
        return vector(self._mat,self.base)

    def mat(self):
        return matrix(self.size, self.size, self._mat)

    def __mul__(self,other):
        # This computes the bracket of two MatLieAlgElems.
        # Simply write A * B, where A and B are two MatLieAlgElems.
        if other.size != self.size:
            raise ValueError("Cannot take bracket of two MatLieAlgElems of different sizes!")
        if other.base != self.base:
            raise ValueError("Cannot take bracket of two MatLieALgElems over different bases!")
        A = self.mat()
        B = other.mat()
        C = A * B - B * A
        new_name = None
        if self.name is not None and other.name is not None:
            new_name = "[{A_name},{B_name}]".format(A_name=self.name, B_name=other.name)
        return MatLieAlgElem(
                self.size,
                list(C.numpy().reshape(1,self.size * self.size)[0]),
                name=new_name,
                base=self.base
                )

    def __add__(self,other):
        if other.size != self.size:
            raise ValueError("Cannot add two MatLieAlgElems of different sizes!")
        if other.base != self.base:
            raise ValueError("Cannot add two MatLieALgElems over different bases!")
        A = self.mat()
        B = other.mat()
        C = A + B
        new_name = None
        if self.name is not None and other.name is not None:
            new_name = "{A_name} + {B_name}".format(A_name = self.name, B_name = other.name)
        return MatLieAlgElem(self.size,
                list(C.numpy().reshape(1,self.size * self.size)[0]),
                name = new_name,
                base = self.base)

    def __repr__(self):
        return self.mat().str()

    def __str__(self):
        return self.mat().str()

class MatSpace:
    # Class representing a vector space spanned by matrices
    #   - gens is a list of MatLieAlgElems
    def __init__(self,size,gens,base=QQ):
        self.size = size
        for g in gens:
            if g.size != size:
                raise ValueError("Some generators are not the right size!")
        self.gens = gens
        self.base = base
        self.vector_space = span([g.vec() for g in gens],base)

    def __contains__(self,g):
        # check whether or not a MatLieAlgElem lives in this space
        return g.vec() in self.vector_space

    def basis(self):
       # returns a set of MatLieAlgElems whose vectors form a basis for the space
       B = self.vector_space.basis()
       return [MatLieAlgElem(self.size,list(b),base=self.base) for b in B]

    def dim(self):
        return dim(self.vector_space)

    def space(self):
        return self.vector_space

    def coordinates(self,x):
        return self.vector_space.coordinates(x.vec())

class MatLieAlg:
    # Class representing a matrix Lie algebra.
    #   - the Lie algebra should consist of size-by-size matrices;
    #   - gens is a list of MatLieAlgElems;

    def __init__(self,size,gens,base=QQ):
        self.size = size
        for g in gens:
            if g.size != size:
                raise ValueError("Some generators are not the right size!")
        self.gens = gens
        self.base = base
        self._space = None

    def _generate(self):
        current_space = MatSpace(self.size,self.gens,base=self.base)
        last_dim = 0
        current_dim = current_space.dim()
        while last_dim != current_dim:
            last_dim = current_dim
            current_basis = current_space.basis()
            new_elements = copy(current_basis)
            for i in range(last_dim):
                for j in range(i,last_dim):
                    A = current_basis[i]
                    B = current_basis[j]
                    new_elements.append(A * B)
            current_space = MatSpace(self.size,new_elements,base=self.base)
            current_dim = current_space.dim()
            print("Current dim: {0}".format(current_dim))
        self._space = current_space

    def space(self):
        if self._space is None:
            self._generate()
        return self._space

    def dim(self):
        if self._space is None:
            self._generate()
        return self._space.dim()

    def basis(self):
        if self._space is None:
            self._generate()
        return self._space.basis()

    def adjoint_rep(self):
        # Computes the matrices, with respect to some basis, for the adjoint representation
        B = self.basis()
        ad = []
        for b in B:
            ad_b = matrix([self._space.coordinates(b * a) for a in B]).transpose()
            ad.append(ad_b)
        return B,ad

    def center(self):
        # Compute the center of the Lie algebra, i.e. ker(ad: G -> gl(G))
        _, ad = self.adjoint_rep()
        big_ad = matrix([list(m.numpy().reshape(1,self.dim() * self.dim())[0]) for m in ad])
        T = linear_transformation(self.space().vector_space, self.base^(self.dim() * self.dim()), big_ad)
        return kernel(T)

    def killing_form(self,return_basis=False):
        # Compute the matrix of the Killing form for the Lie algebra
        B, ad = self.adjoint_rep()
        form = matrix([[(g * h).trace() for h in ad] for g in ad])
        if return_basis:
            return form, B
        return form

    def signature(self):
        # Return the signature of the Killing form
        return sum(map(sign,self.killing_form().diagonal()))

def basis_matrix(size,i,j):
    # Returns size-by-size matrix with only a 1 at the entry (i,j)
    return matrix(size,{(i,j): 1})

def matrix_to_list(mat):
    # Returns a list given a sage matrix
    M = mat.numpy()
    return list(M.reshape(1,M.size)[0])

def matrix_to_liealg(mat):
    size = mat.nrows()
    M = matrix_to_list(mat)
    return MatLieAlgElem(size,M)

def make_sl(n,base=QQ):
    # Make sl(n)
    if n < 2:
        raise ValueError("Let's only make special linear groups for n at least 2...")
    generators = []
    for i in range(1,n):
        generators.append(basis_matrix(n,0,0) - basis_matrix(n,i,i))
    for i in range(n):
        for j in range(i+1,n):
            generators.append(basis_matrix(n,i,j))
            generators.append(basis_matrix(n,j,i))
    generators = map(matrix_to_liealg,generators)
    return MatLieAlg(n,generators)

def make_so(n,base=QQ):
    generators = []
    for i in range(n):
        for j in range(i + 1,n):
            generators.append(basis_matrix(n,i,j) - basis_matrix(n,j,i))
    generators = map(matrix_to_liealg,generators)
    return MatLieAlg(n,generators)

def make_sp(n,base=QQ):
    if n % 2 != 0:
        raise ValueError("Symplectic matrices only exist for even-dimensional space")
    generators = []
    m = n/2
    # Off-diagonal blocks
    for i in range(m):
        for j in range(m):
            if i == j:
                generators.append(basis_matrix(n,i,m+j))
                generators.append(basis_matrix(n,i+m,j))
            else:
                generators.append(basis_matrix(n,i,m+j) + basis_matrix(n,j,m+i))
                generators.append(basis_matrix(n,i+m,j) + basis_matrix(n,j+m,i))
    # Diagonal blocks
    for i in range(m):
        for j in range(m):
            generators.append(basis_matrix(n,i,j) - basis_matrix(n,m+j,m+i))
    generators = map(matrix_to_liealg,generators)
    return MatLieAlg(n,generators)

def dim_a(n):
    if n < 1:
        raise ValueError("Dimensions of A_n start from n = 1.")
    return n * n + 2*n

def dim_b(n):
    if n < 2:
        raise ValueError("Dimensions of B_n start from n = 2.")
    return 2 * n * n + n

def dim_c(n):
    if n < 3:
        raise ValueError("Dimensions of C_n start from n = 3.")
    return 2 * n * n + n

def dim_d(n):
    if n < 4:
        raise ValueError("Dimensons of D_n start from n = 4.")
    return 2 * n * n - n

def make_matrix(nrows,ncols,entries):
    # USAGE:
    #   ncols = int
    #   nrows = int
    #   entries = list of integers [(i1,j1),(i2,j2),...] with (row,col)
    mat = [[0 for j in range(ncols)] for i in range(nrows)]
    for i,j in entries:
        mat[i-1][j-1] = 1
    return matrix(mat)
