# function: rearrange the matrix to block form
# input: matrix (N*n) N: dimension of g, n: dimension of cartan h
# output: rearranged matrix in block form
def rearrange_mat(mat):
	n = mat.ncols()
	range_set = get_range_set(mat)
	block_index_set = get_block_index(range_set,n)
	result_mat = block_to_mat(block_index_set,mat)
	return result_mat
	

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
def get_block_index(pair_arr,n):
	# init index arr as 0 to n-1
	index_arr = []
	for i in range(n):
		index_arr.append(i)
	block_index = []
	while len(index_arr) != 0:
		min_index = find_min_head(index_arr, pair_arr)
		block_index.append(find_block(min_index,pair_arr))
		index_arr = list_diff(index_arr, block_index[len(block_index)-1])
	return block_index


# function find_block: find index array of block containing one column
# input: index of one column
# output: index_set of the block
def find_block(start_index, pair_arr):
	block_index = []
	for i in range(len(pair_arr)):
		if intersect(pair_arr[start_index], pair_arr[i]):
			block_index.append(i)
	return block_index


# function find_min_pair: finds index of column with min head in the column set
# input: pair_arr
# output: index of column with min_head
def find_min_head(index_arr, pair_arr):
	min_index = index_arr[0]
	min_head = pair_arr[min_index][0]
	for i in range(len(index_arr)):
		if pair_arr[index_arr[i]][0] < min_head:
			min_index = index_arr[i]
	return min_index


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
#A = matrix([[0,0,0,1,0],[1,0,0,0,0],[0,0,0,1,1],[0,1,1,0,0],[0,1,0,0,0]])
A = matrix([[1,0,1,0],[0,0,1,0],[0,1,0,0],[0,1,0,1]])
B = rearrange_mat(A)
print(B)



