% print_to_gap(): prints subblocks to gap_file
% Input: block_map -- map from sublocks [E_sub,F_sub] to frequency
%        txt_name -- name of .g file
% Output: .g file with subblocks and Lie algebra generated in 
%         RamseyNumber/gap_files directory
function print_to_sage(block_map,file_name)
% find destination directory relatively
cur_dir = cd;
dest_name = fullfile(cur_dir,'..','classification',file_name);
% write file
format long
fid = fopen(dest_name,'w');
key_set = keys(block_map);
fprintf(fid,'[');
% for every subblock of E and F
for x = 1:length(key_set)
    x_str = int2str(x);
    cur_mat = eval(key_set{x});
    % get column sizes for e and f (subblocks)
    col_size = size(cur_mat,2)/2;
    e = cur_mat(:,1:col_size);
    f = cur_mat(:,col_size+1:end);
    mat_set = {e,f};
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
            fprintf(fid,']\n');
            if j ~= length(mat_set{i})
                fprintf(fid,',');
            end
        end
        fprintf(fid,']\n');
        if i ~= length(mat_set)
            fprintf(fid,',');
        end
    end
    fprintf(fid,']\n\n');
    if x ~= length(key_set)
        fprintf(fid,',');
    end
end
fprintf(fid,']');
fclose(fid);
end