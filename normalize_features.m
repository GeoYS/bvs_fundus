function [ normalized_features ] = normalize_features( features )
%Feature normalization as described here: https://ieeexplore.ieee.org/abstract/document/1677727
%   features contains the features for a single image. Features are 
%   separated by dim 3.
%   Normalized feature v_norm = (v - mean)/STD within the local image
%   space.

u = mean(mean(features, 1), 2);

sigma = sqrt(sum(sum((features-u).^2, 1), 2) / numel(features(:,:,1)));

normalized_features = (features - u)./sigma;

end

