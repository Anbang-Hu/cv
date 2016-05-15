function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r)
%% function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r)
%  Produces locsDoG
%  Input:
%    DoGPyramid - R * C * (L-1) matrix
%    DoGLevels - L-1 vector
%    PrincipleCurvature - R * C * (L-1) matrix where each point contains
%                         curvature ratio
%    th_contrast - constrast threshold
%    th_r - curvature ratio threshold
%    
%  Output:
%    locsDoG - N * 3 (x, y, level)

%  Note: boundary points in DoGPyramid is compared to less than 10 points

L = length(DoGLevels);
locsDoG = [];

% Find local maxima
for i = 1:L
    % spatial comparison
    % shift right
    l = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    l(:,2:end) = DoGPyramid(:,1:end-1,i);
    
    % shift left
    r = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    r(:,1:end-1) = DoGPyramid(:,2:end,i);
    
    % shit down
    u = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    u(2:end,:) = DoGPyramid(1:end-1,:,i);
    
    % shift up
    d = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    d(1:end-1,:) = DoGPyramid(2:end,:,i);
    
    % shift down right
    ul = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    ul(2:end,2:end) = DoGPyramid(1:end-1,1:end-1,i);
    
    % shift down left
    ur = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    ur(2:end,1:end-1) = DoGPyramid(1:end-1,2:end,i);
    
    % shift up right
    dl = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    dl(1:end-1,2:end) = DoGPyramid(2:end,1:end-1,i);
    
    % shift up left
    dr = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    dr(1:end-1,1:end-1) = DoGPyramid(2:end,2:end,i);
    
    % scale comparison
    % top
    t = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    if i ~= 1
        t = DoGPyramid(:,:,i-1);
    end
    
    % top 
    % top shift right
    tl = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tl(:,2:end) = t(:,1:end-1);
    
    % top shift left
    tr = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tr(:,1:end-1) = t(:,2:end);
    
    % top shit down
    tu = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tu(2:end,:) = t(1:end-1,:);
    
    % top shift up
    td = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    td(1:end-1,:) = t(2:end,:);
    
    % top shift down right
    tul = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tul(2:end,2:end) = t(1:end-1,1:end-1);
    
    % top shift down left
    tur = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tur(2:end,1:end-1) = t(1:end-1,2:end);
    
    % top shift up right
    tdl = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tdl(1:end-1,2:end) = t(2:end,1:end-1);
    
    % top shift up left
    tdr = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tdr(1:end-1,1:end-1) = t(2:end,2:end);

    % bottom
    b = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    if i ~= length(DoGLevels)
        b = DoGPyramid(:,:,i+1);
    end

    % bottom shift right
    bl = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bl(:,2:end) = b(:,1:end-1);
    
    % bottom shift left
    br = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    br(:,1:end-1) = b(:,2:end);
    
    % bottom shit down
    bu = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bu(2:end,:) = b(1:end-1,:);
    
    % bottom shift up
    bd = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bd(1:end-1,:) = b(2:end,:);
    
    % bottom shift down right
    bul = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bul(2:end,2:end) = b(1:end-1,1:end-1);
    
    % bottom shift down left
    bur = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bur(2:end,1:end-1) = b(1:end-1,2:end);
    
    % bottom shift up right
    bdl = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bdl(1:end-1,2:end) = b(2:end,1:end-1);
    
    % bottom shift up left
    bdr = -inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bdr(1:end-1,1:end-1) = b(2:end,2:end);
    
    % Compute local max
    localMax = DoGPyramid(:,:,i) > l    & DoGPyramid(:,:,i) > r     & ...
               DoGPyramid(:,:,i) > u    & DoGPyramid(:,:,i) > d     & ...
               DoGPyramid(:,:,i) > ul   & DoGPyramid(:,:,i) > ur    & ...
               DoGPyramid(:,:,i) > dl   & DoGPyramid(:,:,i) > dr    & ...
               DoGPyramid(:,:,i) > t    & DoGPyramid(:,:,i) > b     & ...
               DoGPyramid(:,:,i) > tl   & DoGPyramid(:,:,i) > tr    & ...
               DoGPyramid(:,:,i) > tu   & DoGPyramid(:,:,i) > td    & ...
               DoGPyramid(:,:,i) > tul  & DoGPyramid(:,:,i) > tur   & ...
               DoGPyramid(:,:,i) > tdl  & DoGPyramid(:,:,i) > tdr   & ...
               DoGPyramid(:,:,i) > bl   & DoGPyramid(:,:,i) > br    & ...
               DoGPyramid(:,:,i) > bu   & DoGPyramid(:,:,i) > bd    & ...
               DoGPyramid(:,:,i) > bul  & DoGPyramid(:,:,i) > bur   & ...
               DoGPyramid(:,:,i) > bdl  & DoGPyramid(:,:,i) > bdr   & ...
               abs(DoGPyramid(:,:,i)) > th_contrast & ...
               PrincipalCurvature(:,:,i) <= th_r;

    [Y, X] = find(localMax == 1);
    locsDoG = [locsDoG ; [X Y i*ones(size(X))]];
end

% Find local minima
for i = 1:L
    % spatial comparison
    % shift right
    l = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    l(:,2:end) = DoGPyramid(:,1:end-1,i);
    
    % shift left
    r = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    r(:,1:end-1) = DoGPyramid(:,2:end,i);
    
    % shit down
    u = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    u(2:end,:) = DoGPyramid(1:end-1,:,i);
    
    % shift up
    d = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    d(1:end-1,:) = DoGPyramid(2:end,:,i);
    
    % shift down right
    ul = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    ul(2:end,2:end) = DoGPyramid(1:end-1,1:end-1,i);
    
    % shift down left
    ur = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    ur(2:end,1:end-1) = DoGPyramid(1:end-1,2:end,i);
    
    % shift up right
    dl = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    dl(1:end-1,2:end) = DoGPyramid(2:end,1:end-1,i);
    
    % shift up left
    dr = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    dr(1:end-1,1:end-1) = DoGPyramid(2:end,2:end,i);
    
    % scale comparison
    % top
    t = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    if i ~= 1
        t = DoGPyramid(:,:,i-1);
    end

    % top shift right
    tl = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tl(:,2:end) = t(:,1:end-1);
    
    % top shift left
    tr = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tr(:,1:end-1) = t(:,2:end);
    
    % top shit down
    tu = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tu(2:end,:) = t(1:end-1,:);
    
    % top shift up
    td = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    td(1:end-1,:) = t(2:end,:);
    
    % top shift down right
    tul = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tul(2:end,2:end) = t(1:end-1,1:end-1);
    
    % top shift down left
    tur = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tur(2:end,1:end-1) = t(1:end-1,2:end);
    
    % top shift up right
    tdl = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tdl(1:end-1,2:end) = t(2:end,1:end-1);
    
    % top shift up left
    tdr = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    tdr(1:end-1,1:end-1) = t(2:end,2:end);
    
    % bottom
    b = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    if i ~= length(DoGLevels)
        b = DoGPyramid(:,:,i+1);
    end

    % bottom shift right
    bl = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bl(:,2:end) = b(:,1:end-1);
    
    % bottom shift left
    br = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    br(:,1:end-1) = b(:,2:end);
    
    % bottom shit down
    bu = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bu(2:end,:) = b(1:end-1,:);
    
    % bottom shift up
    bd = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bd(1:end-1,:) = b(2:end,:);
    
    % bottom shift down right
    bul = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bul(2:end,2:end) = b(1:end-1,1:end-1);
    
    % bottom shift down left
    bur = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bur(2:end,1:end-1) = b(1:end-1,2:end);
    
    % bottom shift up right
    bdl = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bdl(1:end-1,2:end) = b(2:end,1:end-1);
    
    % bottom shift up left
    bdr = inf(size(DoGPyramid, 1), size(DoGPyramid, 2));
    bdr(1:end-1,1:end-1) = b(2:end,2:end);
    
    localMin = DoGPyramid(:,:,i) < l    & DoGPyramid(:,:,i) < r     & ...
               DoGPyramid(:,:,i) < u    & DoGPyramid(:,:,i) < d     & ...
               DoGPyramid(:,:,i) < ul   & DoGPyramid(:,:,i) < ur    & ...
               DoGPyramid(:,:,i) < dl   & DoGPyramid(:,:,i) < dr    & ...
               DoGPyramid(:,:,i) < t    & DoGPyramid(:,:,i) < b     & ...
               DoGPyramid(:,:,i) < tl   & DoGPyramid(:,:,i) < tr    & ...
               DoGPyramid(:,:,i) < tu   & DoGPyramid(:,:,i) < td    & ...
               DoGPyramid(:,:,i) < tul  & DoGPyramid(:,:,i) < tur   & ...
               DoGPyramid(:,:,i) < tdl  & DoGPyramid(:,:,i) < tdr   & ...
               DoGPyramid(:,:,i) < bl   & DoGPyramid(:,:,i) < br    & ...
               DoGPyramid(:,:,i) < bu   & DoGPyramid(:,:,i) < bd    & ...
               DoGPyramid(:,:,i) < bul  & DoGPyramid(:,:,i) < bur   & ...
               DoGPyramid(:,:,i) < bdl  & DoGPyramid(:,:,i) < bdr   & ...
               abs(DoGPyramid(:,:,i)) > th_contrast & ...
               PrincipalCurvature(:,:,i) <= th_r;
    [Y, X] = find(localMin == 1);
    locsDoG = [locsDoG ; [X Y i*ones(size(X))]];
end

end