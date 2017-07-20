# def mat_to_txt(mat_set, name):
#     f = open(name, 'w')
#     f.write('[')
#     for i in range(len(mat_set)): # loop through each element in mat_set
#     	f.write('[')
#     	cur_mat = mat_set[i]
#     	for j in range(cur_mat.nrows()):# loop through rows in matrix
#     		f.write('[')
#     		cur_row = cur_mat[j]
#     		for k in range(len(cur_row)):
#     			f.write(str(cur_row[k]))
#     			if k != len(cur_row) - 1:
#     				f.write(', ')
#     		f.write(']')
#     		if j != cur_mat.nrows() - 1:
#     			f.write(',\n')
#     	f.write(']')
#     	if i != len(mat_set) - 1:
#     		f.write(',\n\n')
#     f.write(']')
#     f.close()

# mat_to_txt(): prints matrix to text file
# Input: mat_set -- set of matrices to print
#        name -- name of text file
# Output: textfile with matrix as string

def mat_to_txt(mat_set, name):
    f = open(name, 'w')
    # loop through each block basis
    for index in range(len(mat_set)):
        index_str = str(index)
        basis_name = "basis_" + index_str
        mat_line = basis_name + " := "
        f.write(mat_line)
        # write for basis of index
        f.write('[')
        cur_block = mat_set[index]
        for i in range(len(cur_block)):
            f.write('[')
            cur_mat = cur_block[i]
            for j in range(cur_mat.nrows()):
                f.write('[')
                cur_row = cur_mat[j]
                for k in range(len(cur_row)):
                    f.write(str(cur_row[k]))
                    if k != len(cur_row) - 1:
                        f.write(',')
                f.write(']')
                if j != cur_mat.nrows() - 1:
                    f.write(',')
            f.write(']')
            if i != len(mat_set) - 1:
                f.write(',')
        f.write('];')
        f.write('\n\n')
        lie_line = 'L_' + index_str + ' := LieAlgebra(Rationals, ' + basis_name + ', "basis");'
        f.write(lie_line)
        f.write('\n\n')
        semi_simp = 'S_' + index_str + ' := SemiSimpleType(L_' + index_str + ');'
        f.write(semi_simp)
        f.write('\n\n')
        print_line = 'PrintTo("*stdout*",S_' + index_str + ',"\\n");'
        f.write(print_line)
        f.write('\n\n')

    f.close()


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

# # script for calculation
# with open('4_plus_1_gen.txt', 'r') as in_file:
#     data = in_file.read().replace('\n', '')
# # read in generator list {E,F}
# gen_list = eval(data)
# mat_list = []
# for i in range(len(gen_list)):
#     mat_list.append(matrix(QQ,gen_list[i]))
# gen_names = ['E','F']
# basis_list = bracket_operation(mat_list,gen_names)
# mat_to_txt(basis_list,'4_plus_1_basis.txt')

from sys import argv

# --- COMPUTATION SCRIPT ---

# INPUT: file with list of blocks 
in_file_name = argv[1]
out_file_name = 'gap_' + argv[1]
with open(in_file_name, 'r') as in_file:
    basis_set_str = in_file.read().replace('\n', '')
# block_list holds sequential E and F blocks (four-level)
block_list = eval(basis_set_str)
# holds set of bases (four-level)
basis_set = []
# loop over blocks of E and F
for i in range(0,len(block_list))
    gen_mat = []
    gen_names = []
    # gen_mat and gen_names for bracket_operation
    gen_mat.append(matrix(QQ,block_list[i][0]))
    gen_mat.append(matrix(QQ,block_list[i][1]))
    gen_names.append('e_' + str(i))
    gen_names.append('f_' + str(i))
    # find basis for each block
    basis_set.append(bracket_operation(gen_mat,gen_names))
# print to output
mat_to_txt(basis,out_file_name)



