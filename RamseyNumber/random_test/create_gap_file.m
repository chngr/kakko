function create_gap_file()
basis = generate_pairs(3);
write_gap_file(basis, 'test_file.txt');
end

function write_gap_file(generator_basis,txt_name)

% find destination directory
cur_dir = cd;
dest_name = fullfile(cur_dir, '..', 'gap_files', txt_name);
format long
fid = fopen(dest_name,'w');
mat_line = strcat('mat_',index_str,'_size_3 := ');
fprintf(fid,mat_line);
fprintf(fid,'[');
for i = 1:length(generator_basis)
    index_str = int2str(i);
    for j = 1:length(mat_set) % loop through elements in mat_set
        fprintf(fid,'[');
        for k = 1:length(mat_set{i}) % loop through rows in element
            fprintf(fid,'[');
            cur_row = mat_set{i}(j,:);
            for l = 1:length(cur_row) % loop through entries in rows
                fprintf(fid,'%d',cur_row(k));
                if l ~= length(cur_row)
                    fprintf(fid,', ');
                end
            end
            fprintf(fid,']');
            if k ~= length(mat_set{i})
                fprintf(fid,',');
            end
        end
        fprintf(fid,']');
        if j ~= length(mat_set)
            fprintf(fid,',');
        end
    end
    fprintf(fid,'];');
    fprintf(fid,'\n\n');
    lie_line = strcat('L_',index_str,' := LieAlgebra(Rationals, mat_',index_str,'_size_3);');
    fprintf(fid,lie_line);
    fprintf(fid,'\n\n');
    root_line = strcat('R_',index_str,' := RootSystem(L_',index_str,');');
    fprintf(fid,root_line);
    fprintf(fid,'\n\n');
    cartan_line = strcat('C_',index_str,' := CartanMatrix(R_',index_str,');');
    fprintf(fid,cartan_line);
    fprintf(fid,'\n\n');
end
fclose(fid);
end