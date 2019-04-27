%%Blood vessel segmentation from fundus image by a cascade classification framework
% Prepared by: George Shen, Abilas Sathiyanesan

%%1. Problem Formulation
% The goal of this project is to accurately segment retinal blood vessel
% pixels from background, non-blood vessel pixels for images of the 
% interior surface of the eye (fundus).
%
% The motivation for the task is to improve pre-screening of patients with
% eye-related ailments. Doctors are then able to focus their attention
% where it is needed the most, while patients are able to receive timely
% responses.

%%2. Proposed Solution
% The solution comes from the paper _Blood vessel segmentation from fundus 
% image by a cascade classification framework_[1], by Xiaohong Wang, Xudong 
% Jiang, and Jianfeng Ren. It focuses on a novel, cascade
% classification network that leverages a feature set that has previously 
% been show to be effctive in segmenting vessels. Additionally, existing 
% methods of preprocessing the fundus images and postprocessing the 
% classifier output, are applied together with the classification netowrk,
% increasing classification accuracy and reducing the number of false 
% positives.
%
% Before images are used, they are preprocessed. First, the background is 
% normalized to reduce fluctuations in image intensity. This is achieved by
% dividing each pixel value by a local median (determined by a sliding 
% window). Second, the noise is removed while preserving fine detail, such 
% as very thin blood vessels. This is done by applying a specialized 
% detail-preserving truncation filter. 
%
% To create the cascade classification network, it is trained via a one-pass
% non-iterative feed-foward process. The class discriminant function is the
% Mahalonobis distance function. The decision variable at each stage of the
% classifier is the difference between the vessel discriminant and the
% background discriminant. Thus, each stage is characterized by the
% covariance matrices and class averages of the dataset it was trained
% along.
%
% Each stage of the classifier has two threshold values associated with it:
% a upper thresh T_v and lower threshold T_b such that.
% $$\textbf{z}\in \left \{ \begin{matrix}\Omega_{v},\;\Delta d<T_{v}\\
% \Omega_{b},\;\Delta d<T_{v}\\ \Omega_{x},\;else\\ \end{matrix} \right.$$
% These threshold values are determined by maximum misclassification rate
% parameters. If the decision variable falls between these two values, the
% classifier returns a third class representing inconclusive
% classification. During training, the subset of the training set that is
% inconclusive is used to train the next dataset. During classification,
% the pixel is sent to the next stage to be classified.
%
% When all pixels in an image have been classified, the final
% post-processing step removes false-positive blood vessel detection by
% taking advantage of the geometry of blood vessels. The algorithm first
% divides the detected blood vessel pixels into a set of connected
% components (each component is a grouping of vessel pixels representing a
% section of a blood vessel). For each connected component, three metrics
% are calculated:
% # The ratio of branch points to non-branch points. (Blood vessels tend to
% have a low ratio because of their sparsely branching shape.)
% # The ratio of the small eigenvector to the larger eigenvector of the 
% covariance matrix that is computed using the locations of each blood 
% vessel pixel in the connected component. (This describes the spatial
% spread of the pixels. Blood vessels tend to have a low ratio because they
% are long and narrow.)
% # The ratio of the number of pixels in the connected component to the
% number of pixels in its convex hull. (Blood vessels tend to have a low
% ratio.)
% 

%%3. Data Sources
% The datasets that are used to test this method are the DRIVE, STARE, and
% CHASE_DB1. Each dataset is publicly available and contains a set of
% fundus images along with pixel labels hand-labelled by experts in the
% field. For simplicity, this project will show the results using the
% CHASE_DB1 dataset.
%

%Main script starts here.
% tic
% [ training, training_labels,...
%     validation, validation_labels,...
%     test, test_labels ] = load_CHASEDB1();
% toc
% show_image(training(:,:,:,1), 1, 'Sample fundus image from dataset');

%%4. Solution
% 
%%%4.1 Preprocessing
% First, apply background normalization to remove intensity fluctuations.
% window_size = 25;
% tic
% training = apply_bg_normalization(training, window_size);
% validation = apply_bg_normalization(validation, window_size);
% test = apply_bg_normalization(test, window_size);
% toc % about 8 minutes
% show_image(training(:,:,1,1), 2.2, 'Image with background normalization');

% Next, remove noise by apply detail-preserving truncation filter.
% inner_window = 13;
% outer_window = 15;
% tic
% training = apply_noise_removal(training, inner_window, outer_window);
% validation = apply_noise_removal(validation, inner_window, outer_window);
% test = apply_noise_removal(test, inner_window, outer_window);
% toc % about 7 minutes
% show_image(training(:,:,:,1), 2.2, 'Detail-preserved, noise-removed image');

return

%%5. Visualization of Results
%

%%6. Analysis and Conclusions

%Load image
f = double(imread('fundus_test_2_comp.jpg'));
imshow(uint8(f)), title('Original Image')


f_bg_norm = bg_normalization(f);

%figure, imshow(uint8(f_bg_norm)), title('Image with normalized background');
figure, imshow(uint8(f_bg_norm.*255)), title('Image with normalized background multiplied by 200');

f_noise_removed = det_noise_removal(f_bg_norm);

figure,imshow(uint8(f_noise_removed)), title('Detail preserved noise removed Image')

figure,imshow(uint8(f_noise_removed.*255)), title('Detail preserved noise removed Image multipled by 200')

f_G = f(:,:,2);
features = all_features(f_noise_removed(:,:,2));
figure, imshow(uint8(features(:,:,1).*255/max(max(features(:,:,1))))), title('feature vector')

%%7. Linked Source Code
% 

%%8. Helper Functions
% The following functions were used in only in this script:

function [ images ] = apply_bg_normalization( images, window_size )
    
    for im_index = 1:size(images, 4)
        images(:,:,:,im_index) =...
            bg_normalization(images(:,:,:,im_index), window_size);
    end
end

function [ images ] = apply_noise_removal( images, inner_window, outer_window )
    
    for im_index = 1:size(images, 4)
        images(:,:,:,im_index) =...
            det_noise_removal(images(:,:,:,im_index), inner_window, outer_window);
    end
end

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

%%9. References
% [1] X. Wang, X. Jiang, J. Ren, "Blood vessel segmentation from fundus image by a cascade classification framework," Pattern Recognition, vol. 88, pp. 331-341, 2019.