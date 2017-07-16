% mat_to_txt(): writes collection of matrices to text file
% Input: mat_set -- cell array of matrices
% Output: .txt file with mat_set printed
%         saved in kakko/RamseyNumber/classification directory
% NOTE: Printed in Python-friendly syntax for use with eval() function. 
function mat_to_txt(mat_set,txt_name)
% find destination directory relatively
cur_dir = cd;
dest_name = fullfile(cur_dir,'..','classification',txt_name);
% write file
format long
fid = fopen(dest_name,'w');
fprintf(fid,'[');
for i = 1:length(mat_set) % loop through elements in mat_set
    if i ~= 1
        fprintf(fid,', ');
    end
    fprintf(fid,'[');
    for j = 1:length(mat_set{i}) % loop through rows in element
        if j ~= 1
            fprintf(fid, ', ');
        end
        fprintf(fid,'[');
        cur_row = mat_set{i}(j,:);
        for k = 1:length(cur_row) % loop through entries in rows
            if k ~= 1
                fprintf(fid, ', ');
            end
            fprintf(fid,'%d',cur_row(k));
        end
        fprintf(fid,']');
    end
    fprintf(fid, ']');
end
fprintf(fid,']');
fclose(fid);
end