function [ features ] = frangi_features( f, scale )
%Each scale corresponds to the standard devation of the Gaussian
sigma = scale;

max_dist = ceil(3*sigma); % values beyond 3*sigma are negligible
k_length = 2*max_dist + 1;

%Index matrices
x = -max_dist:max_dist;
x = repmat(x, k_length, 1);
y = transpose(x);

%Compute partial derivatives of the Gauusian kernel, scaling coefficient is
%neglected.
gaussian_dx = -2*x.*exp(-(x.^2+y.^2)/(2*sigma^2));
gaussian_dy = -2*y.*exp(-(x.^2+y.^2)/(2*sigma^2));

%Pad image
f_size = size(f);
f_padded = padarray(f, max_dist, 'symmetric', 'both');

%Compute partial derivatives of f
df_dx = conv2(gaussian_dx, f_padded);
df_dy = conv2(gaussian_dy, f_padded);

df_dxx = wkeep(conv2(gaussian_dx, df_dx), f_size);
df_dyy = wkeep(conv2(gaussian_dy, df_dx), f_size);
df_dxy = wkeep(conv2(gaussian_dy, df_dy), f_size); 
df_dyx = df_dxy;

%Compute the Hessian matrix
hess = df_dxx;
hess(:, :, 2) = df_dyx;
hess(:, :, 3) = df_dxy;
hess(:, :, 4) = df_dyy;

hess = reshape(hess, [size(hess, 1) size(hess, 2) 2 2]);

%Create buffer for features
vesselness = zeros(size(f));
frobenius_norm = zeros(size(f)); 
hess_eig1 = zeros(size(f)); %Principal curvatures
hess_eig2 = zeros(size(f)); 

%Frangi parameter
beta = 0.5;

%Compute Frobenius norms
for a = 1:size(hess, 1)
    for b = 1:size(hess, 2)
        hess_ab = squeeze(hess(a, b, :, :));
        hess_eigs = eig(hess_ab);
        if abs(hess_eigs(1)) > abs(hess_eigs(2))
            hess_eigs([1 2]) = hess_eigs([2 1]);
        end
        
        %Store principal curvatures
        hess_eig1(a, b) = hess_eigs(1);
        hess_eig2(a, b) = hess_eigs(2);
        
        %Compute Frobenius norm
        frobenius_norm(a, b) = norm(hess_ab);
    end
end

c = max(max(frobenius_norm));

%Compute vesselness
indices = hess_eig2 > 0;
R_b(indices) = hess_eig1(indices)./hess_eig2(indices);
vesselness(indices) = exp(-(R_b(indices).^2)/(2*beta^2)) * (1 - exp(-frobenius_norm(indices).^2/(2*c^2)));

%features = [vesselness frobenius_norm hess_eig1 hess_eig2];
features = cat(3, vesselness, frobenius_norm, hess_eig1, hess_eig2);

end