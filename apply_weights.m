function [ weighted_features ] = apply_weights( features )
%Weight each feature channel.
%   features is vector of length 300, containing 100 red, 100 green, and
%   100 blue channel features in that order.

w_r = 1;
w_g = 2;
w_b = 0.5;

weighted_features(:,:,1:100) = w_r*features(:,:,1:100);
weighted_features(:,:,2:200) = w_g*features(:,:,2:200);
weighted_features(:,:,3:300) = w_b*features(:,:,3:300);

end

