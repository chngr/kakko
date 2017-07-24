% length_helper(): computes string length over all partitions
% Input: partition -- array of block sizes
% Output: result -- length of string 
function str_length = length_helper(partition)
sum = 0;
for i = 1:length(partition)
    for j = 1:length(partition)
        if j == i-1
            sum = sum + partition(i) * partition(j); 
        end
    end
end
str_length = sum;
end