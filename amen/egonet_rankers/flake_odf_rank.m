function [ ranking, scores ] = flake_odf_rank( A, ~, varargin )
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
    
    % select egos to permute
    egos = find(node_filter);

    ego_scores = zeros(1,numel(egos));
    
    for i=1:numel(egos)    
        ego = egos(i);                        
        [neighbors, ~, ~] = find(A(:,ego));        
        egonet_community = [ego neighbors'];
        
        sorted_community = sort(unique(egonet_community));
        
        % assumes undirected
        internal_degree = zeros(size(sorted_community));
        
        for j=1:numel(sorted_community)            
            node = sorted_community(j);
            
            [src, ~, ~] =  find(A(:, node));            
            member_edges = ismembc(src, sorted_community);            
            
            internal_degree(j) = numel(src(member_edges));            
        end
        
        numerator = internal_degree.' < (degrees(sorted_community)/2);                
        flak_odf = sum(numerator) / numel(sorted_community);        
        ego_scores(i) = flak_odf;        
  
    end
    
    % sort all egos by score
    
%     %higher flake is worse.
     [scores, ind] = sort(ego_scores, 'descend');
%    % XXX this is a hack, so it is wrong like before
%    [scores, ind] = sort(ego_scores, 'ascend');
    scores = scores;    
    ranking = egos(ind);
end

