function [ ranking, scores ] = amen_circle_rank( A, X_Total, circles, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    degrees = sum(A,2);
    M = nnz(A)/2;    
    
    ego_scores = zeros(1,numel(circles));    
    
    for i=1:numel(circles)          
        community = circles{i};
                       
        community_modularity = 0;
        
        for j=1:numel(community)
           for k=1:numel(community)
               v1 = community(j);
               v2 = community(k);
               
               community_modularity = community_modularity + A(v1,v2) - (degrees(v1)*degrees(v2)/(2*M));
           end
        end        
        
        community_modularity = (1/(2*M))*community_modularity;
        
        ego_scores(i) = community_modularity;     
    end
    
    % sort all circles by score
    [scores, ind] = sort(ego_scores);
    scores = scores';
    ranking = ind.';
end

