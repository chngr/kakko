% ramsey_eigen_time(): estimates flop count for ramsey_eigen_k_tuples() 
%                      function
% Input: r -- number of vertices
%        k -- number of selected vertices
% Output: result -- estimate of flop count
function result = ramsey_eigen_time(r,k)
result = nchoosek(r,k) * nchoosek(k,2) * 2 * 2^(nchoosek(r,2));
end