%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

function template = tl_pos(template_images_pos)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
% output:
%     template - [16 x 16 x 9] matrix

% According to TA, ignore the signature description

%% Calculate constants
% n = 1;
n = length(template_images_pos);
h = size(template_images_pos{1}, 1);
w = size(template_images_pos{1}, 2);
numOri = 9;

%% Initialize template
template = zeros([h/8, w/8, numOri]);

%% Accumulate HOG features of positive template images
for i = 1:n
    template = template + hog(template_images_pos{i});
end

%% Compute average of HOG features of pos template images
template = template / n;

end