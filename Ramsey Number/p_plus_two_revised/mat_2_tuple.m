% mat_2_tuple: transform normalized matrices to 6-tuple representation
% Input: matrix with upper triangular form
% Output:
% result(upper(1/0),a,b,c,d,e)

function tuple = mat_2_tuple (mat)
r = size(mat,1); % size of mat
p = r - 2;
total_num = 4 * nchoosek(p+3,3);
opr = 0; a=0; b=0;c=0 ;d=0; e=0;
opr = mat(1,2);

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
if c > b
    [b,c] = deal(c,b);
end
e = mat(p+1,p+2);
tuple = [opr,a,b,c,d,e];
end