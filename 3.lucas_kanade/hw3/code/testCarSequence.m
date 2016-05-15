%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% This script tests baseline tracker on car sequence

%% Load car sequence data
load(fullfile('..','data','carseq.mat')); % variable name = frames. 

%% Turn the data into double images
frames = im2double(frames);

%% Compute dimensions of frames
[height, width, numFrames] = size(frames);

%% Initialization
rect  = [60; 117; 146; 152];
rectHeight = rect(4) - rect(2);
rectWidth  = rect(3) - rect(1);
rects = zeros(numFrames-1, 4);
rects(1, :) = rect';

%% Perform for each successive pair of frames
for i = 1:numFrames-1
    
    % Show images
    imshow(frames(:,:,i));
    hold on;
    title(['Frame ' num2str(i)]);
    rectangle('Position', [rect(1) rect(2) rectWidth rectHeight], 'EdgeColor', 'yellow', 'LineWidth', 3);
    hold off;
    pause(0.01);
    
    % Store required frames
    if i == 1 || i == 100 || i == 200 || i == 300 || i == 400
        f = figure;
        imshow(frames(:,:,i));
        hold on;
        title(['Frame ' num2str(i)]);
        rectangle('Position', [rect(1) rect(2) rectWidth rectHeight], 'EdgeColor', 'yellow', 'LineWidth', 3);
        frame = getframe(f);
        imwrite(frame.cdata, ['../results/carseq_' num2str(i) '.png']);
        hold off;
        close(f);
    end
    
    % Run LK tracker
    [u, v] = LucasKanade(frames(:,:,i), frames(:,:,i+1), rect);
    rect = round([rect(1)+u; rect(2)+v; rect(3)+u; rect(4)+v]);
    rects(i+1, :) = rect';
end

% Show the five required frames
fileNames = {'../results/carseq_1.png';...
             '../results/carseq_100.png';...
             '../results/carseq_200.png';...
             '../results/carseq_300.png';...
             '../results/carseq_400.png'};
montage(fileNames, 'Size', [1, 5]);

% Save the rects
save(fullfile('..','results','carseqrects.mat'),'rects');
