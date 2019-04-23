function [ k ] = diff_of_gaussian_kernel( base_sigma, sigma )
%Assumed that sigma > base_sigma 
%base_sigma corresponds to a LPF with higher cutoff frequency, whereas
%sigma corresponds to a LPF with a lower cutoff frequency
assert(sigma > base_sigma)

max_dist = ceil(3*sigma); % values beyond 3*sigma are negligible
k_length = 2*max_dist + 1;

%Index matrices
x = -max_dist:max_dist;
x = repmat(x, k_length, 1);
y = transpose(x);

%Compute the difference of the Gaussian kernels described by sigma and
%base_sigma
k = exp(-(x.^2 + y.^2)/(2*base_sigma^2)) - exp(-(x.^2 + y.^2)/(2*sigma^2));

end

