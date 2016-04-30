function [ ranking, scores ] = amen_rank( A, X_Total, varargin )
%AMEN_RANK Rank egonets by their amen circle normality score
%   Detailed explanation goes here

    % parameters
    parser = inputParser;
    addOptional(parser,'min_degree', 30);
    addOptional(parser,'max_degree', 100);    
    addOptional(parser,'norm', 'L1'); 
    addOptional(parser,'node_filter', []);     
    addOptional(parser,'continuous_features', 0);

    varargin{:};
    parse(parser, varargin{:});    

    min_degree = parser.Results.min_degree
    max_degree = parser.Results.max_degree
    p_norm = parser.Results.norm
    node_filter = parser.Results.node_filter;    
    continuous_features = parser.Results.continuous_features;    
    
    degrees = sum(A,2);
    M = nnz(A)/2;
    
    if isempty(node_filter)
        node_filter = (degrees >= min_degree & degrees <= max_degree);
    end
    
    % select egos to permute
    egos = find(node_filter);

    ego_scores = zeros(1,numel(egos));
    
    X_Total_Transpose = X_Total.';
    
    for i=1:numel(egos)    
        ego = egos(i);                        
        [neighbors, ~, ~] = find(A(:,ego));        
        egonet_community = [ego neighbors'];
               
        % use only features that are non-zero inside the community
%         [ci, ~, ~] = find(X_Total_Transpose(:,egonet_community));        
        X = []; 
        
        [~, weighted_score] = amen_learn_weights( A, X, egonet_community, degrees,  M, p_norm, @amen_objective, X_Total_Transpose, continuous_features);       
        
        ego_scores(i) = weighted_score;        
    end
    
    % sort all egos by score
    [scores, ind] = sort(ego_scores);
    scores = scores;
    ranking = egos(ind);
end

