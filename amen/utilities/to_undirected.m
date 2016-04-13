function [ A_undirected ] = to_undirected( A )
%TO_UNDIRECTED Converts an adjancency matrix to undirected

A_undirected = A + A';
A_undirected(A_undirected > 1) = 1;

end

