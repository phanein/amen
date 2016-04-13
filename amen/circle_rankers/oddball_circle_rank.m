function [ ranking, scores ] = oddball_circle_rank( A, X_Total, circles, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here
    
    mkdir('tops');
    mkdir('plots');
    oddball_main('oddball', 0, 'adjacency', A);
    
    n_vs_e = dlmread('tops/oddball_1_2_IDandScoreSorted.txt');                
    
    ranking = n_vs_e(:,1);
    scores = n_vs_e(:,2);       
    
    ego_scores = zeros(1,numel(circles));    
    
    for i=1:numel(circles)          
        community = circles{i};                
        [~, c] = ismember(ranking, community);        
        ego_scores(i) = max(scores(logical(c)));        
    end
    
    % sort all circles by score
    [scores, ind] = sort(ego_scores);
    scores = scores';
    ranking = ind.';
end

