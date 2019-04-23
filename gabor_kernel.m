function [ k ] = gabor_kernel( sigma, angle )
%Values as specified here: https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0038
ellip = 0.5;
phase = 0;
wavelength = 0.8*pi*sigma; 

max_dist = ceil(3*sigma); % values beyond 3*sigma are negligible
k_length = 2*max_dist + 1;

%Index matrices
cols = -max_dist:max_dist;
cols = repmat(cols, k_length, 1);
rows = transpose(cols);

%Rotated coordinates
x_tick = cols*cos(angle) + rows*sin(angle);
y_tick = -cols*sin(angle) + rows*cos(angle);

%Computing Gaussian kernel
k = exp(-(x_tick.^2 + ellip*y_tick.^2)/(2*sigma^2));

%mulitply by the complex sinusoidal
k = k.*exp(1i*(2*pi*x_tick/wavelength + phase));

end

