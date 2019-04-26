function [ path_regions_removed ] = path_region_removal( vessel_domain )
    
    %setting threshold Ts to some value
    Ts = 0.5;
    
    %group image into components
    connectedCompStruct = bwconncomp(vessel_domain);
    connectedComp = connectedCompStruct.PixelIDxList;
    
    L = labelmatrix(connectedCompStruct);
    %https://www.mathworks.com/matlabcentral/answers/397055-how-to-display-and-save-individual-connected-components-of-a-color-image
    for connectedComponent = 1:connectedCompStruct.NumObjects
        %convert connected component to image format
        ccImageMatrix = vessel_domain .* (L == connectedComponent);
        
        %show component image
        figure(connectedComponent+1);
        imshow(ccImageMatrix);
        
        %skeletonize image before finding branchpoints
        ccSkel = bwskel(ccImageMatrix);
        %find branch points
        ccBranchPoints = bwmorph(ccSkel, 'branchpoints');
       
        numBranchpoints = prod(size(find(ccBranchPoints)));
        numTotalPixels = numel(ccImageMatrix);
        rs = double(numBranchpoints/numTotalPixels);
        
        %get covariance matrix of ccImageMatrix
        %this part not done yet
        cov_matrix = class_covariance( class_vectors, class_mean );
        
        eig_values = eig(cov_matrix);
        max_eig = max(eig_values);
        min_eig = min(eig_values);
        
        rA = double(min_eig/max_eig);
        
        %generate convex hull image
        ccConvexHull = bwconvhull(ccImageMatrix);
        numConvexHullPixels = numel(ccConvexHull);
        rc = double(numConvexHullPixels/numTotalPixels);
        
        if rs > Ts
            %pathological region detected
        elseif (rA > Ta) && (rc > Tc)
            %pathological region detected
        else
            %not a pathological region, do nothing
        end

    end
    
    