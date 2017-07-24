function eight_by_eight(max_value, num_of_blocks)
block_col = {};
for i = 1:num_of_blocks
    e_sub = zeros(8);
    f_sub = zeros(8);
    
    e_sub(1,3) = randi(max_value);
    e_sub(1,4) = randi(max_value);
    e_sub(2,3) = randi(max_value);
    e_sub(2,5) = randi(max_value);
    e_sub(3,7) = randi(max_value);
    e_sub(4,6) = randi(max_value);
    e_sub(5,6) = randi(max_value);
    e_sub(5,7) = randi(max_value);
    e_sub(5,8) = randi(max_value);
    
    f_sub(3,1) = randi(max_value);
    f_sub(4,1) = randi(max_value);
    f_sub(3,2) = randi(max_value);
    f_sub(5,2) = randi(max_value);
    f_sub(7,3) = randi(max_value);
    f_sub(6,4) = randi(max_value);
    f_sub(6,5) = randi(max_value);
    f_sub(7,5) = randi(max_value);
    f_sub(8,5) = randi(max_value);
    
    disp(e_sub);
    disp(f_sub);
    block_col{end+1} = [e_sub,f_sub];
end
sl_2_test_print(block_col,'eight_by_eight.txt');
end
