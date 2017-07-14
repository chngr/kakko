# function: rearrange the matrix to block form
# input: matrix (N*n) N: dimension of g, n: dimension of cartan h
# output: rearranged matrix in block form
def rearrange_mat(mat):
	n = mat.ncols()
	range_set = get_range_set(mat)
	block_index_set = get_block_index(range_set,n)
	result_mat = block_to_mat(block_index_set,mat)
	print("rearranged matrix:")
	print(result_mat)
	print("result blocks are")
	print_blocks(result_mat, block_index_set, range_set)
	return result_mat


# function: print_blocks() -- print each block after rearrangement
# input: mat -- rearranged matrix; block_index
# output: array of each block matrix
#		  print error message if some block is not square matrix
def print_blocks(mat, block_index, range_set):
	blocks = [] # store each block matrix
	# check each block is square
	block_head = 0
	for i in range(len(block_index)): # check ith block
		cur_block_index = block_index[i]
		cols_in_block = len(cur_block_index)
		block_tail = block_head + cols_in_block
		# check each block is squre: max_tail - min_head <= num_cols in block
		min_index, min_head = find_min_head(cur_block_index, range_set)
		tail_of_block = range_set[cur_block_index[0]][1] 
		for j in range(cols_in_block):
			cur_tail = range_set[cur_block_index[j]][1]
			if cur_tail > tail_of_block:
				tail_of_block = cur_tail
		block_range = tail_of_block - min_head
		if block_range > cols_in_block:
			print("ERR: block not square!!!")
			return 
		
		# store new block in arr of blocks
		new_block_mat = matrix(cols_in_block)
		for p in range(cols_in_block):
			for q in range(cols_in_block):
				new_block_mat[p,q] = mat[block_head+p][block_head+q]
		blocks.append(new_block_mat)
		# update head of block
		block_head = block_head + block_range
		print("block # " + str(i))
		print(new_block_mat)
	return blocks



# function: range_set -- get range set for all columns
# input: mat
# output: range set of all columns
def get_range_set(mat):
	range_set = []
	head_flag = False
	head = 0
	tail = 0
	for i in range(mat.ncols()):
		cur_col = mat.transpose()[i]
		head = 0
		tail = 0
		head_flag = False
		for j in range(len(cur_col)):
			if cur_col[j] != 0 and head_flag == False:
				head_flag = True
				head = j
				tail = j
			if cur_col[j] != 0 and head_flag == True:
				tail = j
		range_set.append([head,tail])
	return range_set


# function: get_block_index -- partition columns into block groups
# input: cell array of range-pairs(i.e the range of non-zero entries in each column)
#        n: size of matrix
# output: cell array of the indice tuples of columns in each block
def get_block_index(range_set,n):
	# init index arr as 0 to n-1
	index_arr = []
	for i in range(n):
		index_arr.append(i)
	block_index = []
	while len(index_arr) != 0:
		min_index, min_head = find_min_head(index_arr, range_set)
		block_index.append(find_block(min_index,range_set))
		index_arr = list_diff(index_arr, block_index[len(block_index)-1])
	return block_index


# function find_block: find index array of block containing one column
# input: index of one column
# output: index_set of the block
def find_block(start_index, range_set):
	block_index = []
	for i in range(len(range_set)):
		if intersect(range_set[start_index], range_set[i]):
			block_index.append(i)
	return block_index


# function find_min_head: finds index of column with min head in the column set
# input: range_set
# output: index of column with min_head
def find_min_head(index_arr, range_set):
	min_index = index_arr[0]
	min_head = range_set[min_index][0]
	for i in range(len(index_arr)):
		if range_set[index_arr[i]][0] < min_head:
			min_index = index_arr[i]
	return min_index, min_head


# function: block_to_mat -- block index set to result matrix
# input: block_index: index array of each block
# output: result matrix
def block_to_mat(block_index,mat):
	result_mat = []
	for i in range(len(block_index)):
		cur_block = block_index[i]
		for j in range(len(cur_block)):
			cur_col = mat.transpose()[cur_block[j]]
			result_mat.append(cur_col) # append column in block to result matrix as row
	return matrix(result_mat).transpose() # transpose 



# function: intersect(A,B) -- check if ranges A B have intersection
# input: A, B
# output: boolean if they intersect
def intersect(A,B):
	result = True
	if A[0] > B[1] or A[1] < B[0]:
		result = False
	return result
 
 # subfunction for taking difference of two lists
 # input: two lists
 # output: difference of two lists 
def list_diff(first, second):
 	second = set(second)
 	diff = [item for item in first if item not in second]
 	return diff


# testing cases
A = matrix([[0,0,0,1,0],[1,0,0,0,0],[0,0,0,1,1],[0,1,1,0,0],[0,1,0,0,0]])
#A = matrix([[0,1,0,0,0],[1,0,0,0,0],[0,1,1,0,0],[0,1,1,0,0],[0,0,0,1,0]])
#A = matrix([[1,0,1,0],[0,0,1,0],[0,1,0,0],[0,1,0,1]])
B = rearrange_mat(A)




