% Bryan Perozzi
function [normalized_score, raw_score, data_score, internal_edges, external_edges, internal_score, ... 
    boundary_score, internal_weights, only_positive_surprisingness, I_min, boundary_weights] = ...
    amen_objective (A, X_Transpose, community, weights, degrees, M, use_community_features)
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
    [boundary_nodes, B_internal, B_external, B_value] = circle_boundary_undirected(A, community);
    %[B_x, B_y, B_z] = find(B);      
%     N_b = size(boundary_nodes);   % java object
    
    alpha_weight = 1;
    beta_weight = 1;
    
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
        
        [i, j, ~] = find(weights);
        sparse_selector = sparse(i, j, ones(1, size(i,2)), size(weights,1),size(weights,2));    
        original_weights = weights;
        weights = weights(:, community_features);
    else
        original_weights = weights;
        [i, j, ~] = find(weights);
        sparse_selector = sparse(i, j, ones(1, size(i,2)), size(weights,1),size(weights,2));        
    end
    
    weights_Transpose = weights.';       
    
    num_features = size(weights,2);
    
    % 1. get contributions for intra-community edges    
    internal_weights = zeros(1, num_features).';
    only_positive_surprisingness = zeros(1, num_features);
    
    internal_edges = nnz(A_)/2;
    I_min = epsilon;

%     (A_ - k_'*k_/(2*M)) * (X_ .* X_)

    for i = 1:N_k
        for j = 1:N_k        
            surprisingness = (k_(i) * k_(j)) / (2 * M);

            % this operation is surprisingly hard to vectorize with 2D
            % matrices
%             similarity = weights_Transpose .* X_Transpose_(:, i) .* X_Transpose_(:, j);  % dot product similarity            
            similarity = X_Transpose_(:, i) .* X_Transpose_(:, j);  % dot product similarity                        
%            similarity = X_(i, :) .* X_(j, :);  % dot product similarity

%            contribution = (A_(i,j) - surprisingness) * similarity;
            contribution = (A_(i,j) - surprisingness) * similarity;
            
            if A_(i,j) == 1
                only_positive_surprisingness = only_positive_surprisingness + A_(i,j) - min(1, (k_(i) * k_(j)) / (2 * M));                
            end
            
            internal_weights = internal_weights + contribution;
            I_min = I_min - surprisingness;
        end
    end
        
    internal_weights = alpha_weight * internal_weights.';    
    
%     I_max = sum(weights) * C_2;
    I_max = C_2;
    
    normalized_internal_weights = ((internal_weights - I_min) / (I_max - I_min));
    

    if use_community_features == 1
        internal_score = sparse(ones(size(community_features)), community_features, normalized_internal_weights, 1, size(X_Transpose,1));
    else
        internal_score = normalized_internal_weights;
    end
    
    internal_score = dot(sparse_selector, sparse(internal_score));
    internal_score = max(epsilon, internal_score);    
    
    % 2. get contributions for boundary edges    
    boundary_weights = zeros(1, num_features);       
%     external_edges = sum(sum(B));
    external_edges = size(B_external,1);

    min_boundary_weights = epsilon*ones(1, num_features);
%     max_normalized_external_weights = ones(1, size(weights,2));

%     AllOnes = ones(1,size(X,2)).';    
%     AllOnes = ones(1,size(X,2));    
       
%     max_boundary_score = max(numel(B_x), epsilon);    
    
    
    AllXors = xor(X_(B_internal, :), BX_).'; 
%     AllXors = xor(X_(B_x, :), BX_);     
    
    %AllXors = xor(X_(B_x, :), X(B_y, :)); 
    %AllXors = xor(X_(x, :), X_Transpose(:,y)');     
    
    fprintf ('internal vs boundary edges: %d,%d\n', internal_edges, numel(B_internal));
    if numel(B_internal) > 0
        for a = 1:numel(B_internal)
          i = B_internal(a);  % internal
          b = B_external(a);  % external

          surprisingness = 1 - min(1, (k_(i) * degrees(b)) / (2 * M));         
%           similarity = (X_(i, :) == X(b, :))/num_features;    % kronecker delta similarity

%            similarity = AllOnes - AllXors(:, a);   % kronecker delta similarity
%            similarity = weights_Transpose .* ~AllXors(:, a);   % kronecker delta similarity
           similarity = ~AllXors(:, a);   % kronecker delta similarity
           
           boundary_weights = boundary_weights + surprisingness * similarity';

            %similarity = AllOnes - AllXors(a, :);   % kronecker delta similarity            
%             similarity = ~AllXors(a, :);   % kronecker delta similarity??            
%             boundary_weights = boundary_weights + surprisingness * similarity;
        end
    end 
    
    % do it like conductance
    boundary_weights = beta_weight * boundary_weights;
    
    normalized_external_weights = boundary_weights ./ (only_positive_surprisingness + max(boundary_weights, min_boundary_weights));
    
    % sometimes (internal + external) = 0
    %normalized_external_weights = abs(normalized_external_weights);
    %normalized_external_weights = min(normalized_external_weights, max_normalized_external_weights);
    %normalized_external_weights = max(normalized_external_weights, zeros(1, size(weights,2)));
    
    if use_community_features == 1
        boundary_score = sparse(ones(size(community_features)), community_features, normalized_external_weights, 1, size(X_Transpose,1));
    else
        boundary_score = normalized_external_weights;
    end
    
    boundary_score = dot(sparse_selector, sparse(boundary_score));
    boundary_score = max(epsilon, boundary_score);
    
    %[internal_score, max_internal_score, boundary_score, max_boundary_score]
    
    community_weights = normalized_internal_weights - normalized_external_weights;

    if use_community_features == 1
        data_score = sparse(ones(size(community_features)), community_features, community_weights, 1, size(X_Transpose,1));
    else
        data_score = sparse(community_weights);
    end    
    
%     data_score = sparse(community_weights);
    raw_score = dot(original_weights, data_score);
    
    normalized_score = raw_score;  
end
