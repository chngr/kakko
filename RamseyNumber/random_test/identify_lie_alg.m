% overall_identification(): generate all random generators of size 3 to 15
% use gap for identification for each pair
% output: txt file for cartan matrices
function overall_identification()

end

% write_cmd: write
function write_cmd(mat_set, txt_name)
for i = 3 : 15
    cur_basis = generate_pairs(i); % array of generator pairs
    for j = 1:length(cur_basis)
        
    end
end
end