%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% This script tests aerial sequence

%% Load aerial sequence data
load(fullfile('..','data','aerialseq.mat'));

%% Turn the data into double image
frames = im2double(frames);

%% Perform for each successive pair of frames
for i = 1:size(frames,3)-1
    %% Compute moving objects
    mask = SubtractDominantMotion(frames(:,:,i), frames(:,:,i+1));
    movObj = zeros(size(mask, 1), size(mask, 2), size(mask, 3));
    movObj(:,:,1) = mask;
    
    %% Compute imfused image
    Img = imfuse(movObj, frames(:,:,i+1), 'ColorChannels',[1 2 2]);

    %% Show images without closing the window
    imshow(Img);
    hold on;
    title(['Frame ' num2str(i+1)]);
    hold off;
    pause(0.005);

    %% Write the required frames
    if i+1 == 30 || i+1 == 60 || i+1 == 90 || i+1 == 120
       imwrite(Img, ['../results/aerialseq_' num2str(i+1) '.png']);
    end
end

%% Display the four required images in montage
fileNames = {'../results/aerialseq_30.png';...
             '../results/aerialseq_60.png';...
             '../results/aerialseq_90.png';...
             '../results/aerialseq_120.png'};
montage(fileNames, 'Size', [1, 4]);
