function [ bg_normalized ] = bg_normalization( f )

    %median filtering image 
    %f_median = medfilt3(f, [5, 5, 5]);
    f_R = f(:,:,1);
    f_G = f(:,:,2);
    f_B = f(:,:,3);

    f_median(:,:,1) = medfilt2(f_R, [25 25]);
    f_median(:,:,2) = medfilt2(f_G, [25 25]);
    f_median(:,:,3) = medfilt2(f_B, [25 25]);

    f_median = double(f_median);

    %dividing by median filtered version to alleviate image intensity fluctuation
    bg_normalized = f./f_median;

end

