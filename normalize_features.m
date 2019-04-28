function [ normalized_features ] = normalize_features( features, mask )
%Feature normalization as described here: https://ieeexplore.ieee.org/abstract/document/1677727
%   features contains the features for a single image. Features are 
%   separated by dim 3.
%   Normalized feature v_norm = (v - mean)/STD within the local image
%   space.

masked_features = features.*mask;

u = sum(sum(masked_features, 1), 2)/nnz(mask);

sigma = sqrt(sum(sum((masked_features-u).^2, 1), 2) / nnz(mask(:,:,1)));

normalized_features = (features - u)./sigma;

end

