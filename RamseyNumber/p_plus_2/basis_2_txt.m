% basis_2_txt(basis)
% Input: basis -- cell array of basis matrices (e.g. E and F)
% Output: writes basis to .txt file
function basis_2_txt(basis, txt_name)
format long
fid = fopen(txt_name,'w');
fprintf(fid,'[');
for i = 1:length(basis) % loop through elements in basis
    if i ~=1
        fprintf(fid,', ');
    end
    fprintf(fid,'[');
    for j = 1: length(basis{i}) % loop through rows of basis
        if j ~= 1
            fprintf(fid, ', ');
        end
        fprintf(fid,'[');
        cur_row = basis{i}(j,:);
        for k = 1: length(cur_row) % loop through each entry in cur_row
            if k ~= 1
                fprintf(fid, ', ');
            end
            fprintf(fid, '%d',cur_row(k));
        end
        fprintf(fid,']');
    end
    fprintf(fid, ']');
end
fprintf(fid,']');
fclose(fid);
end