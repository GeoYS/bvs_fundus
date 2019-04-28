function [ features ] = compute_features( image )

n_features = 92;
features = zeros([size(image, 1) size(image, 2) size(image, 3)*n_features+1]);
features(:,:,1:n_features) = all_features(image(:,:,2));
features(:,:,n_features+1:2*n_features) = all_features(image(:,:,1));
features(:,:,2*n_features+1:3*n_features) = all_features(image(:,:,3));

end

