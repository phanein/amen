function [ ranking, scores ] = conductance_rank( A, ~, varargin )
%AMEN_RANK Rank egonets by their conductance
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
    
    if isempty(node_filter)
        node_filter = (degrees >= min_degree & degrees <= max_degree);
    end    
    
    % select egos to permute
    egos = find(node_filter);

    ego_scores = zeros(1,numel(egos));
    
    for i=1:numel(egos)    
        ego = egos(i);                        
        [neighbors, ~, ~] = find(A(:,ego));        
        egonet_community = [ego neighbors'];
        
        conductance = cutcond(A,egonet_community);
        
        ego_scores(i) = conductance;        
    end
    
    % sort all egos by score
    % highest conductance worst
    [scores, ind] = sort(ego_scores, 'descend');
    scores = scores;    
    ranking = egos(ind);
end

