function [ bg_vectors, v_vectors, reduction_matrix ] = color_channel_fusion_reduction ( dataset, image_masks )
%Fuse the color channels and reduce the features from n (>100) to 100.
%   - dataset contains labels in the last index of dim 3. Each image in
%   dataset is separated by index of dim 4.
%   - reduction_matrix is the transformation matrix to applied to a full
%   n-length feature vector to reduce the number of features to 100

for image = 1:size(dataset, 4)
    dataset(:,:,1:end-1,image) = normalize_features(dataset(:,:,1:end-1,image), image_masks(:,:,image));
    dataset(:,:,1:end-1,image) = apply_weights(dataset(:,:,1:end-1,image));
end

dataset(isnan(dataset)) = 0;
[bg_vectors, v_vectors] = extract_class_vectors(dataset);

bg_mean = mean(bg_vectors,2);
v_mean = mean(v_vectors, 2);
bg_covariance = cov(transpose(bg_vectors), 1);
v_covariance = cov(transpose(v_vectors), 1);

%Compute class mean covariance matrix: http://www3.ntu.edu.sg/home/EXDJiang/JiangX.D.-PAMI-09P.pdf
num_bg = size(bg_vectors, 2);
num_v = size(v_vectors, 2);
overall_mean = (bg_mean*num_bg+v_mean*num_v) / (num_bg+num_v);

bg_diff = bg_mean - overall_mean;
v_diff = v_mean - overall_mean;
class_mean_covariance = (num_bg*bg_diff*transpose(bg_diff) +...
    num_v*v_diff*transpose(v_diff)) / (num_bg + num_v);

%Compute dataset covariance
tau = 0.5;
dataset_covariance = tau*v_covariance + (1-tau)*bg_covariance + class_mean_covariance;

%Compute dimensionally reduced feature vectors
num_reduced_dimensions = 100; %Take the 100 eigenvectors with the largest eigenvalues
[V, D] = eigs(dataset_covariance, num_reduced_dimensions); %eigenvectors D are unused

reduction_matrix = transpose(V);

bg_vectors = reduction_matrix*bg_vectors;
v_vectors = reduction_matrix*v_vectors;

end

