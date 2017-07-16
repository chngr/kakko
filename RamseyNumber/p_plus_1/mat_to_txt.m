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
            fprintf(fid,',\n');
        end
    end
    fprintf(fid,']');
    if i ~= length(mat_set)
        fprintf(fid,',\n\n');
    end
end
fprintf(fid,']');
fclose(fid);
end