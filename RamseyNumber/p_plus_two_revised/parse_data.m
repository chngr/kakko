function result = parse_data(input_file, p)

n = 1; data = []; mat_list = {};
fid = fopen(input_file);
while ~feof(fid)
    line = fgetl(fid);
    if any(line)
        data = [data; sscanf(line,'%d')'];
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

tuple_list = gen_k_tuples(p+2,p);
complete_list = {};
for i = 1:length(mat_list)
    cur_mat = mat_list{i};
    k_p_found = false;
    for j = 1:length(tuple_list);
        cur_tuple = tuple_list{j};
        sum = 0;
        for k = 1:length(cur_tuple)
            for l = (k+1):length(cur_tuple)
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
        complete_list{end+1} = cur_mat;
    end
end
celldisp(complete_list)
end