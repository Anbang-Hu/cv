function [panoImg] = imageStitching(img1, img2, H2to1)
%% function [panoImg] = imageStitching(img1, img2, H2to1)
% Produces panoImg
% inputs
%   img1, img2 - two images to be stitched
%   H2to1 - 3 * 3 homography matrix
% outputs
%   panoImg - panorama image

% Fixed panorama width
panoWidth = 1280; panoHeight = size(img1, 1); panoChannel = 3;
out_size = [panoHeight panoWidth];

% Compute masks (from hint)
mask1 = double(zeros(size(img1)));
mask2 = double(zeros(size(img2)));
mask1(1,:) = 1; mask1(end,:) = 1; mask1(:,1) = 1; mask1(:,end) = 1;
mask2(1,:) = 1; mask2(end,:) = 1; mask2(:,1) = 1; mask2(:,end) = 1;
mask1 = bwdist(mask1, 'cityblock');
mask2 = bwdist(mask2, 'cityblock');
mask1 = mask1 / max(mask1(:));
mask2 = mask2 / max(mask2(:));

% Compute overlap region
img1Region = zeros([out_size panoChannel]);
img1Region(1:size(mask1,1),1:size(mask1,2),:) = 1;
img2Region = warpH(ones(size(mask2)), H2to1, out_size);
img2Region(img2Region > 0) = 1;
overlap = img1Region .* img2Region;

% Specify img1 and img2 parts in panorama
img1Region(1:size(img1,1),1:size(img1,2),:) = img1;
img2Region = warpH(img2, H2to1, out_size);

% Put masks in pano view
panoView1Weight = double(zeros([out_size panoChannel]));
panoView1Weight(1:size(mask1,1),1:size(mask1,2),:) = mask1;
panoView1Weight = panoView1Weight .* overlap;
panoView2Weight = double(warpH(mask2, H2to1, out_size)) .* overlap;

% Compute overlapping part in panorama
overlapRegion = (img1Region .* panoView1Weight + img2Region .* panoView2Weight) ...
               ./ (panoView1Weight + panoView2Weight);
overlapRegion(isnan(overlapRegion)) = 0; % Special treatment for NaN, otherwise can't yield proper image

% Yield the final panorama
panoImg = overlapRegion .* overlap + (img1Region + img2Region) .* (1 - overlap);

end