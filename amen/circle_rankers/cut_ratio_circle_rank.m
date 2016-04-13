function [ ranking, scores ] = cut_ratio_circle_rank( A, X_Total, circles, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    nodes = size(A,1);
    ego_scores = zeros(1,numel(circles));    
    
    for i=1:numel(circles)          
        community = circles{i};
        
        [boundary_nodes, B_internal, B_external, B_value] = circle_boundary_undirected(A, community);
        
%         cut_ratio = numel(B_internal) / (numel(community) *(nodes - numel(community)));
        
        if (nodes - numel(egonet_community)) ~= 0
            cut_ratio = numel(B_internal) / (numel(egonet_community) *(nodes - numel(egonet_community)));
        else
            % this should only happen if "cut" is the entire graph, so no
            % boundary (0/0)
            cut_ratio = 0;
        end
        
        ego_scores(i) = cut_ratio;        
    end
    
    % sort all circles by score
    [scores, ind] = sort(ego_scores, 'descend');
    scores = scores';
    ranking = ind.';
end

