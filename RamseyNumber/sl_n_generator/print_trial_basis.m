% print_trial_basis: print out some trial basis
% input: result_set (from all_trials.m), index of generator
% output: print out bracket operations
function print_trial_basis(test_set, index,partition)
trial_generator = test_set{index};
[dim,result_basis] = bracket_operation(trial_generator, {'E','F'});
celldisp(result_basis);
str_length = length_helper(partition);
all_bin = gen_bin_str(str_length);
cur_binary = all_bin{index};
fprintf("hypothesis dimension:\n")
test_dim = get_test_dim(cur_binary,partition(1),partition(2));
disp(test_dim);
end
