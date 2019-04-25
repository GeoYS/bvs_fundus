function [ bg_vectors, v_vectors ] = extract_class_vectors( dataset )
%Reshape the dataset and extract class vectors.
%   dataset: first two dimensions are pixel locations, third dimension is
%   feature index (last index contains class label), fourth dimension is
%   image index

%Reshape such that each column is on data sample (i.e. features for a
%single pixel)
dataset = permute(dataset, [3 1 2 4]);
dataset = reshape(dataset, [size(dataset, 1) size(dataset, 2)*size(dataset, 3)*size(dataset, 4)]);

%Select feature vectors based on class, exclude class label
bg_vectors = dataset(1:end-1, dataset(end, :) == 0); %Class 0 corresponding to background
v_vectors = dataset(1:end-1, dataset(end, :) == 1); %Class 1 corresponding to background

end

