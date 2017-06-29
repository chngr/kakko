def partition_with(number,parts,start_idx):
    if number == 0:
        return [[]]
    else :
        result = []
        if start_idx < len(parts):
            if parts[start_idx] <= number:
                new_number = number - parts[start_idx]
                added_part_result = partition_with(new_number,parts,start_idx)
                shifted_idx_result = partition_with(number,parts,start_idx+1)
                result = [[parts[start_idx]] + partition for partition in added_part_result] + shifted_idx_result
            else :
                result = partition_with(number,parts,start_idx+1)
        return result
