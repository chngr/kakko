% basis_2_txt(basis)
% input: basis(cell array of basis matrices)
% Writes basis to .txt file

function basis_2_txt(basis)
format long
fid = fopen('basis.txt','w');
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