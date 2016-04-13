function [ boundary_nodes_set, boundary_internal, boundary_external, boundary_value ] = circle_boundary_undirected( A, community )
%CIRCLE_BOUNDARY_UNDIRECTED Summary of this function goes here
%   Detailed explanation goes here

sorted_community = sort(unique(community));

[src, dst, value] =  find(A(:, sorted_community));

% boundary_nodes_set=java.util.HashSet(1000);
% 
% boundary_external = java.util.Vector(2000);
% boundary_internal = java.util.Vector(2000);
% boundary_value = java.util.Vector(2000);

% This can be vectorized
% for i=1:numel(src)
%     if ~ismembc(src(i), sorted_community)
%         boundary_nodes_set.add(src(i));
%         
%         boundary_external.add(src(i));
%         boundary_internal.add(dst(i));
%         boundary_value.add(value(i));
%     end
% end

% boundary_external = cell2mat(cell(boundary_external.toArray()));
% boundary_internal = cell2mat(cell(boundary_internal.toArray()));
% boundary_value = cell2mat(cell(boundary_value.toArray()));

non_member_edges = ~ismembc(src, sorted_community);

boundary_external = src(non_member_edges);
boundary_internal = dst(non_member_edges);
boundary_value = value(non_member_edges);

boundary_nodes_set = sort(unique(src(non_member_edges)));

end

