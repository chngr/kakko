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

def lie_dim(lie_type,n):
    # Given lie_type, a character X in {A,B,C,D}, and integer n, return the
    # dimension of the Lie algebra of type X_n.
    if lie_type == "A":
        if n < 1:
            raise ValueError("A_n starts from n = 1.")
        return n * n + 2*n
    elif lie_type == "B":
        if n < 2:
            raise ValueError("B_n starts from n = 2.")
        return 2 * n * n + n
    elif lie_type == "C":
        if n < 3:
            raise ValueError("C_n starts from n = 3.")
        return 2 * n * n + n
    elif lie_type == "D":
        if n < 4:
            raise ValueError("D_n starts from n = 4.")
        return 2 * n * n - n

def lie_sig(lie_type,n):
    # Given lie_type, a character X in {A,B,C,D}, and integer n, return the
    # signature of the Killing form for the Lie algebra of type X_n.
    if lie_type == "A":
        if n < 1:
            raise ValueError("A_n starts from n = 1.")
        return n
    elif lie_type == "B":
        if n < 2:
            raise ValueError("B_n starts from n = 2.")
        return -n
    elif lie_type == "C":
        if n < 3:
            raise ValueError("C_n starts from n = 3.")
        return n//2
    elif lie_type == "D":
        if n < 4:
            raise ValueError("D_n starts from n = 4.")
        return -n
