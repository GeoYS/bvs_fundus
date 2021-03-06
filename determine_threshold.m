function [ threshold, correct_class_index, wrong_class_index ] =...
    determine_threshold( correct_class, wrong_class, target_error_rate, side )
%Compute the threshold value to achieve given error rate.
%   error_rate: ratio of incorrectly classified samples to all classified
%   samples
%   correct_class: feature vector matrix, each column contains feature
%   vector, the last element in the vector is the discriminant value that
%   will determine the threshold. It is assumed to be sorted, ascending, by
%   the decision variable value.
%   wrong_class: same as correct_class
%   side: 'upper' or 'lower' threshold

%The algorithm to determine threshold:
% 1. Initialize class indices to the extremes depending on the threshold 'side'
% 2. Increment/decrement the index of the class such that the current
%    threshold changes the least. If equal, bias the correct class.
% 3. Repeat step 2 until the error rate reaches the target error rate.

%Determine initial class indices
if strcmp(side, 'upper')
    correct_class_index = 1; 
    wrong_class_index = 1;
    dir = +1;
elseif strcmp(side, 'lower')
    correct_class_index = size(correct_class, 2); 
    wrong_class_index = size(wrong_class, 2);
    dir = -1;
else
    disp('Function: determine_threshold. Error: Unknown direction.');
    return;
end

threshold = correct_class(end, correct_class_index);
wrong_was_last = false;
while wrong_class_index < size(wrong_class, 2) && correct_class_index < size(correct_class, 2) 
    
    %Increment index, find new threshold
    if dir*wrong_class(end, wrong_class_index + dir) < dir*correct_class(end, correct_class_index + dir)
        wrong_class_index = wrong_class_index + dir;
        current_threshold = wrong_class(end, wrong_class_index);
        wrong_was_last = true;
    else
        correct_class_index = correct_class_index + dir;
        current_threshold = correct_class(end, correct_class_index);
        wrong_was_last = false;
    end
    
    %Compute error rate with new threshold
    if dir == +1
        num_correct = correct_class_index;
        num_wrong = wrong_class_index;
    else
        num_correct = (1 + correct_class_index - size(correct_class, 2));
        num_wrong = (1 + wrong_class_index - size(wrong_class, 2));
    end
    
    error_rate = num_wrong / (num_wrong + num_correct);
    
    if error_rate < target_error_rate
        threshold = current_threshold;
    end
end

if wrong_was_last
    wrong_class_index = wrong_class_index - dir;
end

end

