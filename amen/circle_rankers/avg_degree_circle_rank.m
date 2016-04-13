function [ ranking, scores ] = avg_degree_circle_rank( A, X_Total, circles, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    degrees = sum(A,2);    
    ego_scores = zeros(1,numel(circles));    
    
    for i=1:numel(circles)          
        community = circles{i};
                       
        avg_degree = sum(degrees(community)) / numel(community);
        
        ego_scores(i) = avg_degree;        
    end
    
    % sort all circles by score
    [scores, ind] = sort(ego_scores);
    scores = scores';
    ranking = ind.';
end

