% gen_basis(): basis for all unlabelled graphs on (p+2) vertices with 
% at least one K_p
% Input: dimension p
% Output: map with basis -- see create_map() function for details
function [map, basis] = gen_basis(p)
valid_tuples = valid_tuples(p);
mixed_tuples = mixed_tuples(p);

[map, unique_values] = create_map(mixed_tuples,p);
disp('Intersections between valid and processed_mixed:')
valid_str = cellfun(@mat2str,valid_tuples,'UniformOutput',false);
unique_str = cellfun(@mat2str,unique_values,'UniformOutput',false);
intersection = intersect(valid_str,unique_str);
intersection = cellfun(@eval,intersection,'UniformOutput',false);
celldisp(intersection);
fprintf('Number of intersections: %d\n', length(intersection));

for i = 1:length(valid_tuples)
   map(mat2str(valid_tuples{i})) = valid_tuples{i};
   unique_values{end+1} = valid_tuples{i}; 
end

key_set = keys(map);
for i = 1:length(key_set)
    for j = 1:length(intersection)
        if isequal(map(key_set{i}),intersection{j})
            disp(key_set{i})
            disp('maps to')
            disp(intersection{j})
            disp('\n')
        end
    end
end

basis = unique_values;

end

% If R has one K_p^{red} (in general) -- generate tuples (x,a,b,c,d,y) with:
%   a + b + c + d = p
%   b >= c
%   a + b <= p - 2 (x = 1)
%   b + d <= p - 2 (x = 0)
% NOTE: Includes single edge case where a + b = p - 2, which has two
% K_p^{red}, but no duplicate tuples.
% Set of tuples are represented once and do not need more processing.
function result = valid_tuples(p)
valid_tuples = {};
% for x = 1
for a = p:-1:0
    for b = (p-a-2):-1:0
        for c = min(p-a-b,b):-1:0
            for y = 0:1
                d = p-a-b-c;
                valid_tuples{end+1} = [1,a,b,c,d,y];
            end
        end
    end
end
% for x = 0
for d = p:-1:0
    for b = (p-d-2):-1:0
        for c = min(p-d-b,b):-1:0
            for y = 0:1
                a = p-d-b-c;
                valid_tuples{end+1} = [0,a,b,c,d,y];
            end
        end
    end
end
result = valid_tuples;
end

% If R has more than one K_p^{red} -- generate tuples (x,a,b,c,d,y) with:
%   a + b + c + d = p
%   b >= c
%   a + b >= p - 1 (x = 1)
%   b + d >= p - 1 (x = 0)
% NOTE: Set of tuples generated need to be processed further to eliminate 
% duplicates.
function result = mixed_tuples(p)
mixed_tuples = {};
% for x = 1
for a = p:-1:0
    for b = (p-a):-1:(p-a-1)
        for c = min(p-a-b,b):-1:0
            for y = 0:1
                d = p-a-b-c;
                mixed_tuples{end+1} = [1,a,b,c,d,y];
            end
        end
    end
end

% for x = 0
for d = p:-1:0
    for b = (p-d):-1:(p-d-1)
        for c = min(p-d-b,b):-1:0
            for y = 0:1
                a = p-d-b-c;
                mixed_tuples{end+1} = [0,a,b,c,d,y];
            end
        end
    end
end
result = mixed_tuples;
end