function result = gen_6_tuples(max_val)
    result = gen_tuples(max_val,6);
    celldisp(result);
end

function result = gen_tuples(max_val, list_len)
test_list = {};
if list_len > 1
    result = tuple_helper(gen_tuples(max_val,list_len-1), max_val);
else
    for i = 1: max_val
        test_list{end+1} = [i];
    end
    result = test_list;
end
end

function result = tuple_helper(old_list, max_val)
new_list = {};
for k = 1:length(old_list)
    cur_tuple = old_list{k};
    for j = 1: max_val
        new_cur_tuple = [cur_tuple, j];
        new_list{end+1} = new_cur_tuple;
    end
end
result = new_list;
end