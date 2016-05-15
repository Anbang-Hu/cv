%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

function template = tl_lda(template_images_pos, template_images_neg, lambda)
% input:
%     template_images_pos - a cell array, each one contains [16 x 16 x 9] matrix
%     template_images_neg - a cell array, each one contains [16 x 16 x 9] matrix
%     lambda - parameter for lda
% output:
%     template - [16 x 16 x 9] matrix 

% According to TA, ignore the signature description

%% Calculate constants
n_pos = length(template_images_pos);
n_neg = length(template_images_neg);
h = size(template_images_pos{1}, 1);
w = size(template_images_pos{1}, 2);
numOri = 9;

%% Initialize positive template
template_pos = zeros([h/8, w/8, numOri]);

%% Accumulate HOG features of positive template images
for i = 1:n_pos
    template_pos = template_pos + hog(template_images_pos{i});
end

%% Compute average of HOG features of pos template images
template_pos = template_pos / n_pos;

%% Initialize positive template
template_neg = zeros([h/8, w/8, numOri]);

%% Accumulate HOG features of positive template images
for i = 1:n_neg
    template_neg = template_neg + hog(template_images_neg{i});
end

%% Compute average of HOG features of pos template images
template_neg = template_neg / n_neg;

%% Compute covariance matrix
S_neg = zeros([h/8, w/8, numOri]);
for i = 1:n_neg
    curr_template_neg = hog(template_images_neg{i}) - template_neg;
    for k = 1:numOri
        S_neg(:,:,k) = curr_template_neg(:,:,k) * curr_template_neg(:,:,k)';
    end
end
S_neg = S_neg / n_neg + lambda * repmat(diag(ones(1,h/8)), [1 1 numOri]);

%% Compute final template
template = zeros([h/8, w/8, numOri]);
for k = 1:numOri
    template(:,:,k) = S_neg(:,:,k) \ (template_pos(:,:,k) - template_neg(:,:,k));
end

end