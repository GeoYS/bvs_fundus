close all
clear

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