function [ noise_removed ] = det_noise_removal( f )

    %window size
    n=15;
    f_size = size(f);
    %f = padarray(f, [15,15], 'symmetric', 'both');
    %finding max band, uk, of each pixel
    f_max_band(:,:,1) = nlfilter(f(:,:,1), [n n], @max_band);
    f_max_band(:,:,2) = nlfilter(f(:,:,2), [n n], @max_band);
    f_max_band(:,:,3) = nlfilter(f(:,:,3), [n n], @max_band);

    %find min_band, vk, of each pixel
    f_min_band(:,:,1) = nlfilter(f(:,:,1), [n n], @min_band);
    f_min_band(:,:,2) = nlfilter(f(:,:,2), [n n], @min_band);
    f_min_band(:,:,3) = nlfilter(f(:,:,3), [n n], @min_band);

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
    
%     for i=1:f_size(3)
%         noise_removed(:, :, i) = wkeep(noise_removed, f_size(1:2));
%     end
%     Nkeep=f_size(1);  % size to keep

end

