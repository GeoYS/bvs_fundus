function [ bg_mean, v_mean, bg_covariance, v_covariance ] = process_class_vectors( bg_vectors, v_vectors )
%Compute class means and covariance matrices

%Compute class means
bg_mean = mean(bg_vectors, 2);
v_mean = mean(v_vectors, 2);

%Compute background covariance matrix
bg_covariance = dataset_covariance(bg_vectors, bg_mean);
v_covariance = dataset_covariance(v_vectors, v_mean);

end

