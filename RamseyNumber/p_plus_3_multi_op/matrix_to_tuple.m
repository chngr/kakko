% matrix_to_tuple(): transform normalized matrix to 11-tuple representation
% Input: matrix in normalized form
% Output: tuple (array) with [x,a,b,c,d,e,f,g,h,y,z]
% a = 111, b = 110, c = 101, d = 100, e = 011, f = 010, g = 001, h = 000
% x is color of K_p (x = 0/1), y \in {0,1,2,3}, z = 0/1
% a + b + ... + g + h = p
function tuple = matrix_to_tuple(mat)
% size of mat
r = length(mat);
p = r - 3;
% compute a through h
a = 0; b = 0; c = 0; d = 0; e = 0; f = 0; g = 0; h = 0;
for i = 1:p
    if mat(i,p+1) == 1 && mat(i,p+2) == 1 && mat(i,p+3) == 1
        a = a + 1;
    elseif mat(i,p+1) == 1 && mat(i,p+2) == 1 && mat(i,p+3) == 0
        b = b + 1;
    elseif mat(i,p+1) == 1 && mat(i,p+2) == 0 && mat(i,p+3) == 1
        c = c + 1;
    elseif mat(i,p+1) == 1 && mat(i,p+2) == 0 && mat(i,p+3) == 0
        d = d + 1;
    elseif mat(i,p+1) == 0 && mat(i,p+2) == 1 && mat(i,p+3) == 1
        e = e + 1;
    elseif mat(i,p+1) == 0 && mat(i,p+2) == 1 && mat(i,p+3) == 0
        f = f + 1;
    elseif mat(i,p+1) == 0 && mat(i,p+2) == 0 && mat(i,p+3) == 1
        g = g + 1;
    else
        h = h + 1;
    end
end
% extract x
x = mat(1,2);
% compute y
y = 2 * mat(p+1,p+2) + mat(p+1,p+3);
% extract z
z = mat(p+2,p+3);
tuple = [x,a,b,c,d,e,f,g,h,y,z];
end