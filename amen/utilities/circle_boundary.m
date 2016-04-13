function [ boundary_nodes, boundary ] = circle_boundary( A, community )
%BOUNDARY Summary of this function goes here
%   Detailed explanation goes here

    B = A;
    B(community, community) = 0;
    B = B(community, :) + B(:, community)';  % normalize this if entries become important                    
    [xb, yb, zb] = find(B);
    boundary_nodes = unique(yb);
    boundary = B;    
end

