function [ covariance ] = class_covariance( class_vectors, class_mean )
%Compute covariance matrix for dataset.
%   dataset_vectors contains feature vectors. Each column corresponds to
%   one feature vector. All vectors are assumed to be in the same class.

covariance = zeros(size(dataset, 1));
num_vectors = size(class_vectors, 2);
for index = 1:num_vectors
    feature_vector = class_vectors(:, index);
    feature_vector = feature_vector-class_mean;
    covariance = covariance + feature_vector*transpose(feature_vector);
end
covariance = covariance/num_vectors;

end

