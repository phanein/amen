function [ ranking, scores ] = cut_ratio_rank( A, ~, varargin )
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

    nodes = size(A,1);
    
    % select egos to permute
    egos = find(node_filter);

    ego_scores = zeros(1,numel(egos));
    
    for i=1:numel(egos)    
        ego = egos(i);                        
        [neighbors, ~, ~] = find(A(:,ego));        
        egonet_community = [ego neighbors'];
        
        [boundary_nodes, B_internal, B_external, B_value] = circle_boundary_undirected(A, egonet_community);
        
        if (nodes - numel(egonet_community)) ~= 0
            cut_ratio = numel(B_internal) / (numel(egonet_community) *(nodes - numel(egonet_community)));
        else
            % this should only happen if "cut" is the entire graph, so no
            % boundary (0/0)
            cut_ratio = 0;
        end
        
        ego_scores(i) = cut_ratio;           
    end
    
    % sort all egos by score
    [scores, ind] = sort(ego_scores, 'descend');
    scores = scores;    
    ranking = egos(ind);
end

