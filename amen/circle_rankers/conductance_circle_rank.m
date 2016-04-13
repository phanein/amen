function [ ranking, scores ] = conductance_circle_rank( A, X_Total, circles, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    ego_scores = zeros(1,numel(circles));    
    
    for i=1:numel(circles)          
        community = circles{i};
                       
        conductance = cutcond(A,community);
        
        ego_scores(i) = conductance;        
    end
    
    % sort all circles by score
    [scores, ind] = sort(ego_scores, 'descend');
    scores = scores';
    ranking = ind.';
end

