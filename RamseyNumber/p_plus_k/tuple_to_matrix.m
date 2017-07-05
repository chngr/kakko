% tuple_to_matrix(): generates normalized adjacency matrix from given 11-tuple
% Input: tuple [x = 0/1, a, b, c, d, e, f, g, h, y{0-3}, z{0,1}] where
%   x = 0/1 (blue or red K_p in upper left corner)
%   (x,a,b,c,d,e,f,g,h,y,z) generated in valid_tuples() or mixed_tuples()
%   y = 0/1 is (p+1,p+2)-th entry (red or blue edge between two separate
%       vertices)
% Output: matrix of tuple
function result = tuple_to_matrix(tuple)
x = tuple(1); y = tuple(10); z = tuple(11);
a = tuple(2); b = tuple(3); c = tuple(4); d = tuple(5); 
e = tuple(6); f = tuple(7); g = tuple(8); h = tuple(9);
p = a + b + c + d + e + f + g + h;
bound_1 = a + b; bound_2 = bound_1 + c; bound_3 = bound_2 + d; 
bound_4 = bound_3 + e; bound_5 = bound_4 + f; bound_6 = bound_5 + g;
% set K_p in upper left corner
if x == 0
    matrix = zeros(p+3);
else
    matrix = ones(p+3) - eye(p+3);
end
% set a coordinates: (1,1,1)
for i = 1:a
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 1;
    matrix(i,p+3) = 1;
end
% set b coordinates: (1,1,0)
for i = (a+1):bound_1
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 1;
    matrix(i,p+3) = 0;
end
% set c coordinates: (1,0,1)
for i = (bound_1+1):bound_2
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 0;
    matrix(i,p+3) = 1;
end
% set d coordinates: (1,0,0)
for i = (bound_2+1):bound_3
    matrix(i,p+1) = 1;
    matrix(i,p+2) = 0;
    matrix(i,p+3) = 0;
end
% set e coordinates: (0,1,1)
for i = (bound_3+1):bound_4
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 1;
    matrix(i,p+3) = 1;
end
% set f coordinates: (0,1,0)
for i = (bound_4+1):bound_5
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 1;
    matrix(i,p+3) = 0;
end
% set g coordinates: (0,0,1)
for i = (bound_5+1):bound_6
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 0;
    matrix(i,p+3) = 1;
end
% set h coordinates: (0,0,0)
for i = (bound_6+1):p
    matrix(i,p+1) = 0;
    matrix(i,p+2) = 0;
    matrix(i,p+3) = 0;
end
% set y,z value and make symmetric
matrix(p+2,p+3) = mod(y,2);
if y > 1
    matrix(p+1,p+2) = 1;
else
    matrix(p+1,p+2) = 0;
end
matrix(p+2,p+3) = z;
result = triu(matrix) + triu(matrix)';
end