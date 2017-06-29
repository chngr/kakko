matE = make_matrix(16,16,[(10,1),(11,2),(12,3),(13,4),(14,5),(15,7),(16,9)])
matCB = make_matrix(16,16,[(2,1),(3,1),(6,2),(6,3),(9,4),(7,5),(11,10),(12,10),(16,13),(15,14)])
matCR = make_matrix(16,16,[(4,1),(5,1),(7,2),(9,3),(8,4),(8,5),(13,10),(14,10),(15,11),(16,12)])

E = matrix_to_liealg(matE)
F = matrix_to_liealg(transpose(matE))
CB = matrix_to_liealg(matCB)
UB = matrix_to_liealg(transpose(matCB))
CR = matrix_to_liealg(matCR)
UR = matrix_to_liealg(transpose(matCR))

gens = [E,F,CB,UB,CR,UR]
G = MatLieAlg(16,gens)



