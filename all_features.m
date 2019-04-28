function [ features ] = all_features( f )
%Return all computed features for all color channels, i.e. before feature 
%fusion and reduction, as described in Section 2.2 of https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0039
%   f is single color channel of input image
%   features is 92 computed features for the single color channel

n_features = 92;
features = zeros([size(f) n_features]);
f_index = 1;

%Compute features from the Matched Filter (32 features)
% Computed for 4 scales, 4 lengths, and first derivative filter
% Take the maximum response from 12 angular orientations, with angular
% resulution of 15 degrees.

for sigma = [0.5 1 1.5 2]
    for length = [9 11 13 15]
        responses = -Inf([size(f) 12]);
        index = 1;
        for angle = 0:15:165
            kernel = matched_kernel(sigma, length, angle, false);
            responses(:,:,index) = wkeep(conv2(kernel, f), size(f));
            index = index + 1;
        end
        
        max_response = max(responses, [], 3);
        features(:,:,f_index) = max_response;
        f_index = f_index + 1;
        
        responses = -Inf([size(f) 12]);
        index = 1;
        for angle = 0:15:165
            kernel = matched_kernel(sigma, length, angle, true); %Gaussian derivative filter
            responses(:,:,index) = wkeep(conv2(kernel, f), size(f));
            index = index + 1;
        end
        
        max_response = max(responses, [], 3);
        features(:,:,f_index) = max_response;
        f_index = f_index + 1;
    end
end

%Compute features from the 2-D Gabor wavelet transform (4 *NOT* 8 features)
% The transform is computed for 8 scale levels, over 18 angles. The maximum
% response is taken for each scale.
% Scales given in the paper are [2 3 4 5], seen here: https://ieeexplore.ieee.org/abstract/document/6224174
% *NOT* Four scales values, [2.5 3.5 4.5 5.5], are interpolated to achieve eight
% in total.
% The angles range from 0 to 170 degrees, with angular step of 10 degrees.

for scales = [2 3 4 5]
    responses = -Inf(size(f));
    index = 1;
    for angles = 0:10:170
        kernel = gabor_kernel(sigma, angle);
        responses(:,:,index) = abs(wkeep(filter2(kernel, f), size(f)));
        index = index + 1;
    end
    
    max_response = max(responses, [], 3);
    features(:,:,f_index) = max_response;
    f_index = f_index + 1;
end

%Compute grey-level-based features (35 features)
% Statistical features extracted with window sizes ranging from 3 to 15 in
% steps of 2.
for window_size = 3:2:15
    new_features = grey_level_features(f, window_size);
    for index = 1:size(new_features, 3)
        features(:,:,f_index) = new_features(:,:,index);
        f_index = f_index + 1;
    end
end

%Compute features from the Frangi filter (16 *NOT* 20 features)
% Feature are computed at five different scale levels. Four scale levels,
% [2^(1/2), 2, 2^(3/2), 4], are provided here: https://ieeexplore.ieee.org/xpls/icp.jsp?arnumber=5482144#sec3
% *NOT* The remaining scale level, 3, is chosed by us.
for scale = [2^(1/2) 2 2^(3/2) 4]
    new_features = frangi_features(f, scale);
    for index = 1:size(new_features, 3)
        features(:,:,f_index) = new_features(:,:,index);
        f_index = f_index + 1;
    end
end

%Compute Difference of Gaussian features (5 features)
% Computed with baseline scale of 0.5, and five smoothing scales:
% [2^(-1/2) 1 2^(1/2) 2 2^(3/2)]
for scale = [2^(-1/2) 1 2^(1/2) 2 2^(3/2)]
    kernel = diff_of_gaussian_kernel(0.5, scale);
    DoG_feature = wkeep(filter2(kernel, f), size(f));
    features(:,:,f_index) = DoG_feature;
    f_index = f_index + 1;
end

end

