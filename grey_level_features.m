function [ features ] = grey_level_features( f, window_size )
%Compute grey-level-based features as describe here: https://ieeexplore.ieee.org/abstract/document/5545439
%   f is input image
%   window_size ranges from 3 to 15 in steps of 2
%   features is output vector = [mean, standard deviation, differences
%   between the pixel and the mean, maximum and minimum]

%Compute window mean
mean = movmean(f, window_size, 1);
mean = movmean(mean, window_size, 2);

%Compute window std
%Consider custom implementation to change boundary conditions.
std = stdfilt(f, true(window_size));

%Compute pixel minus window mean
pixel_mean_diff = f - mean;

%Compute max minus pixel
max = ordfilt2(f, window_size*window_size, true(window_size));
pixel_max_diff = max - f;

%Compute window mean
min = ordfilt2(f, 1, true(window_size));
pixel_min_diff = f - min;

features = cat(3, mean, std, pixel_mean_diff, pixel_max_diff, pixel_min_diff);

end

