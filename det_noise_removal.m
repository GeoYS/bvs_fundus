function [ noise_removed ] = det_noise_removal( f, inner_width, outer_width )

    %window size
    n = inner_width;
    m = outer_width;
    band_width = (m-n)/2;
    band_mask = true(m);
    band_mask(band_width+1:m-band_width,band_width+1:m-band_width) = false;
    num_in_band = outer_width^2-inner_width^2;
    
    %finding max band, uk, of each pixel
    f_max_band(:,:,1) = ordfilt2(f(:,:,1), num_in_band, band_mask);
    f_max_band(:,:,2) = ordfilt2(f(:,:,2), num_in_band, band_mask);
    f_max_band(:,:,3) = ordfilt2(f(:,:,3), num_in_band, band_mask);

    %find min_band, vk, of each pixel
    f_min_band(:,:,1) = ordfilt2(f(:,:,1), 1, band_mask);
    f_min_band(:,:,2) = ordfilt2(f(:,:,2), 1, band_mask);
    f_min_band(:,:,3) = ordfilt2(f(:,:,3), 1, band_mask);

    %finding min of max values, so uk-min for each neighbourhood
    min_f_max_band(:,:,1) = ordfilt2(f_max_band(:,:,1), 1, true(n));
    min_f_max_band(:,:,2) = ordfilt2(f_max_band(:,:,2), 1, true(n));
    min_f_max_band(:,:,3) = ordfilt2(f_max_band(:,:,3), 1, true(n));

    %finding max of min values, so vk-max for each neighbourhood
    max_f_min_band(:,:,1) = ordfilt2(f_min_band(:,:,1), n*n, true(n));
    max_f_min_band(:,:,2) = ordfilt2(f_min_band(:,:,2), n*n, true(n));
    max_f_min_band(:,:,3) = ordfilt2(f_min_band(:,:,3), n*n, true(n));

    noise_removed = f;

    for index1 = 1:size(f, 1)
        for index2 = 1:size(f, 2)
            for index3 = 1:size(f, 3)

                if f(index1, index2, index3) > min_f_max_band(index1, index2, index3)
                    noise_removed(index1, index2, index3) = min_f_max_band(index1, index2, index3);
                elseif f(index1, index2, index3) < max_f_min_band(index1, index2, index3)
                    noise_removed(index1, index2, index3) = max_f_min_band(index1, index2, index3);
                else
                    noise_removed(index1, index2, index3) = f(index1, index2, index3);
                end

            end
        end
    end
end

