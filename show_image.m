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
