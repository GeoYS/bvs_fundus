function [ reg_eigvals ] = regularize_eigvals( eigvals, reg_param )
%Compute the regularized eigenspace as per https://www.sciencedirect.com/science/article/pii/S0031320318304199#bib0043

alpha = eigvals(1)*eigvals(reg_param)*(reg_param-1)/(eigvals(1)-eigvals(reg_param));
beta = (reg_param*eigvals(reg_param)-eigvals(1)) / (eigvals(1)-eigvals(reg_param));

for index = reg_param:length(eigvals)
    eigvals(index) = alpha / (index - beta);
end

reg_eigvals = eigvals;

end

