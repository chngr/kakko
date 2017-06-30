% gen_basis(): basis for all unlabelled graphs on (p+2) vertices with 
% at least one K_p
% Input: dimension of space p
% Output: basis
function result = gen_basis(p)
mat_basis = {};
valid_tuples = valid_tuples(p);
mixed_tuples = mixed_tuples(p);
% convert valid_tuples to matrices, and add to basis
for i = 1:length(valid_tuples)
    mat_basis{end+1} = tuple_to_matrix(valid_tuples{i});
end
% process mixed_tuples
mixed_mat = ind_mixed_tuples(mixed_tuples);
for i = 1:length(mixed_mat)
    mat_basis{end+1} = mixed_mat{i};
end
result = mat_basis;
end

% If R has one K_p^{red} (in general) -- generate tuples (a,b,c,d) with:
%   a + b + c + d = p
%   b >= c
%   a + b <= p - 2
% NOTE: Includes single edge case where a + b = p - 2, which has two
% K_p^{red}, but no duplicates.
% Set of tuples are represented once and do not need more processing.
function result = valid_tuples(p)
valid_tuples = {};
for x = 0:1
    for a = p:-1:0
        for b = (p-a-2):-1:0
            for c = min(p-a-b,b):-1:0
                for y = 0:1
                    valid_tuples{end+1} = [x,a,b,c,p-a-b-c,y];
                end
            end
        end
    end
end
result = valid_tuples;
end

% If R has more than one K_p^{red} -- generate tuples (a,b,c,d) with:
%   a + b + c + d = p
%   b >= c
%   a + b >= p - 1
% NOTE: Set of tuples generated need to be processed further to eliminate 
% duplicates.
function result = mixed_tuples(p)
mixed_tuples = {};
for x = 0:1
    for a = p:-1:0
        for b = (p-a):-1:(p-a-1)
            for c = min(p-a-b,b):-1:0
                for y = 0:1
                    mixed_tuples{end+1} = [x,a,b,c,p-a-b-c,y];
                end
            end
        end
    end
end
result = mixed_tuples;
end

% ind_mixed_tuples(): construct a list of independent tuples in the
% mixed_tuples list
% Input: mixed tuples cell array
% Output: independent matrix cell array
function result = ind_mixed_tuples(mixed_tuples)
mat_list = {};
for i = 1:length(mixed_tuples)
   cur_mat = tuple_to_matrix(mixed_tuples{i});
   permutations = find_permutations(cur_mat);
   for j = 1:length(permutations)
       mat_list{end+1} = normalize_matrix(permutations{j});
   end
end
% take the unique matrices in the list by converting to strings
str_list = unique(cellfun(@mat2str,mat_list,'UniformOutput',false));
mat_list = cellfun(@eval,str_list,'UniformOutput',false);
result = mat_list;
end

% find_permutations(): find permutations of given matrix
% Input: initial matrix to find permutations of
% Output: permutations of initial matrix
function result = find_permutations(init_mat)
p = length(init_mat) - 2;
permutations = {};
for i = (p+2):-1:1
    for j = (p+1):-1:1
        if i ~= p+1
            init_mat(:,[p+2,i]) = init_mat(:,[i,p+2]);
            init_mat([p+2,i],:) = init_mat([i,p+2],:);
            init_mat(:,[p+1,j]) = init_mat(:,[j,p+1]);
            init_mat([p+1,j],:) = init_mat([j,p+1],:);
            permutations{end+1} = init_mat;
        end
    end
end
result = permutations;
end
% try