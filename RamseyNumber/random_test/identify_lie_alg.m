% overall_identification(): generate all random generators of size 3 to 15
% use gap for identification for each pair
% output: txt file for cartan matrices
function identify_lie_alg(size)
basis = generate_pairs(size);
celldisp(basis);
file_name = strcat('test_size_', int2str(size), '.txt');
write_cmd(basis, file_name, size);
end

% write_cmd: write
% input: mat_set -- set of generator pairs
% output: txt file of gap commands
function write_cmd(mat_set, txt_name, size)
% find destination directory
size_str = int2str(size);
cur_dir = cd;
dest_name = fullfile(cur_dir, '..', 'gap_files', txt_name);
format long
fid = fopen(dest_name,'w');

for x = 1: length(mat_set) % loop through pair elements in mat_set
    index_str = int2str(x);
    mat_line = strcat('mat_',index_str,'_size_',size_str,' := ');
    fprintf(fid,mat_line);
    fprintf(fid, '[');
    cur_pair = mat_set{x};
    for i = 1: length(cur_pair) % loop through each matrix in pair
        fprintf(fid,'[');
        cur_mat = cur_pair{i};
        for j = 1:length(cur_mat) % loop through rows in element
            fprintf(fid,'[');
            cur_row = cur_mat(j,:);
            for k = 1:length(cur_row) % loop through entries in rows
                fprintf(fid,'%d',cur_row(k));
                if k ~= length(cur_row)
                    fprintf(fid,', ');
                end
            end
            fprintf(fid,']');
            if j ~= length(cur_mat)
                fprintf(fid,',');
            end
        end
        
        fprintf(fid,']');
        if i ~= length(cur_pair)
            fprintf(fid,',');
        end
    end

    fprintf(fid,'];');
    fprintf(fid,'\n\n');
    % execute GAP for each pair
    lie_line = strcat('L_',index_str, ' := LieAlgebra(Rationals, mat_',index_str,'_size_',size_str,');');
    fprintf(fid,lie_line);
    fprintf(fid,'\n\n');
    semi_simp = strcat('S_',index_str,' := SemiSimpleType(L_',index_str,');');
    fprintf(fid,semi_simp);
    fprintf(fid,'\n\n');
    print_line = strcat('PrintTo("*stdout*",S_',index_str,');');
    fprintf(fid,print_line);
    fprintf(fid,'\n\n');
end
fclose(fid);
end
