function [panoImg] = imageStitching_noClip(img1, img2, H2to1)
%% function [panoImg] = imageStitching(img1, img2, H2to1)
% Produces panoImg that is not clipped
% inputs
%   img1, img2 - two images to be stitched
%   H2to1 - 3 * 3 homography matrix
% outputs
%   panoImg - panorama image

% Compute scale - translation matrix
img1_tl = [1;1];            img1_tr = [size(img1,2);1]; 
img1_bl = [1;size(img1,1)]; img1_br = [size(img1,2);size(img1,1)]; 
img2_tl = [1;1];            img2_tr = [size(img2,2);1]; 
img2_bl = [1;size(img2,1)]; img2_br = [size(img2,2);size(img2,1)]; 
img1Pts = [img1_tl img1_tr img1_bl img1_br];
img2Pts = [img2_tl img2_tr img2_bl img2_br];

img2Pts = H2to1 * [img2Pts; ones(1,4)];
img2Pts = img2Pts ./ repmat(img2Pts(3,:), 3, 1);

panoLeft   = floor(min([img1Pts(1,:) img2Pts(1,:)]));
panoRight  = ceil(max([img1Pts(1,:) img2Pts(1,:)]));
panoTop    = floor(min([img1Pts(2,:) img2Pts(2,:)]));
panoBottom = ceil(max([img1Pts(2,:) img2Pts(2,:)]));

aspectRatio = (panoRight - panoLeft) / (panoBottom - panoTop);

realPanoWidth = 1330; % Left some space on right
panoWidth  = 1280;
panoHeight = ceil(panoWidth / aspectRatio);

scale = panoWidth / (panoRight - panoLeft);
Tx    = (1 - panoLeft) * scale;
Ty    = (1 - panoTop)  * scale;

M = [scale, 0,     Tx;
     0,     scale, Ty;
     0,     0,     1  ];

out_size = [panoHeight realPanoWidth];

% Compute masks
mask1 = double(zeros(size(img1)));
mask2 = double(zeros(size(img2)));
mask1(1,:) = 1; mask1(end,:) = 1; mask1(:,1) = 1; mask1(:,end) = 1;
mask2(1,:) = 1; mask2(end,:) = 1; mask2(:,1) = 1; mask2(:,end) = 1;
mask1 = bwdist(mask1, 'cityblock');
mask2 = bwdist(mask2, 'cityblock');
mask1 = mask1 / max(mask1(:));
mask2 = mask2 / max(mask2(:));

% Compute overlap region
img1Region = warpH(ones(size(mask1)), M, out_size);
img1Region(img1Region > 0) = 1;
img2Region = warpH(ones(size(mask2)), M*H2to1, out_size);
img2Region(img2Region > 0) = 1;
overlap = img1Region .* img2Region;

% Specify img1, img2 parts in panorama
img1Region = warpH(img1, M, out_size);
img2Region = warpH(img2, M*H2to1, out_size);

% Put masks in pano view
panoView1Weight = double(warpH(mask1, M, out_size)) .* overlap;
panoView2Weight = double(warpH(mask2, M*H2to1, out_size)) .*overlap;

% Compute overlapping part in panorama
overlapRegion = (img1Region .* panoView1Weight + img2Region .* panoView2Weight) ...
               ./ (panoView1Weight + panoView2Weight);
overlapRegion(isnan(overlapRegion)) = 0; % Special treatment for NaN, otherwise can't yield proper image

% Yield the final panorama
panoImg = overlapRegion .* overlap + (img1Region + img2Region) .* (1 - overlap);

end