% all_trials(): given partition, constructs all matrices with 0,1-blocks
%               on super- and subdiagonal
% Input: partition -- array of ints with partition 
%        file_name -- GAP file name
% Output: outputs GAP file
function all_trials(partition,file_name)
% compute string length of partitions
str_length = length_helper(partitions);
str_array = gen_bin_str(str_length);

end