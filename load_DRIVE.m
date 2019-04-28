function [ training, training_labels, training_masks,...
    validation, validation_labels, validation_masks,...
    test, test_labels, test_masks ] = load_DRIVE ( )
%It is asssumed that the folder containing the dataset is located in the
%same folder as this function. The folder containing the images is assumed
%to be named 'CHASEDB1'

training_prefix = 'DRIVE/training/';
test_prefix = 'DRIVE/test/';

image_size1 = 584;
image_size2 = 565;
num_training = 20;
num_validation = 2;
num_test = 8;

training = zeros(image_size1, image_size2, 3, num_training);
training_labels = zeros(image_size1, image_size2, num_training);
training_masks = zeros(image_size1, image_size2, num_training);
validation = zeros(image_size1, image_size2, 3, num_validation);
validation_labels = zeros(image_size1, image_size2, num_validation);
validation_masks = zeros(image_size1, image_size2, num_validation);
test = zeros(image_size1, image_size2, 3, num_test);
test_labels = zeros(image_size1, image_size2, num_test);
test_masks = zeros(image_size1, image_size2, num_test);

for index = 1:20
    image_file = strcat(test_prefix, 'images/');
    mask_file = strcat(test_prefix, 'mask/');
    label_file = strcat(test_prefix, '1st_manual/');
    if index < 10
        image_file = strcat(image_file, '0');
        mask_file = strcat(mask_file, '0');
        label_file = strcat(label_file, '0');
    end
    image_file = strcat(image_file, int2str(index), '_test.tif');
    mask_file = strcat(mask_file, int2str(index), '_test_mask.gif');
    label_file = strcat(label_file, int2str(index), '_manual1.gif');
    image = imread(image_file);
    mask = imread(mask_file)/255;
    label = imread(label_file);

    test(:,:,:,index) = image.*mask;
    test_labels(:,:,index) = label(:,:,1);
    test_masks(:,:,index) = mask(:,:,1);
end

for index = 21:40
    image_file = strcat(training_prefix, 'images/');
    mask_file = strcat(training_prefix, 'mask/');
    label_file = strcat(training_prefix, '1st_manual/');
    image_file = strcat(image_file, int2str(index), '_training.tif');
    mask_file = strcat(mask_file, int2str(index), '_training_mask.gif');
    label_file = strcat(label_file, int2str(index), '_manual1.gif');
    image = imread(image_file);
    mask = imread(mask_file)/255;
    label = imread(label_file);

    training(:,:,:,index-20) = image.*mask;
    training_labels(:,:,index-20) = label(:,:,1);
    training_masks(:,:,index-20) = mask(:,:,1);
end

v1 = randi(20, 1);
v2 = randi(20, 1);
while v2 == v1
    v2 = randi(20, 1);
end
validation(:,:,:,1:2) = training(:,:,:,[v1 v2]);
validation_labels(:,:,1:2) = training_labels(:,:,[v1 v2]);
validation_masks(:,:,1:2) = training_masks(:,:,[v1 v2]);

end

