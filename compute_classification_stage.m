function [ v_covariance, bg_covariance, v_mean, bg_mean, T_v, T_b, v_vectors_x, bg_vectors_x ] ...
    = compute_classification_stage( v_vectors, bg_vectors, error_v, error_b, reg_param, is_last )
%Compute nth stage of the classification network based on the training set.
%   v_vectors and bg_vectors are the training set, each column containing
%   the feature vector for a sample.
%   Returns the class covariance matrices, class means, class thresholds,
%   and the remaining unclassified vectors.
%   reg_param: regularization parameter
%   is_last: determines the type of threshold. If true, only the first
%   error parameter, error_v, is used.

[bg_mean, v_mean, bg_covariance, v_covariance] = process_class_vectors(v_vectors, bg_vectors);

[eigvec_v, eigval_v] = eig(v_covariance);
[eigvec_bg, eigval_bg] = eig(bg_covariance);

%Normalize and transpose eigen vectors
eigvec_v = transpose(normc(eigvec_v));
eigvec_bg = transpose(normc(eigvec_bg));

%Mean vector projections
v_mean_proj = eigvec_v*v_mean;
bg_mean_proj = eigvec_bg*bg_mean;

%Vectorize eigen values
eigval_v = diag(eigval_v);
eigval_bg = diag(eigval_bg);

%Sort eigen vectors
eigvec_v = [transpose(eigvec_v) eigval_v];
eigvec_v = sortrows(eigvec_v, size(eigvec_v, 2), 'descend');
eigval_v = eigvec_v(:, end);
eigvec_v = transpose(eigvec_v(:, 1:end-1));
eigvec_bg = [transpose(eigvec_bg) eigval_bg];
eigvec_bg = sortrows(eigvec_bg, size(eigvec_bg, 2), 'descend');
eigval_bg = eigvec_bg(:, end);
eigvec_bg = transpose(eigvec_bg(:, 1:end-1));

%Regularize the eigen values
eigval_v = regularize_eigvals(eigval_v, reg_param);
eigval_bg = regularize_eigvals(eigval_bg, reg_param);

%Create discriminant functions as per equation 15 in: https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0045
d_v = @(z) sum(((eigvec_v*z-v_mean_proj).^2)./eigval_v);
d_bg = @(z) sum(((eigvec_bg*z-bg_mean_proj).^2)./eigval_bg);

%Compute decision variable(delta d, as defined here: https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0045)
%for each feature vector
d_v_vals = zeros([0 size(v_vectors, 2)]);
for index = 1:size(v_vectors, 2)
    d_v_vals(index) = d_v(v_vectors(:, index)) - d_v(v_vectors(:, index));
end
v_vectors = [v_vectors; d_v_vals];

d_bg_vals = zeros([0 size(bg_vectors, 2)]);
for index = 1:size(bg_vectors, 2)
    d_bg_vals(index) = d_v(bg_vectors(:, index)) - d_bg(bg_vectors(:, index));
end
bg_vectors = [bg_vectors; d_bg_vals];

%Sort feature vectors by decision variable
last_feature_index = 101; %corresponds to the index of decision variable
v_vectors = transpose(...
    sortrows(...
    transpose(v_vectors), last_feature_index));
bg_vectors = transpose(...
    sortrows(...
    transpose(bg_vectors), last_feature_index));

%It is assumed that dataset will not result in overlap of indices, hence no
%checking occurs for the validity of the lower/upper index bounds.
if is_last
    %T_v contains the binary decision threshold if last stage.
    [T_v] = determine_threshold_last(v_vectors, bg_vectors);
else
    [T_v, v_index_lower, bg_index_lower] = determine_threshold(v_vectors, bg_vectors, error_v, 'upper');
    [T_b, v_index_upper, bg_index_upper] = determine_threshold(bg_vectors, v_vectors, error_b, 'lower');

    v_vectors_x = v_vectors(1:end-1, v_index_lower + 1:v_index_upper-1);
    bg_vectors_x = bg_vectors(1:end-1, bg_index_lower + 1:bg_index_upper-1);
end

end

