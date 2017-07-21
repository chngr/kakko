% print_to_gap(): prints subblocks to gap_file
% Input: block_map -- map from sublocks [E_sub,F_sub] to frequency
%        txt_name -- name of .g file
% Output: .g file with subblocks and Lie algebra generated in 
%         RamseyNumber/gap_files directory
function sl_2_test_print(key_set,file_name)
% find destination directory relatively
cur_dir = cd;
dest_name = fullfile(cur_dir,'..','gap_files',file_name);
% write file
format long
fid = fopen(dest_name,'w');
% for every subblock of E and F
for x = 1:length(key_set)
    x_str = int2str(x);
    cur_mat = key_set{x};
    % get column sizes for e and f (subblocks)
    col_size = size(cur_mat,2)/2;
    e = cur_mat(:,1:col_size);
    f = cur_mat(:,col_size+1:end);
    mat_set = {e,f};
    mat_line = strcat('mat_',x_str,' := ');
    fprintf(fid,mat_line);
    % print out the matrices
    fprintf(fid,'[');
    for i = 1:length(mat_set) % loop through elements in mat_set
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
    lie_line = strcat('L_',x_str,' := LieAlgebra(Rationals, mat_',x_str,');');
    fprintf(fid,lie_line);
    fprintf(fid,'\n\n');
    semi_simp = strcat('S_',x_str,' := SemiSimpleType(L_',x_str,');');
    fprintf(fid,semi_simp);
    fprintf(fid,'\n\n');
    print_line = strcat('PrintTo("*stdout*",S_',x_str,',"\\n");');
    fprintf(fid,print_line);
    fprintf(fid,'\n\n');
end
fclose(fid);
end