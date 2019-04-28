function [ vessel_map ] = segment_image( image, reduction_matrix, stages, features )
%Classify each pixel in the image.
%   - stages is an array containing each stage of the classification
%   network
%   - image is assumed to have been preprocessed already

%features = compute_features(image);
vessel_map = zeros([size(image, 1) size(image, 2)]);

for imgx = 1:size(image, 2)
    for imgy = 1:size(image, 1)
        pixel_features = features(imgy, imgx, :);
        pixel_features = squeeze(pixel_features);
        pixel_features = reduction_matrix*pixel_features(1:end-2);
        for index = 1:length(stages)
            is_last = (index == length(stages));
            result = classify(pixel_features, stages(index), is_last);
            
            if result == 1
                vessel_map(imgy, imgx) = 1;
                break;
            elseif result == 0
                break;
            else
                %Go to next stage, do nothing here.
            end
        end
    end
end

end

