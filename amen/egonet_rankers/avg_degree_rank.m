function [ ranking, scores ] = avg_degree_rank( A, ~, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    % parameters
    parser = inputParser;
    addOptional(parser,'min_degree', 30);
    addOptional(parser,'max_degree', 100);    
    addOptional(parser,'node_filter', []);     
    
    parse(parser, varargin{:});    

    min_degree = parser.Results.min_degree
    max_degree = parser.Results.max_degree
    node_filter = parser.Results.node_filter;    


    degrees = sum(A,2);
    M = nnz(A)/2;
    
    % select egos to permute
    egos = find(node_filter);

    ego_scores = zeros(1,numel(egos));
    
    for i=1:numel(egos)    
        ego = egos(i);                        
        [neighbors, ~, ~] = find(A(:,ego));        
        egonet_community = [ego neighbors'];
        
        avg_degree = sum(degrees(egonet_community)) / numel(egonet_community);
        
        ego_scores(i) = avg_degree;        
    end
    
    % sort all egos by score
    % highest avg degree worst?
    [scores, ind] = sort(ego_scores);
    scores = scores;    
    ranking = egos(ind);
end

