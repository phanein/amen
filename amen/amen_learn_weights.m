function [ weights, weighted_score ] = amen_learn_weights( A, X, community, degrees, M, pnorm, obj_fn, X_Transpose, continuous_features)
%AMEN_LEARN_WEIGHTS Find weights that maximize an obj for a pnom.

    [~, ~, data_score] = amen_objective_wrapper(A, X, community, [], degrees, M, obj_fn, 1, X_Transpose, continuous_features);        

    weights = max_p_norm(data_score, pnorm);

    [weighted_score, ~, ~] = amen_objective_wrapper(A, X, community, weights, degrees, M, obj_fn, 1, X_Transpose, continuous_features);     
    
%     fprintf ('nnz data elements: %d\n', nnz(data_score));
%     fprintf ('nnz & positive: %d\n', nnz(data_score > 0));
%     fprintf ('community score: %f\n\n', full(weighted_score));
end

