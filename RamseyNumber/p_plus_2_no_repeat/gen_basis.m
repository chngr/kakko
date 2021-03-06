% gen_basis(): basis for all unlabelled graphs on (p+2) vertices with 
%              at least one K_p
% Input: p -- dimension of K_p
% Output: map -- from tuple to its representative 
%         basis -- set of unique representative tuples
function [map, basis] = gen_basis(p)
valid_tuples = valid_tuples(p);
mixed_tuples = mixed_tuples(p);
% create map from mixed_tuples
[map, unique_values] = create_map(mixed_tuples,p);
% fill map with valid_tuples
for i = 1:length(valid_tuples)
   map(mat2str(valid_tuples{i})) = valid_tuples{i};
   unique_values{end+1} = valid_tuples{i}; 
end
basis = unique_values;
end

% valid_tuples(): generates set of valid tuples, with exactly one K_p
% Input: p -- dimension of K_p
% Output: result -- cell array of valid tuples
% If R has one K_p^{red}: generate tuples (x,a,b,c,d,y) with
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

% mixed_tuples(): generates set of mixed tuples (some valid, some invalid)
% Input: p -- dimension of K_p
% Output: result -- cell array of mixed tuples
% If R has more than one K_p^{red}: generate tuples (x,a,b,c,d,y) with:
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