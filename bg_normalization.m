function [ bg_normalized ] = bg_normalization( f, window )

    %median filtering image 
    %f_median = medfilt3(f, [5, 5, 5]);
    f_R = f(:,:,1);
    f_G = f(:,:,2);
    f_B = f(:,:,3);

    f_median(:,:,1) = medfilt2(f_R, [window window]);
    f_median(:,:,2) = medfilt2(f_G, [window window]);
    f_median(:,:,3) = medfilt2(f_B, [window window]);

    f_median = double(f_median);

    %dividing by median filtered version to alleviate image intensity fluctuation
    bg_normalized = f./f_median;
    
    bg_normalized = fix_values(bg_normalized);
    
end

function [ image ] = fix_values( image )
%Helper function to remove NaN and Inf values. 
%   Input expected to be 2-D matrix.
    
    image(isnan(image)) = 0; % NaN usually a zero divide by zero case.
    
    maxval = max(image(~isinf(image)));
    image(isinf(image)) = maxval; % Threshold to max non-inf value.
end