function [ reduction_matrix ] = color_channel_fusion_reduction_matrix ( dataset )
%Fuse the color channels and reduce the features from 300 to 100.
%   dataset contains labels in the last index of dim 3. Each image in
%   dataset is separated by index of dim 4.
%   reduction_matrix is the transformation matrix to applied to a full
%   300 feature vector to reduce the number of features to 100

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

%Compute class mean covariance matrix: http://www3.ntu.edu.sg/home/EXDJiang/JiangX.D.-PAMI-09P.pdf
num_bg = size(bg_vectors, 2);
num_v = size(v_vectors, 2);
overall_mean = (bg_mean*num_bg+v_mean*num_v) / (num_bg+num_v);
class_mean_covariance = (num_bg*(bg_mean-overall_mean)*transpose(bg_mean-overall_mean) +...
    num_v*(v_mean-overall_mean)*transpose(v_mean-overall_mean)) / (num_bg + num_v);

%Compute dataset covariance
tau = 0.5;
dataset_covariance = tau*v_covariance + (1-tau)*bg_covariance + class_mean_covariance;

%Compute dimensionally reduced feature vectors
num_reduced_dimensions = 100;
V, D = eigs(dataset_covariance, num_reduced_dimensions);

reduction_matrix = transpose(V);

end

