% tuple_to_matrix(): generates normalized adjacency matrix from given 6-tuple
% Input: tuple [x = 0/1, a, b, c, d, y = 0/1] where
%   x = 0/1 (blue or red K_p in upper left corner)
%   (a,b,c,d) generated in valid_tuples() or mixed_tuples()
%   y = 0/1 is (p+1,p+2)-th entry (red or blue edge between two separate
%       vertices)
% Output: matrix
function result = tuple_to_matrix(tuple)
x = tuple(1); y = tuple(6);
a = tuple(2); b = tuple(3); c = tuple(4); d = tuple(5);
bound_1 = a + b; bound_2 = a + b + c; p = a + b + c + d;
matrix = [];
% set K_p in upper left corner
if x == 0
    matrix = zeros(p+2);
else
    matrix = ones(p+2) - eye(p+2);
end
% set a coordinates: (1,1)
for i = 1:a
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 1;
end
% set b coordinates: (1,0)
for i = (a+1):bound_1
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 0;
end
% set c coordinates: (0,1)
for i = (bound_1+1):bound_2
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 1;
end
% set d coordinates: (0,0)
for i = (bound_2+1):p
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 0;
end
% set y value and make symmetric
matrix(p+1,p+2) = y;
result = triu(matrix) + triu(matrix)';
end