% sl_2_test(): GAP test for sl_2
% Input: none
% Output: print test file to gap_file directory
function sl_2_test()
% get collection of 6 tuples
six_tuples = gen_6_tuples();
tuple_collection = {};
% generate matrices for all possible tuples
for i = 1:length(six_tuples)
    cur_tuple = six_tuples{i};
    first_part = cur_tuple(1:3);
    second_part = cur_tuple(4:end);
    e = zeros(4);
    f = zeros(4);
    e(2:end,1) = first_part;
    f(1,2:end) = second_part;
    tuple_collection{end+1} = [e,f];
end
sl_2_test_print(tuple_collection,'sl_2_test.txt');
end