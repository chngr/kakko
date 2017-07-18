% bracket(): Lie bracket operator
% Input: matrices A and B 
% Output: commutator [A, B] = AB - BA
function comm = bracket(A,B)
comm = A*B - B*A;
end