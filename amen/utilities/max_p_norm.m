function [ weights ] = max_p_norm( data_score, pnorm, k)
%MAX_P_NORM Summary of this function goes here
%   Detailed explanation goes here

    weights = sparse(1, size(data_score,2));

    if strcmpi(pnorm, 'l1')
        % L1 is just the biggest element of the data score        
        [i j v] = find (data_score);
        [maxV, idx] = max(v);
        weights(i(idx), j(idx)) = 1;
        
    elseif strcmpi(pnorm, 'l2')
        % L2 is all positive elements
        [i j v] = find (data_score > 0);  
        
        if numel(v) > 0        
        % this is the old way, 
            weights(i, j) = data_score(i, j);
            %weights = bsxfun(@times, weights, 1./sqrt(sum(weights.^2, 2)));        
            weights = bsxfun(@times, weights, 1./norm(weights, 2));        
            weights(~isfinite(weights)) = 0;
        
%         % this is for binary weights
%              weights(i, j) = 1;
        else
            [i j v] = find (data_score);
            [maxV, idx] = max(v);
            weights(i(idx), j(idx)) = 1;            
        end
        
    elseif strcmpi(pnorm, 'k')
        % this is the top-k elements
        
        
    end
end

