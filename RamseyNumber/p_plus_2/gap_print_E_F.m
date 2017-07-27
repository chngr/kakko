
% mat_set dim 2 with E and F
function gap_print_E_F (mat_set, txt_name)
index_set = {'1','2'};
% find destination directory relatively
cur_dir = cd;
dest_name = fullfile(cur_dir,'..','classification',txt_name);
% write file
format long
fid = fopen(dest_name,'w');

for i = 1:length(mat_set) % loop through elements in mat_set
    mat_line = strcat('mat_',index_set{i},':= ');
    fprintf(fid,mat_line);
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
    fprintf(fid,'];');
    fprintf(fid,'\n\n');
end
end