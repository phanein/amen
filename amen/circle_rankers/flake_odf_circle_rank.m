function [ ranking, scores ] = flake_odf_circle_rank( A, X_Total, circles, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    degrees = sum(A,2);
    nodes = size(A,1);
    ego_scores = zeros(1,numel(circles));    
        
    for i=1:numel(circles)          
        community = circles{i};        
        sorted_community = sort(unique(community));
        
        % assumes undirected
        internal_degree = zeros(size(sorted_community));
        
        for j=1:numel(sorted_community)            
            node = sorted_community(j);
            
            [src, dst, value] =  find(A(:, node));            
            member_edges = ismembc(src, sorted_community);            
            
            internal_degree(j) = numel(src(member_edges));            
        end
        
        numerator = internal_degree.' < (degrees(sorted_community)/2);        
        
        flak_odf = sum(numerator) / numel(community);
        
        ego_scores(i) = flak_odf;        
    end
    
    % sort all circles by score
    [scores, ind] = sort(ego_scores, 'descend');
    scores = scores';
    ranking = ind.';
end

