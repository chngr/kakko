% ramsey_eigen_time(): estimates flop count for ramsey_eigen() function
% Input: dimension r, number of selected vertices k 
% Output: estimate of flop count 
function result = ramsey_eigen_time(r,k)
result = nchoosek(r,k) * nchoosek(k,2) * 2 * 2^(nchoosek(r,2));
end