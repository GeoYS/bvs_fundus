function [ features ] = apply_weights( features )
%Weight each feature channel.
%   features is vector of length 3*n_features, containing n_features red,
%   n_features green, and n_features blue channel features in that order.

w_r = 1;
w_g = 2;
w_b = 0.5;

n_features = uint8(size(features, 3)/3);

features(:,:,1:n_features) = w_r*features(:,:,1:n_features);
features(:,:,n_features+1:2*n_features) =...
    w_g*features(:,:,n_features+1:2*n_features);
features(:,:,2*n_features+1:3*n_features) =...
    w_b*features(:,:,2*n_features+1:3*n_features);

end

