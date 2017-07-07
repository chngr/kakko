# bracket_operation(): compute basis from generators
# input: gen_mat: generator matrices
# Output: basis of lie algebra generated
def bracket_operation(gen_mat,gen_names)
	# initialization
	old_list = [] 
	name_old_list = [] 
	new_list = [] 
	for generator in gen_mat:
		new_list.append(generator) 
	# initialize name_new_list
	name_new_list = [] 
	for name in gen_name:
		name_new_list.append(name) 

	# lopp until no new independent elements generated
	while True:
		temp_list = [] 
		name_temp_list = [] 
		# take pairwise brackets for all elements in new_list
		for i in range(len(new_list)-1):
			for j in range(i+1,len(new_list)-1):
				new_entry = bracket(new_list[i],new_list[j]) 
				name_new_entry = name_bracket(name_new_list[i],name_new_list[j]) 

				# if not in span of previous elements
				if !in_span((old_list + new_list + temp_list), new_entry):
					# add new entry
					temp_list.append(new_entry) 
					name_temp_list.append(name_new_entry) 

		# take pairwise brackets of old_list and new_list
		for i in range(len(old_list)-1):
			for j in range(len(new_list)-1):
				new_entry = bracket(old_list[i], new_list[j]) 
				name_new_entry = name_bracket(name_old_list[i], name_new_list[j]) 
				
				# if not in span of previous elements
				if !in_span((old_list + new_list + temp_list), new_entry):
					# add new entry
					temp_list.append(new_entry)
					name_temp_list.append(name_new_entry)

		# update lists for new iteration of loop
		old_list = old_list + new_list
		new_list = temp_list
		name_old_list = name_old_list + name_new_list
		name_new_list = name_temp_list
		# if temp_list is empty, independent basis generated
		if !len(temp_list):
			dim = len(old_list)
			print("number of independent matrices: %d", dim)
			result_basis = old_list

	return result_basis
