function [ path_regions_removed ] = remove_path_regions( vessel_bw, T_s, T_A, T_c, erode_and_dilate )
%Remove pathological regions as per https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0046

path_regions_removed = vessel_bw;

if erode_and_dilate
    structural_element = strel('square', 3);
    vessel_bw = imerode(vessel_bw, structural_element);
end

%Group image vessel pixels into components
connected_components = bwconncomp(vessel_bw);
labelled_image = labelmatrix(connected_components);

for cc_index = 1:connected_components.NumObjects
    %Convert connected component to image format
    cc_image = (labelled_image == cc_index);
    if erode_and_dilate
        cc_image = imdilate(cc_image, structural_element);
    end

    %Skeletonize image before finding branchpoints
    cc_skel = bwmorph(cc_image, 'skel', Inf);
    %find branch points
    cc_branchpoints = bwmorph(cc_skel, 'branchpoints');

    num_branchpoints = nnz(cc_branchpoints);
    num_total_pixels = nnz(cc_image);
    r_s = double(num_branchpoints)/num_total_pixels;

    %Get covariance matrix of vessel pixel locations
    [y, x] = find(cc_image);
    cov_matrix = cov( [x y] );

    eig_values = eig(cov_matrix);
    max_eig = max(eig_values);
    min_eig = min(eig_values);

    r_A = double(min_eig)/max_eig;

    %Generate convex hull image
    cc_convex_hull = bwconvhull(cc_image);
    num_convex_hull_pixels = nnz(cc_convex_hull);
    r_c = double(num_total_pixels)/num_convex_hull_pixels;

    if r_s > T_s
        %Pathological region detected
        path_regions_removed(cc_image) = 0;
    elseif (r_A > T_A) && (r_c > T_c)
        %Pathological region detected
        path_regions_removed(cc_image) = 0;
    else
        %Not a pathological region, do nothing
    end
end

end %remove_path_regions