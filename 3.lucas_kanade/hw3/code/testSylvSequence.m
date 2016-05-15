%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% This script tests LKBasis tracker on sylv sequence

%% Load sylv sequence data
load(fullfile('..','data','sylvseq.mat'));
load(fullfile('..','data','sylvbases.mat'));

%% Little tweak on frames per second
interval = 1;  frames = frames(:,:,1:interval:end);

%% Turn data into double images
frames = im2double(frames);

%% Compute the dimension of frames
[height, width, numFrames] = size(frames);

%% Initialization
rect  = [102; 62; 156; 108];
rectHeight = rect(4) - rect(2);
rectWidth  = rect(3) - rect(1);
rects = zeros(numFrames-1, 4);
rects(1, :) = rect';

rect_ = [102; 62; 156; 108];
rects_ = zeros(numFrames-1, 4);
rects_(1, :) = rect_';

%% Perform for each successive pair of frames
for i = 1:numFrames-1
    % Show current frame
    imshow(frames(:,:,i));
    hold on;
    title(['Frame ' num2str(i)]);
    rectangle('Position', [rect_(1) rect_(2) rectWidth rectHeight], 'EdgeColor', 'green', 'LineWidth', 1.5);
    rectangle('Position', [rect(1) rect(2) rectWidth rectHeight], 'EdgeColor', 'yellow', 'LineWidth', 1.5);
    hold off;
    pause(0.01);
    
    % store required frames
    if i == 1 || i == ceil(200/interval) || i == ceil(300/interval) || i == ceil(350/interval) || i == ceil(400/interval)
        f = figure;
        imshow(frames(:,:,i));
        hold on;
        title(['Frames ' num2str(i)]);
        rectangle('Position', [rect_(1) rect_(2) rectWidth rectHeight], 'EdgeColor', 'green', 'LineWidth', 1.5);
        rectangle('Position', [rect(1) rect(2) rectWidth rectHeight], 'EdgeColor', 'yellow', 'LineWidth', 1.5);
        frame = getframe(f);
        imwrite(frame.cdata, ['../results/sylvseq_' num2str(i) '.png']);
        hold off;
        close(f);
    end
    
    % Run LKBasis tracker
    [u, v] = LucasKanadeBasis(frames(:,:,i), frames(:,:,i+1), rect, bases);
    rect = round([rect(1)+u; rect(2)+v; rect(3)+u; rect(4)+v]);
    rects(i+1, :) = rect';
    
    % Lucas Kanade tracker
    [u_, v_] = LucasKanade(frames(:,:,i), frames(:,:,i+1), rect_);
    rect_ = round([rect_(1)+u_; rect_(2)+v_; rect_(3)+u_; rect_(4)+v_]);
    rects_(i+1, :) = rect_';
end

% show the five required frames
fileNames = {'../results/sylvseq_1.png';...
             '../results/sylvseq_200.png';...
             '../results/sylvseq_300.png';...
             '../results/sylvseq_350.png';...
             '../results/sylvseq_400.png'};

montage(fileNames, 'Size', [1, 5]);

%% Save rects
save('../results/sylvseqrects.mat', 'rects');
