% close all
% 
% % Load
% tic
% [ training, training_labels, training_masks...
%     validation, validation_labels, validation_masks...
%     test, test_labels, test_masks ] = load_DRIVE();
% toc

img_index = 1;
george = training(:,:,:,img_index);
georgel = training_labels(:,:,img_index);

show_image(george, 1, 'Sample fundus image from dataset');

% BG norm
window_size = 25;
tic
george = bg_normalization(george, window_size);
toc %6 seconds
show_image(george, 6, 'Image with background normalization');

% Next, remove noise by apply detail-preserving truncation filter.
inner_window = 13;
outer_window = 15;
tic
george = det_noise_removal(george, inner_window, outer_window);
toc %11 seconds
show_image(george, 6, 'Detail-preserved, noise-removed image');

% Generate features
% tic
% n_features = 92;
% features = zeros([size(george, 1) size(george, 2) size(george, 3)*n_features+1]);
% features(:,:,1:n_features) = all_features(george(:,:,2));
% features(:,:,n_features+1:2*n_features) = all_features(george(:,:,1));
% features(:,:,2*n_features+1:3*n_features) = all_features(george(:,:,3));
% features(:,:,end) = training_labels(:,:,img_index);
% toc %8 minutes

% Fuse reduce
% tic
% [bg_vectors, v_vectors, reduction_matrix] = color_channel_fusion_reduction(features, training_masks);
% toc %3.5 minutes

%Compute classification stage
error_v = 0.45;
error_b = 0.05;
reg_param = 95;
is_last = false;
% tic
% [stage, v_vectors_x, bg_vectors_x] = compute_classification_stage(v_vectors, bg_vectors, error_v, error_b, reg_param, is_last);
% toc %12 seconds
is_last = true;
% tic
% [laststage, v_vectors_x2, bg_vectors_x2] = compute_classification_stage(v_vectors, bg_vectors, error_v, error_b, reg_param, is_last);
% toc %12 seconds

out = segment_image(george, reduction_matrix, [stage laststage], features);

return

function [ ] = show_image( image, intensity_factor, title_text )    
    for ch = 1:size(image, 3)
        channel = image(:,:,ch);
        minval = min(channel(:));
        maxval = max(channel(~isinf(channel)));
        if minval ~= 0
            channel = channel - minval;
        end
        channel = channel / maxval;
        image(:,:,ch) = channel;
    end
    
    figure;
    imshow(uint8(image*255*intensity_factor));
    title(title_text);
end
