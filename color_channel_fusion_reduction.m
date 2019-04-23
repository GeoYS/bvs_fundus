function [ output_args ] = color_channel_fusion_reduction ( dataset )
%Fuse the color channels and reduce the features from 300 to 100.
%   dataset contains labels in the last index of dim 3. Each image in
%   dataset is separated by index of dim 4.

for image = 1:size(dataset, 4)
    dataset(:,:,1:end-1,image) = normalize_features(dataset(:,:,1:end-1,image));
    dataset(:,:,1:end-1,image) = apply_weights(dataset(:,:,1:end-1,image));
end

%Reshape such that each column is on data sample (i.e. features for a
%single pixel)
dataset = permute(dataset, [3 1 2 4]);
dataset = reshape(dataset, [size(dataset, 1) size(dataset, 2)*size(dataset, 3)*size(dataset, 4)]);

%Select feature vectors based on class
bg_vectors = dataset(1:end-1, dataset(end, :) == 0); %Class 0 corresponding to background
v_vectors = dataset(1:end-1, dataset(end, :) == 1); %Class 1 corresponding to background

%Compute class means
bg_mean = mean(bg_vectors, 2);
v_mean = mean(v_vectors, 2);

%Compute background covariance matrix
bg_covariance = dataset_covariance(bg_vectors, bg_mean);
v_covariance = dataset_covariance(v_vectors, v_mean);

class_mean_covariance = 

end

