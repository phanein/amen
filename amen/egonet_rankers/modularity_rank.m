function [ ranking, scores ] = modularity_rank( A, ~, varargin )
%AMEN_RANK Rank egonets by their conductance
%   Detailed explanation goes here

    % parameters
    parser = inputParser;
    addOptional(parser,'min_degree', 30);
    addOptional(parser,'max_degree', 100);    
    addOptional(parser,'node_filter', []);         

    varargin{:};
    parse(parser, varargin{:});    

    min_degree = parser.Results.min_degree
    max_degree = parser.Results.max_degree
    node_filter = parser.Results.node_filter;    

%     degrees = sum(A,2);
    M = nnz(A)/2;
    
    % select egos to permute
    egos = find(node_filter);

    ego_scores = zeros(1,numel(egos));
    
    degrees = sum(A,1);
%     Q = (1/(2*M))*(A - (degrees'*degrees)/(2*M));
    
    for i=1:numel(egos)    
        ego = egos(i);                        
        [neighbors, ~, ~] = find(A(:,ego));        
        egonet_community = [ego neighbors'];
        
        community_modularity = 0;
        
        for j=1:numel(egonet_community)
           for k=1:numel(egonet_community)
               v1 = egonet_community(j);
               v2 = egonet_community(k);
               
               community_modularity = community_modularity + A(v1,v2) - (degrees(v1)*degrees(v2)/(2*M));
           end
        end        
        
        community_modularity = (1/(2*M))*community_modularity;
        
        ego_scores(i) = community_modularity;        
    end
    
    % sort all egos by score
    % lower modularity worst
    [scores, ind] = sort(ego_scores);
    scores = scores;    
    ranking = egos(ind);
end

