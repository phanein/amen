function [ ranking, scores ] = oddball_rank(A, ~, varargin)
%AMEN_RANK Rank egonets by their conductance

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
    
    % maybe oddball-lite works?
    mkdir('tops');
    mkdir('plots');
    oddball_main('oddball', 0, 'adjacency', A, 'node_filter', node_filter);
    
    n_vs_e = dlmread('tops/oddball_1_2_IDandScoreSorted.txt');                
    
    ranking = n_vs_e(:,1);
    scores = n_vs_e(:,2);   
    
%     ego_selector = zeros(1,size(n_vs_e,1));
%     
%     for i=1:numel(ego_selector)    
%         if (degrees(ranking(i)) >= min_degree & degrees(ranking(i)) <= max_degree)
%             ego_selector(i) = 1;
%         end
%     end
%     
%     ego_selector = logical(ego_selector);
% 
%     % select only egos that we are considering  
%     ranking = ranking(ego_selector);
%     scores = scores(ego_selector);    
end

