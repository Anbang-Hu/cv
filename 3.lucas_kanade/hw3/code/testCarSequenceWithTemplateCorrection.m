%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

% Extra credit.  You can leave this untouched if you're not doing the EC.
%% This script tests baseline tracker with template drifting correction on car sequence

%% Load car sequence data
load(fullfile('..','data','carseq.mat')); % variable name = frames. 

%% Turn data into double images
frames = im2double(frames);

%% Compute the dimension of frames
[height, width, numFrames] = size(frames);

%% Initialization
rect  = [60; 117; 146; 152];
rectHeight = rect(4) - rect(2);
rectWidth  = rect(3) - rect(1);
rects = zeros(numFrames-1, 4);
rects(1, :) = rect';

f = figure;
imshow(frames(:,:,1));
hold on;
title(['Frame ' num2str(1)]);
rectangle('Position', [rect(1) rect(2) rectWidth rectHeight], 'EdgeColor', 'green', 'LineWidth', 3);
frame = getframe(f);
imwrite(frame.cdata, ['../results/carseq_template_corrected_' num2str(1) '.png']);
hold off;
pause(1); % wait for 1 second to see the effect
close(f);

%% Run LK tracker
[u_, v_] = LucasKanade(frames(:,:,1), frames(:,:,2), rect);
rect = [rect(1)+u_; rect(2)+v_; rect(3)+u_; rect(4)+v_];
rects(2, :) = rect';

u = 0; v = 0;

%% Perform for each successive pair of frames
for i = 2:numFrames-1
    % store required frames
    if mod(i, 100) == 0
        f = figure;
        imshow(frames(:,:,i));
        hold on;
        title(['Frame ' num2str(i)]);
        rectangle('Position', [rect(1) rect(2) rectWidth rectHeight], 'EdgeColor', 'green', 'LineWidth', 3);
        frame = getframe(f);
        imwrite(frame.cdata, ['../results/carseq_template_corrected_' num2str(i) '.png']);
        hold off;
        pause(1); % wait for 1 second to see the effect
        close(f);
    end
    
    % Run LK with template correction
    [u, v, u_, v_] = LucasKanadeWithTemplateCorrection(frames(:,:,i), frames(:,:,i+1), rect, frames(:,:,1), rects(1,:)', u, v, u_, v_);
    rect = round([rect(1)+u_; rect(2)+v_; rect(3)+u_; rect(4)+v_]);
    rects(i+1, :) = rect';
end

%% Show the five required frames
fileNames = {'../results/carseq_template_corrected_1.png';...
             '../results/carseq_template_corrected_100.png';...
             '../results/carseq_template_corrected_200.png';...
             '../results/carseq_template_corrected_300.png';...
             '../results/carseq_template_corrected_400.png'};
montage(fileNames, 'Size', [1, 5])

%% Save the rects
save('../results/carseqrects-wcrt.mat', 'rects');

