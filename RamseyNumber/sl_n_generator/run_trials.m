% run_trials(): run multiple trials of random block generation
% Input: max_value -- max value for random int selection
%        partitions -- array with sizes of partitions
%        num_trials -- number of trials to run
% Output: .txt file in RamseyNumber/gap_files directory with trials to
%         run on GAP
function run_trials(max_val, partitions, num_trials, file_name)
% store block groups
blocks = {};
for i = 1:num_trials
    [E,F] = construct_generator(max_val,partitions);
    fprintf('Trial %d\n', i);
    disp(E)
    disp(F)
    blocks{end+1} = [E,F];
end
% print to GAP
test_print(blocks,file_name);
end