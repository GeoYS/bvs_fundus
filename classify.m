function [ class ] = classify( z, eigvec_v, eigvec_bg, eigval_v, eigval_bg, v_mean_proj, bg_mean_proj, T_v, T_b, is_last )

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

