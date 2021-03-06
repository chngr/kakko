% parse_data(): used to read graph adjacency matrices into Matlab from
%               http://users.cecs.anu.edu.au/~bdm/data/graphs.html
% Input: file_name -- name of file with adjacency matrices
%                     'n_vertices.txt'
%        p -- dimension of K_p
% Output: result -- basis of adjacency matrices representing unlabelled
%                   graphs with a K_p
function result = parse_data(file_name,p)
n = 1; data = []; mat_list = {};
% find file path relatively
cur_dir = cd;
input_file = fullfile(cur_dir,'..','database_graphs',file_name);
fid = fopen(input_file);
% before reaching end of file
while ~feof(fid)
    line = fgetl(fid);
    % add to matrix if has more numbers 
    if any(line)
        data = [data; sscanf(line,'%d')'];
    % move on to next matrix if not
    else
        mat_list{n} = data;
        data = [];
        n = n + 1;
    end
end
if any(data)
    mat_list{n} = data;
end
fclose(fid);
% extract the elements with a K_p
comp_list = parse_comp_data(mat_list,p);
result = comp_list;
end

% parse_comp_data(): returns unique basis with elements having a K_p
% Input: mat_list -- cell array of basis elements
%        p -- dimension of K_p
% Output: result -- basis elements with a K_p
function result = parse_comp_data(mat_list,p)
tuple_list = gen_k_tuples(p+3,p);
comp_list = {};
% for each element in input list
for i = 1:length(mat_list)
    cur_mat = mat_list{i};
    k_p_found = false;
    % for each possible tuple
    for j = 1:length(tuple_list)
        cur_tuple = tuple_list{j};
        % check if has a monochromatic K_p
        sum = 0;
        for k = 1:length(cur_tuple)
            for l = k+1:length(cur_tuple)
                sum = sum + cur_mat(cur_tuple(k),cur_tuple(l));
            end
        end
        if sum == nchoosek(p,2)
            k_p_found = true;
            break;
        end
        if sum == 0
            k_p_found = true;
            break;
        end   
    end
    if k_p_found
        comp_list{end+1} = cur_mat;
    end
end
result = comp_list;
end