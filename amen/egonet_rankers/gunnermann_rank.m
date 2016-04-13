function [ ranking, scores ] = gunnermann_rank( A, X, varargin )
%GUNNERMANN_RANK Rank egonets by their score according to Gunnermann's
% weighted spectral subspace algorithm
%   Detailed explanation goes here

    % parameters
    parser = inputParser;
    addOptional(parser,'min_degree', 30);
    addOptional(parser,'max_degree', 100);    
    addOptional(parser,'norm', 'L1'); 
    addOptional(parser,'node_filter', []);     

    varargin{:};
    parse(parser, varargin{:});    

    min_degree = parser.Results.min_degree
    max_degree = parser.Results.max_degree
    p_norm = parser.Results.norm
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
        
        [score, final_subspace] = gunn_objective( A, X, egonet_community );       
        
        ego_scores(i) = score;        
    end
    
    % sort all egos by score
    % most anomalaous is first - we are trying to minimize the cut, so
    % higher worse
    [scores, ind] = sort(ego_scores, 'descend');
    scores = scores;
    ranking = egos(ind);
end

