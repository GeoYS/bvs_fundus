function max_band = max_band(image)
    %function to find max band values of matrix, to be used with nlfilter
    a = -ones(size(image));
    
    for i=1:size(image, 1)
        for j=1:size(image, 2) 
            if (i == 1) 
                a(i, j) = image(i, j);
            elseif (i == size(image, 1)) 
                a(i, j) = image(i, j); 
            elseif (j == 1) 
                a(i, j) = image(i, j);
            elseif (j == size(image, 2)) 
                a(i, j) = image(i, j);
            else 
                %do nothing
            end
        end
    end
    
    max_band = max(a(:));
end

