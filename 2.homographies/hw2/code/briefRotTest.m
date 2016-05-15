% Load image model_chickenbroth.jpg
im1 = imread('../data/model_chickenbroth.jpg');

x = 0:10:359;
y = [];
for angle = 0:10:359
    % Rotate image counterclockwisely
    im2 = imrotate(im1,angle);
    [locs1, desc1] = briefLite(im1);
    [locs2, desc2] = briefLite(im2);
    matches = briefMatch(desc1, desc2);
    y = [y size(matches,1)];
end

% Plot histogram
bar(x, y);