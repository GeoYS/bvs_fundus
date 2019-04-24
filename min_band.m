function min_band = min_band(image)
    %function to find min band of matrix, to be used with nlfilter
    a = Inf(size(image));
    
    for i=1:size(image, 1)
        for j=1:size(image, 2) 
            if (i == 1) 
                a(i, j) = image(i, j);
            elseif (i == size(image, 1)) 
                a(i, j) = image(i, j); 
            elseif (j == 1) 
                a(i, j) = image(i, j);
            elseif (j == size(image, 2) ) 
                a(i, j) = image(i, j);
            else 
                %do nothing
            end
        end
    end
    
    min_band = min(a(:));
end
