% Problem 1: Image Alignment
%% 1. Load images (all 3 channels)
red = [];
green = [];
blue = [];
% Red channel as 'red'
% Green channel as 'green'
% Blue channel as 'blue'
load('../data/red.mat');
load('../data/green.mat');
load('../data/blue.mat');

%% 2. Find best alignment
% Hint: Lookup the 'circshift' function
rgbResult = alignChannels(red, green, blue);

%% 3. Save result to rgb_output.jpg (IN THE "results" folder)
imwrite(rgbResult, '../results/rgb_output.jpg');