%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% Implemented according to Inverse Compositional Algorithm in paper:
%% Lucas-Kanade 20 Years On: A Unifying Framework: Part 1
%% Src URL: https://www.ri.cmu.edu/pub_files/pub3/baker_simon_2002_3/baker_simon_2002_3.pdf

function [u, v] = LucasKanade(It, It1, rect)
%% function LucasKanadeAffine(It, It1) computes the shifting
%  Input:
%   It - previous frame
%   It1 - current frame
%   rect - 4 x 1 rectangle info
%  Output:
%   u, v - shifting for current frame

%% Initialization
threshold = 0.001;
u = 0; v = 0;
DelP = Inf(2,1);
maxIters = 100;
cnt = 0;

%% Compute template
T = It(rect(2):rect(4), rect(1):rect(3));

%% Compute gradient of template
[gradTX, gradTY] = gradient(T);

%% Jacobian is identity, no need to compute

%% compute steepest descent images
gradTWarp = [gradTX(:) gradTY(:)];

%% Compute Hessian
H = gradTWarp' * gradTWarp;

%% Iterate till convergence
while (norm(DelP) > threshold)
    % Increment counter
    cnt = cnt + 1;
    
    % Compute warped image patch
    [IX, IY] = meshgrid(rect(1)+u:rect(3)+u, rect(2)+v:rect(4)+v);
    I = interp2(It1, IX, IY);

    % Compute the error
    DelP = H \ gradTWarp' * (T(:) - I(:)); % There seems to be a typo in the paper

    % Update parameters
    u = u + DelP(1);
    v = v + DelP(2);
    
    % Break th loop if exceeding the max allowed iters
    if cnt > maxIters
        break;
    end
end

end
    
