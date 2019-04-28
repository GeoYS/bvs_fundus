function [ class ] = classify( z, stage, is_last )
%Classify the pixel described by the feature vector z.
%   - stage is a struct that is created by compute_classification_stage
eigvec_v = stage.eigvec_v;
eigvec_bg = stage.eigvec_bg;
eigval_v = stage.eigval_v;
eigval_bg = stage.eigval_bg;
v_mean_proj = stage.v_mean_proj;
bg_mean_proj = stage.bg_mean_proj;
T_v = stage.thresh_v;
T_b = stage.thresh_b;

d_v = sum(((eigvec_v*z-v_mean_proj).^2)./eigval_v);
d_bg = sum(((eigvec_bg*z-bg_mean_proj).^2)./eigval_bg);

delta_d = d_v - d_bg;

if delta_d < T_v
    class = 1; %vessel
elseif delta_d > T_b || is_last
    class = 0; %background
else
    class = -1; %unclassified
end

end

