%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

function ohist = hog(I)
%
% compute orientation histograms over 8x8 blocks of pixels
% orientations are binned into 9 possible bins
%
% I : grayscale image of dimension HxW
% ohist : orinetation histograms for each block. ohist is of dimension (H/8)x(W/8)x9
% TODO

% normalize the histogram so that sum over orientation bins is 1 for each block
%   NOTE: Don't divide by 0! If there are no edges in a block (ie. this counts sums to 0 for the block) then just leave all the values 0. 
% TODO

%% Convert to gray scale image if necessary
if numel(size(I)) == 3
    I = rgb2gray(I);
end

%% Convert to double image
I = im2double(I);

%% Compute magnitude and orientation
[mag, ori] = mygradient(I);

%% Bin orientations
numBins = 9;
binSize = 180/numBins;
% B = zeros(9,1);
index = cell(numBins,1);

for i = 1:numBins
    index{i} = ori >= (90 - i*binSize) & (ori < (90 - (i-1)*binSize)) & ori ~= 0;
%     ori(ori >= (90 - i*binSize) & (ori < (90 - (i-1)*binSize)) & ori ~= 0) = i;
%     temp = ori == i; B(i) = sum(temp(:));
end

for i = 1:numBins
    ori(index{i}) = i;
end

%% Define edge pixel threshold and initialize output
thresh = 0.1 * max(mag(:));
binWidth  = ceil(size(I, 2)/8);
binHeight = ceil(size(I, 1)/8);
ohist = zeros(binHeight, binWidth, numBins);

%% Count elements in each bin
for i = 1:numBins
    C = mag >= thresh & ori == i;
    C = im2col(C, [8 8], 'distinct');
    S = sum(C);
    ohist(:,:,i) = reshape(S, [binHeight binWidth]);
end

%% Normalization
Normalizer = sum(ohist, 3);
Normalizer = repmat(Normalizer, [1 1 numBins]);
ohist = ohist./Normalizer;

%% Take care of divide by 0 case
ohist(isnan(ohist)) = 0;
 