function [ threshold] =...
    determine_threshold_last( vessel_class, bg_class)
%Compute the threshold value to achieve minimum error rate with binary
%decision.
%   error_rate: ratio of incorrectly classified samples to all classified
%   samples
%   vessel_class: feature vector matrix, each column contains feature
%   vector, the last element in the vector is the discriminant value that
%   will determine the threshold. It is assumed to be sorted, ascending, by
%   the decision variable value.
%   bg_class: same as correct_class

%The algorithm to determine threshold:
% 1. Initialize class indices to 1
% 2. Increment the index of the class such that the current
%    threshold changes the least. If equal, incr index of correct class.
% 3. Repeat step 2 until the error rate reaches the target error rate.

vessel_class_index = 1; 
bg_class_index = 1;
dir = +1;
    
min_error_rate = 0;
current_threshold = vessel_class(end, vessel_class_index);
threshold = current_threshold;
while vessel_class_index <= size(vessel_class, 2) && bg_class_index <= size(bg_class, 2)
    %Increment index, find new threshold
    if bg_class(end, bg_class_index + dir) < vessel_class(end, vessel_class_index + dir)
        bg_class_index = bg_class_index + dir;
        current_threshold = bg_class(end, bg_class_index);
    else
        vessel_class_index = vessel_class_index + dir;
        current_threshold = vessel_class(end, vessel_class_index);
    end
    
    %Compute error rate with new threshold
    num_wrong = bg_class_index + (size(vessel_class, 2) - vessel_class_index);
    num_total = (size(bg_class, 2) + size(vessel_class, 2));
    
    current_error_rate = num_wrong / num_total;
    
    if current_error_rate < min_error_rate
        min_error_rate = current_error_rate;
        threshold = current_threshold;
    end        
end


end

