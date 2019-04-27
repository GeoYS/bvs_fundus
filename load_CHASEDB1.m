function [ training, training_labels, validation, validation_labels, test, test_labels ] = load_CHASEDB1 ( )
%It is asssumed that the folder containing the dataset is located in the
%same folder as this function. The folder containing the images is assumed
%to be named 'CHASEDB1'

prefix = 'CHASEDB1/Image_';

image_size1 = 960;
image_size2 = 999;
num_training = 20;
num_validation = 2;
num_test = 8;

training = zeros(image_size1, image_size2, 3, num_training);
training_labels = zeros(image_size1, image_size2, num_training);
validation = zeros(image_size1, image_size2, 3, num_validation);
validation_labels = zeros(image_size1, image_size2, num_validation);
test = zeros(image_size1, image_size2, 3, num_test);
test_labels = zeros(image_size1, image_size2, num_test);

for index = 1:10
    name = prefix;
    if index < 10
        name = strcat(name, '0');
    end
    for side = ['L', 'R']
        namelr = strcat(name, int2str(index), side);
        image_file = strcat(namelr, '.jpg');
        label_file = strcat(namelr, '_1stHO.png');
        image = imread(image_file);
        label = imread(label_file);
        
        if strcmp(side, 'L')
            training(:,:,:,index) = image;
            training_labels(:,:,index) = label(:,:,1);
        else
            training(:,:,:,index+1) = image;
            training_labels(:,:,index+1) = label(:,:,1);
        end
    end
end

for index = 11:14
    name = prefix;
    for side = ['L', 'R']
        namelr = strcat(name, int2str(index), side);
        image_file = strcat(namelr, '.jpg');
        label_file = strcat(namelr, '_1stHO.png');
        image = imread(image_file);
        label = imread(label_file);
        
        if strcmp(side, 'L')
            test(:,:,:,index) = image;
            test_labels(:,:,index) = label(:,:,1);
        else
            test(:,:,:,index+1) = image;
            test_labels(:,:,index+1) = label(:,:,1);
        end
    end
end

v1 = randi(20, 1);
v2 = randi(20, 1);
while v2 == v1
    v2 = randi(20, 1);
end
validation(:,:,:,1:2) = training(:,:,:,[v1 v2]);
validation_labels(:,:,1:2) = training_labels(:,:,[v1 v2]);

end

