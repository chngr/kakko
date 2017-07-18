% name_bracket(): function to compute string names for brackets
% Input: matrix string names 'E' and 'F'
% Output: bracket string '[E,F]'
function result = name_bracket(E,F)
result = strcat('[',E,',',F,']');
end