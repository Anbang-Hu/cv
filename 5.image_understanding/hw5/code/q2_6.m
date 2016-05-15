function q2_6

% %% Get templates
% num_pos = 5;
% template_dim = 128;
% Itrain = cell([num_pos,1]);
% Itrain{1} = im2double(rgb2gray(imread('../data/frontface1.jpg')));
% Itrain{2} = im2double(rgb2gray(imread('../data/frontface2.jpg')));
% Itrain{3} = im2double(rgb2gray(imread('../data/frontface3.jpg')));
% Itrain{4} = im2double(rgb2gray(imread('../data/frontface4.jpg')));
% Itrain{5} = im2double(rgb2gray(imread('../data/frontface5.jpg')));
% 
% %% User selects five positive templates
% frontface_template_images_pos = cell([num_pos,1]);
% for i = 1:num_pos
%     imshow(Itrain{i});
%     rect = round(getrect);
%     frontface_template_images_pos{i} = resizePatch(Itrain{i}, rect, template_dim);
% end
% 
% load('template_images_neg.mat');
% frontface_template_images_neg = template_images_neg;
% 
% %% Save frontface_templates
% save('frontface_template_images_pos.mat', 'frontface_template_images_pos');
% save('frontface_template_images_neg.mat', 'frontface_template_images_neg');
% 
% %% Visualize positive templates
% figure
% for i = 1:length(frontface_template_images_pos)
%     subplot(2,3, i), subimage(frontface_template_images_pos{i}); 
% end

% num_pos = 5;
% template_dim = 128;
% Itrain = cell([num_pos,1]);
% Itrain{1} = im2double(rgb2gray(imread('../data/sideface1.jpg')));
% Itrain{2} = im2double(rgb2gray(imread('../data/sideface2.jpg')));
% Itrain{3} = im2double(rgb2gray(imread('../data/sideface3.jpg')));
% Itrain{4} = im2double(rgb2gray(imread('../data/sideface4.jpg')));
% Itrain{5} = im2double(rgb2gray(imread('../data/sideface5.jpg')));
% 
% %% User selects five positive templates
% sideface_template_images_pos = cell([num_pos,1]);
% for i = 1:num_pos
%     imshow(Itrain{i});
%     rect = round(getrect);
%     sideface_template_images_pos{i} = resizePatch(Itrain{i}, rect, template_dim);
% end
% 
% load('template_images_neg.mat');
% sideface_template_images_neg = template_images_neg;
% 
% %% Save frontface_templates
% save('sideface_template_images_pos.mat', 'sideface_template_images_pos');
% save('sideface_template_images_neg.mat', 'sideface_template_images_neg');
% 
% %% Visualize positive templates
% figure
% for i = 1:length(sideface_template_images_pos)
%     subplot(2,3, i), subimage(sideface_template_images_pos{i}); 
% end

load('frontface_template_images_pos.mat');
load('frontface_template_images_neg.mat');
load('sideface_template_images_pos.mat');
load('sideface_template_images_neg.mat');

ndet = 5;
lambda = 0.05;

%% Load test images
Itest = im2double(rgb2gray(imread('../data/testface2.jpg')));
% 
% %% Different detection schemes
% % Pos template learning
% template = tl_pos(frontface_template_images_pos);
% [x,y,score] = detect(Itest,template,ndet);
% draw_detection(Itest,ndet,x,y);
% title(['Pos ']);
% 
% % Pos neg template learning
% template = tl_pos_neg(frontface_template_images_pos, frontface_template_images_neg);
% [x,y,score] = detect(Itest,template,ndet);
% draw_detection(Itest,ndet,x,y);
% title(['Pos neg ']);
% 
% % LDA template learning
% template = tl_lda(frontface_template_images_pos, frontface_template_images_neg, lambda);
% [x,y,score] = detect(Itest,template,ndet);
% 
% draw_detection(Itest,ndet,x,y);
% title(['LDA ']);
% 
% % Multiscale template learning
% det_res = multiscale_detect(Itest, template, ndet);
% draw_detection(Itest,ndet,det_res(:,1),det_res(:,2),det_res(:,3));
% title(['Multiscale ']);

% template = tl_lda(sideface_template_images_pos, sideface_template_images_neg, lambda);
% [x,y,score] = detect(Itest,template,ndet);
% 
% draw_detection(Itest,ndet,x,y);
% title(['LDA ']);

% Multiscale template learning
% det_res = multiscale_detect(Itest, template, ndet);
% draw_detection(Itest,ndet,det_res(:,1),det_res(:,2),det_res(:,3));
% title(['Multiscale ']);


% Mixture
template1 = tl_lda(frontface_template_images_pos, frontface_template_images_neg, lambda);
template2 = tl_lda(sideface_template_images_pos, sideface_template_images_neg, lambda);
template{1} = template1;
template{2} = template2;
det_res = multiscale_detect_mixture(Itest, template, ndet);
draw_detection(Itest,ndet,det_res(:,1),det_res(:,2),det_res(:,3));
title(['Multiscale ']);

end

function draw_detection(Itest, ndet,x,y,scale)
% please complete this function to show the detection results
figure; clf; imshow(Itest);
if nargin == 4
    for i = 1:ndet
      % draw a rectangle.  use color to encode confidence of detection
      %  top scoring are green, fading to red
      hold on; 
      h = rectangle('Position',[x(i)-64 y(i)-64 128 128],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
      hold off;
    end
else
    for i = 1:ndet
      % draw a rectangle.  use color to encode confidence of detection
      %  top scoring are green, fading to red
      hold on; 
      dim = ceil(128/scale(i));
      h = rectangle('Position',[x(i)-floor(dim/2) y(i)-floor(dim/2) dim dim],'EdgeColor',[(i/ndet) ((ndet-i)/ndet)  0],'LineWidth',3,'Curvature',[0.3 0.3]); 
      hold off;
    end
end
end

function patch = resizePatch(I, rect, template_dim)
x = rect(1);
y = rect(2);
w = rect(3);
h = rect(4);
xmax = size(I, 2);
ymax = size(I, 1);

diff = floor(abs(w - h)/2);
if w > h
    patch = zeros(w,w);
    patch(diff+1:diff+h, :) = I(y+1:y+h, x:x+w-1);
    
    % Fill in upper portion
    if y - diff >= 0
        patchUpRange = 1:diff;
        ImageUpRange = y-diff+1:y;
    else
        patchUpRange = diff-y+1:diff;
        ImageUpRange = 1:y;
    end
    patch(patchUpRange, :) = I(ImageUpRange, x:x+w-1);
    
    % Fill in lower portion
    y = y+h;
    newDiff = w - (diff+h);
    if y + newDiff <= ymax
        patchLowerRange = diff+h+1:diff+h+newDiff;
        ImageLowerRange = y+1:y+newDiff;
    else
        patchLowerRange = diff+h+1:diff+h+ymax-y;
        ImageLowerRange = y+1:ymax;
    end
    patch(patchLowerRange, :) = I(ImageLowerRange, x:x+w-1);
    
else
    patch = zeros(h,h);
    patch(:, diff+1:diff+w) = I(y:y+h-1, x+1:x+w);
    
    % Fill in left portion
    if x - diff >= 0
        patchLeftRange = 1:diff;
        ImageLeftRange = x-diff+1:x;
    else
        patchLeftRange = diff-x+1:diff;
        ImageLeftRange = 1:x;
    end
    patch(:, patchLeftRange) = I(y:y+h-1, ImageLeftRange);
    
    % Fill in right portion
    x = x+w;
    newDiff = h - (diff+w);
    if x + newDiff <= xmax
        patchRightRange = diff+w+1:diff+w+newDiff;
        ImageRightRange = x+1:x+newDiff;
    else
        patchRightRange = diff+w+1:diff+w+xmax-x;
        ImageRightRange = x+1:xmax;
    end
    patch(:, patchRightRange) = I(y:y+h-1, ImageRightRange);
end

patch = imresize(patch, [template_dim template_dim]);
end
