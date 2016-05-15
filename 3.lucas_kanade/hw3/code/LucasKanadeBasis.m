%% Student Name: Anbang Hu
%% Andrew ID:    anbangh

%% Implemented according to standard LK in paper:
%% Lucas-Kanade 20 Years On: A Unifying Framework: Part 2
%% Src URL: https://www.ri.cmu.edu/pub_files/pub3/baker_simon_2003_3/baker_simon_2003_3.pdf

function [u, v] = LucasKanadeBasis(It, It1, rect, bases)
%% function LucasKanadeBasis(It, It1, rect, bases) computes the shifting
%  Input:
%   It - previous frame
%   It1 - current frame
%   rect - 4 x 1 rectangle info
%   bases - basis images
%  Output:
%   u, v - shifting for current frame

%% Initialization
threshold = 0.001;
u = 0; v = 0;
W = zeros(size(bases, 3), 1);
DelP = Inf(2,1);
maxIters = 100;
cnt = 0;

%% Compute template
T = It(rect(2):rect(4), rect(1):rect(3));

%% Compute gradient of template
[gradTX, gradTY] = gradient(T);

%% Reshape bases
B = reshape(bases, [size(bases, 1) * size(bases, 2), size(bases, 3)]);

%% Jacobian is identity, no need to compute

%% Compute steepest descent
SD = [gradTX(:), gradTY(:)];

%% Compute Hessian
H = SD' * SD;

%% Iterate till convergence
while (norm(DelP) > threshold)
    % Increment counter
    cnt = cnt + 1;
    
    % Get warped image patch
    [IX, IY] = meshgrid(rect(1)+u:rect(3)+u, rect(2)+v:rect(4)+v);
    I = interp2(It1, IX, IY);

    %% Note:
    % For some weird reason, I had to combine both the update rules in the
    % paper and the update rules I obtained in Q2.1 in order to get the
    % result. I tried to strictly follow the update rules in the paper. The
    % result was not satisfying: for 1 frame apart case, LKBasis has the
    % identical performance as LK; for 5 frames apart case, LKBasis
    % performs even worse. 
    % However, current implementation gives a consistent result: for 1 frame 
    % apart case, LKBasis has the identical performance as LK; for 5 frames 
    % apart case, LKBasis performs better. 
    
    % Compute delta p
    DelP = H \ SD' * (T(:) + B * W - I(:));

    % Update weight
    W = B \ (T(:) + SD * DelP - I(:));

    % Update parameters
    u = u + DelP(1);
    v = v + DelP(2);

    % Break loop if exceeding the max allowed iters
    if cnt > maxIters
        break;
    end
end

end