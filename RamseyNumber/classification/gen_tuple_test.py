def get_tuples(max_val, list_len):
    test_list = []
    if list_len > 1:
        return tuple_helper(get_tuples(max_val,list_len-1),max_val)
    else:
        for i in range(max_val+1):
            test_list.append([i])
        return test_list

# tuple_helper(): helper function to perform recursion
# Input: old list and max value
# Output: list of tuples with (length + 1) with everything up to max value
def tuple_helper(old_list, max_val):
    new_list = []
    for i in range(len(old_list)):
        cur_tuple = old_list[i]
        for j in range(max_val+1):
            new_cur_tuple = []
            new_cur_tuple = cur_tuple + [j]
            new_list.append(new_cur_tuple)
    return new_list


print(get_tuples(3,6))