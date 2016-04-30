% Bryan Perozzi
function [weighted_score, raw_score, data_score, internal_edges, external_edges, internal_score, boundary_score] = ... 
    amen_objective_wrapper (A, X, community, weights, degrees, M, objective_fn, use_community_features, X_Transpose, continuous_features)
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
         objective_fn = @amen_objective;
     end

     if nargin < 8
         use_community_features = 1;
     end     
     
     if nargin < 9
         X_Transpose = X';
     end
     
     if nargin < 10
        continuous_features = 0;
     end
     
     
     if continuous_features == 1
         % normalize features -- columns of X (the rows of X_transpose), so big feature values don't blow up vs
         % small ones in dot product
         
         mins = min(X_Transpose, [], 2);
         maxs =  max(X_Transpose, [], 2);
         maxs = maxs-mins;
         
         X_Transpose_Normalized = (X_Transpose - mins(:,ones(1, size(X_Transpose,2)))) ./ maxs(:,ones(1, size(X_Transpose,2)));
     else
         % no normalization needed for binary features
         X_Transpose_Normalized = X_Transpose
     end

    [weighted_score, raw_score, internal_edges, external_edges, internal_score, boundary_score] = ... 
        objective_fn(A, X_Transpose_Normalized, community, weights, degrees, m, use_community_features, continuous_features);
    
    data_score = raw_score;
end
