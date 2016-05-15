%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% Implemented according to standard LK in paper:
%% Lucas-Kanade 20 Years On: A Unifying Framework: Part 2
%% Src URL: https://www.ri.cmu.edu/pub_files/pub3/baker_simon_2003_3/baker_simon_2003_3.pdf

function M = LucasKanadeAffine(It, It1)
%% function LucasKanadeAffine(It, It1) computes the transformation matrx
%  Input:
%   It - previous frame
%   It1 - current frame
%  Output:
%   M - transformation from It1 to It, i.e. It = M*It1

%% Initialization
threshold = 0.001;
M = [1 0 0; 0 1 0; 0 0 1];
[X, Y] = meshgrid(1:size(It1,2), 1:size(It1,1));
[It1X, It1Y] = gradient(It1);
DelP = Inf(6,1);
maxIters = 100;
cnt = 0;

%% Iterate till convergence
while (norm(DelP) > threshold)
    % Increment the counter
    cnt = cnt + 1;

    % Compute the argument for imwarp
    tform = affine2d(M');
    
    % Compute warped mask
    mask = imwarp(ones(size(It1)), tform, 'FillValues', 0,...
                  'OutputView', imref2d(size(It1)));
    mask(isnan(mask)) = 0;
    
    % Compute warped image patch
    I = imwarp(It1, tform, 'FillValues', 0,...
              'OutputView', imref2d(size(It1)));
    % There is no need to set nan value to 0, because the following
    % computation will use the mask to set those value to 0
          
    % Compute current image gradient (masked)
    gradIX = It1X .* mask;
    gradIY = It1Y .* mask;

    % Compute steepest descent images (masked)
    gradTWarp = [gradIX(:).*X(:),...
                 gradIY(:).*X(:),...
                 gradIX(:).*Y(:),...
                 gradIY(:).*Y(:),...
                 gradIX(:),...
                 gradIY(:)]...
                 .* repmat(mask(:), 1, 6);

    % Compute Hessian
    H = gradTWarp' * gradTWarp;

    % Compute delta p
    DelP = H \ gradTWarp' * ((I(:) - It(:)) .* mask(:));

    % update parameters
    M(1,1) = M(1,1) + DelP(1);
    M(2,1) = M(2,1) + DelP(2);
    M(1,2) = M(1,2) + DelP(3);
    M(2,2) = M(2,2) + DelP(4);
    M(1,3) = M(1,3) + DelP(5);
    M(2,3) = M(2,3) + DelP(6);
    
    % Break the loop if exceeding max allowed iters
    if cnt > maxIters
        break;
    end
end

end