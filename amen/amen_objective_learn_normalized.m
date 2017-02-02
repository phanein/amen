% Bryan Perozzi
function [raw_score, data_score, internal_edges, external_edges] = amen_objective_learn_normalized (A, X_Transpose, community, weights, degrees, M, use_community_features)
% input: 
%   A, an undirected graph
%   X, a feature matrix
%   

    epsilon = 0.00001;

    if nargin < 7
       use_community_features = 0
    end     

    N_k = size(community,2);
    C_2 = (N_k * N_k);
    
    % size of boundary
    [boundary_nodes, B_internal, B_external, ~] = circle_boundary_undirected(A, community);
    
    % small versions of big matrices
    A_ = A(community, community);
    k_ = degrees(community, 1);
    
    X_ = X_Transpose(:,community);
    [community_features, ~, ~] = find(X_);
    X_Transpose_ = X_;
    X_ = X_.';
    
    
    BX_ = X_Transpose(:,B_external);
    BX_ = BX_.';
    
    if use_community_features == 1
        community_features = unique(community_features);
        X_ = X_(:, community_features);
        X_Transpose_ = X_.';
        
        BX_ = BX_(:, community_features);
    end
    
    num_features = size(X_Transpose_,1);
    
    % 1. get contributions for intra-community edges    
    internal_weights = zeros(num_features, 1 );
    only_positive_surprisingness = zeros(1, num_features);
    
    internal_edges = nnz(A_);
%     I_min = epsilon;
    I_min = 0;
    
    for i = 1:N_k
        for j = 1:N_k        
            surprisingness = (k_(i) * k_(j)) / (2 * M);
            similarity = X_Transpose_(:, i) .* X_Transpose_(:, j);  % dot product similarity            
            contribution = (A_(i,j) - surprisingness) * similarity;
            
            if A_(i,j) == 1
                only_positive_surprisingness = only_positive_surprisingness + A_(i,j) - min(1, surprisingness);                
            end
            
            internal_weights = internal_weights + contribution;
            I_min = I_min - surprisingness;
        end
    end
    
    I_max = C_2;    
    normalized_internal_weights = ((internal_weights - I_min) / (I_max - I_min));    
    
    % 2. get contributions for boundary edges    
    boundary_weights = zeros(1, num_features);       
    boundary_weights = boundary_weights.';
    external_edges = size(B_external,1);    
    
    AllXors = xor(X_(B_internal, :), BX_).';   
    min_boundary_weights = epsilon*ones(1, num_features).';
%     NotAllXors = ~AllXors;
    if numel(B_internal) > 0
        for a = 1:numel(B_internal)
            i = B_internal(a);  % internal
            b = B_external(a);  % external

            surprisingness = 1 - min(1, (k_(i) * degrees(b)) / (2 * M));         
            similarity = ~AllXors(:, a);   % kronecker delta similarity
            boundary_weights = boundary_weights + surprisingness * similarity;
        end
    end 
    
    normalized_external_weights = boundary_weights ./ (only_positive_surprisingness.' + max(boundary_weights, min_boundary_weights));    
    
%   for unnormalized weights    
%     community_weights = internal_weights - boundary_weights;
    
    community_weights = normalized_internal_weights - normalized_external_weights;    
    community_weights = community_weights.';
    
    if use_community_features == 1
        data_score = sparse(ones(size(community_features)), community_features, community_weights, 1, size(X_Transpose,1));
    else
        data_score = sparse(community_weights);
    end
    
    raw_score = data_score;
end
