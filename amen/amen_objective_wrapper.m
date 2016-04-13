% Bryan Perozzi
function [normalized_score, raw_score, data_score, internal_edges, external_edges, internal_score, boundary_score] = amen_objective_wrapper (A, X, community, weights, degrees, M, objective_fn, use_community_features, X_Transpose)
% input: 
%   A, an undirected graph
%   X, a feature matrix
%   

     if nargin < 6
        m = nnz(A);    
     else
        m = M;
     end
     
     if nargin < 7
         objective_fn = @obj_final_k;
     end

     if nargin < 8
         use_community_features = 1;
     end     
     
     if nargin < 9
         X_Transpose = X';
     end

     if ~isequal(objective_fn, @amen_objective_learn_normalized)
    [normalized_score, raw_score, ...
        data_score, internal_edges, ...
        external_edges, internal_score, ... 
        boundary_score] = objective_fn(A, X_Transpose, community, weights, degrees, m, use_community_features);
     else
    [raw_score, data_score, ...
        internal_edges, external_edges] = objective_fn(A, X_Transpose, community, weights, degrees, m, use_community_features);         
    normalized_score = raw_score;
     end
end
