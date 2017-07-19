% overall_identification(): generate all random generators of size 3 to 15
% use gap for identification for each pair
% output: txt file for cartan matrices
function identify_lie_alg(size)
basis = generate_pairs(size);
file_name = strcat('test_size_', int2str(size), '.g');
write_cmd(basis, file_name);
end

% write_cmd: write
function write_cmd(mat_set, txt_name)
% find destination directory
cur_dir = cd;
dest_name = fullfile(cur_dir, '..', 'gap_files', txt_name);
format long
fid = fopen(dest_name,'w');
mat_line = strcat('mat_','size_3 := ');
fprintf(fid,mat_line);
fprintf(fid,'[');
for i = 1:length(mat_set) % loop through elements in mat_set
    i_str = int2str(i);
    fprintf(fid,'[');
    for j = 1:length(mat_set{i}) % loop through rows in element
        fprintf(fid,'[');
        cur_row = mat_set{i}(j,:);
        for k = 1:length(cur_row) % loop through entries in rows
            fprintf(fid,'%d',cur_row(k));
            if k ~= length(cur_row)
                fprintf(fid,', ');
            end
        end
        fprintf(fid,']');
        if j ~= length(mat_set{i})
            fprintf(fid,',');
        end
    end
    fprintf(fid,']');
    if i ~= length(mat_set)
        fprintf(fid,',');
    end
end
fprintf(fid,'];');
fprintf(fid,'\n\n');
lie_line = strcat('L_',i_str, ' := LieAlgebra(Rationals, mat_',i_str,'_size_3);');
fprintf(fid,lie_line);
fprintf(fid,'\n\n');
root_line = strcat('R_',i_str,' := RootSystem(L_',i_str,');');
fprintf(fid,root_line);
fprintf(fid,'\n\n');
cartan_line = strcat('C_',i_str,' := CartanMatrix(R_',i_str,');');
fprintf(fid,cartan_line);
fprintf(fid,'\n\n');
print_line = strcat('PrintArray(C_',i_str,');');
fprintf(fid,print_line);
fprintf(fid,'\n\n');
fclose(fid);
end