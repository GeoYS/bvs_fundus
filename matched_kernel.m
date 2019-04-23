function [ k ] = matched_kernel( sigma, L, theta, derivative )
%Compute the matched kernel described here: http://repository.ias.ac.in/7783/1/305.pdf
%   theta - rotation angle in degrees

% Sigma at four scales: 0.5, 1, 1.5, 2
% L at four lengths: 9, 11, 13, 15

theta = theta / 180 * pi;

k_length = ceil(sqrt(L^2 + (3*sigma*2)^2)); %max width along diagonal

%Index matrices
cols = ceil(-k_length/2):ceil(-k_length/2)+k_length;
cols = repmat(cols, k_length+1, 1);
rows = transpose(cols);

%Compute kernel corresponding to a 1-D Gaussian that is repeated and then
%rotated
k_mask = ((abs(rows*cos(theta)+cols*sin(theta)) <= (3*sigma)) .* (abs(-rows*sin(theta)+cols*cos(theta)) <= (L/2)));

if derivative
    k =  k_mask .* (rows*cos(theta)+cols*sin(theta)).^2*exp(-(rows*cos(theta)+cols*sin(theta)).^2 / (2*sigma^2));    
else
    k =  k_mask .* -exp(-(rows*cos(theta)+cols*sin(theta)).^2 / (2*sigma^2));
end

mean = sum(sum(k))/sum(sum(k_mask));

k = k - mean*(k_mask);

k = round(10*k);

end

