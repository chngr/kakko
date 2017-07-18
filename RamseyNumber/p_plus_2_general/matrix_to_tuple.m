% matrix_to_tuple(): transform normalized matrix to 6-tuple representation
% Input: matrix in normalized form
% Output: tuple (array) with [x,a,b,c,d,y]
function tuple = matrix_to_tuple(mat)
% size of mat
r = length(matrix);
p = r - 2;
% compute a, b, c, d
a = 0; b = 0; c = 0; d = 0;
for i = 1:p
    first_digit = mat(i,p+1);
    second_digit = mat(i,p+2);
    if(first_digit == 1 && second_digit == 1)
        a = a + 1;
    elseif(first_digit == 1 && second_digit == 0)
        b = b + 1;
    elseif(first_digit == 0 && second_digit == 1)
        c = c + 1;
    elseif(first_digit == 0 && second_digit == 0)
        d = d + 1;
    end
end
% switch b and c, if c > b
if c > b
    [b,c] = deal(c,b);
end
% extract x and y
x = mat(1,2);
y = mat(p+1,p+2);
tuple = [x,a,b,c,d,y];
end