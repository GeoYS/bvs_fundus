function [ features ] = all_features( f )
%Return all computed features for all color channels, i.e. before feature 
%fusion and reduction, as described in Section 2.2 of https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0039
%   f is single color channel of input image
%   features is 100 computed features for the single color channel

features = zeros(size(f));

%Compute features from the Matched Filter (32 features)
% Computed for 4 scales, 4 lengths, and first derivative filter
% Take the maximum response from 12 angular orientations, with angular
% resulution of 15 degrees.

for sigma = [0.5 1 1.5 2]
    for length = [9 11 13 15]
        responses = zeros(size(f));
        for angle = 0:15:165
            kernel = matched_kernel(sigma, length, angle, false);
            responses = cat(3, responses, wkeep(conv2(kernel, f), size(f)));
        end
        
        max_response = max(responses, [], 3);
        features = cat(3, features, max_response);
        
        responses = zeros(size(f));
        for angle = 0:15:165
            kernel = matched_kernel(sigma, length, angle, true); %Gaussian derivative filter
            responses = cat(3, responses, wkeep(conv2(kernel, f), size(f)));
        end
        
        max_response = max(responses, [], 3);
        features = cat(3, features, max_response);
    end
end

%Compute features from the 2-D Gabor wavelet transform (8 features)
% The transform is computed for 8 scale levels, over 18 angles. The maximum
% response is taken for each scale.
% Scales given in the paper are [2 3 4 5], seen here: https://ieeexplore.ieee.org/abstract/document/6224174
% Four scales values, [2.5 3.5 4.5 5.5], are interpolated to achieve eight
% in total.
% The angles range from 0 to 170 degrees, with angular step of 10 degrees.

for scales = [2 2.5 3 3.5 4 4.5 5 5.5 6]
    responses = zeros(size(f));
    for angles = 0:10:170
        kernel = gabor_kernel(sigma, angle);
        responses = cat(3, responses, wkeep(filt2(kernel, f), size(f)));
    end
    
    max_response = max(responses, [], 3);
    features = cat(3, features, max_response);
end

%Compute grey-level-based features (35 features)
% Statistical features extracted with window sizes ranging from 3 to 15 in
% steps of 2.
for window_size = 3:2:15
    features = cat(3, features, grey_level_features(f, window_size));    
end

%Compute features from the Frangi filter (20 features)
% Feature are computed at five different scale levels. Four scale levels,
% [2^(1/2), 2, 2^(3/2), 4], are provided here: https://ieeexplore.ieee.org/xpls/icp.jsp?arnumber=5482144#sec3
% The remaining scale level, 3, is chosed by us.
for scale = [2^(1/2) 2 2^(3/2) 3 4]
    features = cat(3, features, frangi_features(f, scale));    
end

%Compute Difference of Gaussian features (5 features)
% Computed with baseline scale of 0.5, and five smoothing scales:
% [2^(-1/2) 1 2^(1/2) 2 2^(3/2)]
for scale = [2^(-1/2) 1 2^(1/2) 2 2^(3/2)]
    kernel = diff_of_gaussian_kernel(0.5, scale);
    DoG_feature = wkeep(filt2(kernel, f), size(f));
    features = cat(3, features, DoG_feature);
end

end

