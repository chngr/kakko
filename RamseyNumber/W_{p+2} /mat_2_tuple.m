% mat_2_tuple: transform normalized matrices to 6-tuple representation
% Input: matrix with upper triangular form
% Output:
% result(opr(1/0),a,b,c,d,e)

function [tuple,index] = mat_2_tuple (mat)
r = size(mat,1); % size of mat
p = r - 2;
index_in_basis = 0;
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
e = mat(p+1,p+2);
tuple = [opr,a,b,c,d,e];
count = 1;
for a_1 = p:-1:0
    for b_1 = (p-a_1):-1:0
        for c_1 = (p-a_1-b_1):-1:0
            if(a == a_1 && b == b_1 && c == c_1)
                index_in_basis = count;
                break;
            else
                count = count + 1;
            end
        end
    end
end

if(opr == 1)
    index = index_in_basis * 2 - 1;
elseif(opr == 0)
    index = index_in_basis * 2;
end
if(e == 1)
    index = index + (total_num/2);
end
end