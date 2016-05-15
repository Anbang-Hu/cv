function tl_detect_script

%% Load templates
load('template_images_pos.mat');
load('template_images_neg.mat');

ndet = 5;
lambda = 0.05;

%% Load test images
Itest{1} = im2double(rgb2gray(imread('../data/test3.jpg')));
Itest{2} = im2double(rgb2gray(imread('../data/internet2.jpg')));
Label{1} = 'detections on test3.jpg';
Label{2} = 'detections on internet2.jpg';

%% Different detection schemes
% Pos template learning
template = tl_pos(template_images_pos);
for i = 1:length(Itest)
    [x,y,score] = detect(Itest{i},template,ndet);
    draw_detection(Itest{i},ndet,x,y);
    title(['Pos ' Label{i}]);
end

% Pos neg template learning
template = tl_pos_neg(template_images_pos, template_images_neg);
for i = 1:length(Itest)
    [x,y,score] = detect(Itest{i},template,ndet);
    draw_detection(Itest{i},ndet,x,y);
    title(['Pos neg ' Label{i}]);
end

% LDA template learning
template = tl_lda(template_images_pos, template_images_neg, lambda);
for i = 1:length(Itest)
    [x,y,score] = detect(Itest{i},template,ndet);
    draw_detection(Itest{i},ndet,x,y);
    title(['LDA ' Label{i}]);
end

% Multiscale template learning
for i = 1:length(Itest)
    det_res = multiscale_detect(Itest{i}, template, ndet);
    draw_detection(Itest{i},ndet,det_res(:,1),det_res(:,2),det_res(:,3));
    title(['Multiscale ' Label{i}]);
end
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