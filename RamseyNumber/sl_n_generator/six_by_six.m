function six_by_six(max_value, num_of_blocks)
block_col = {};
for i = 1:num_of_blocks
    e_sub = zeros(6);
    f_sub = zeros(6);
    
    e_sub(3,1) = randi(max_value);
    e_sub(3,2) = randi(max_value);
    e_sub(4,2) = randi(max_value);
    e_sub(5,4) = randi(max_value);
    e_sub(6,3) = randi(max_value);
    
    f_sub(1,3) = randi(max_value);
    f_sub(2,3) = randi(max_value);
    f_sub(2,4) = randi(max_value);
    f_sub(3,6) = randi(max_value);
    f_sub(4,5) = randi(max_value);
    
    disp(e_sub);
    disp(f_sub);
    block_col{end+1} = [e_sub,f_sub];
end
test_print(block_col,'six_by_six.txt');
end