% identify_lie_subdiag 

function identify_lie_subdiag()
basis = gen_E_F(3,30);
celldisp(basis);
file_name = strcat('test_E_F', '.txt');
write_gap_cmd(basis, file_name);
end

% write_cmd: write
% input: mat_set -- set of generator pairs
% output: txt file of gap commands
function write_gap_cmd(mat_set, txt_name)
% find destination directory
cur_dir = cd;
dest_name = fullfile(cur_dir, '..', 'gap_files', txt_name);
format long
fid = fopen(dest_name,'w');

for x = 1: length(mat_set) % loop through pair elements in mat_set
    size = length(mat_set{x}{1});
    size_str = int2str(size);
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
   % print_line = strcat('PrintTo("*stdout*",S_',index_str,', ";   "',');');
    print_line = strcat('PrintTo("*stdout*",S_',index_str,', "\\n");');
    fprintf(fid,print_line);
    fprintf(fid,'\n\n');
end
fclose(fid);
end



% gen_E_F : generate E's and F's with sub and super diagobal
% input: min and max value of matrix size
% output: array of all possible pairs

function result_basis = gen_E_F(head, tail)
result_basis = {};
for size = head:tail
    new_E = zeros(size);
    new_F = zeros(size);
    for i = 2 : size
        new_E(i,i-1) = 1;
        new_F(i-1,i) = 1;
    end
    result_basis{end+1} = {new_E,new_F};
end
end