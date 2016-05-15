%% Student Name: Anbang Hu
%% Student AndrewID: anbangh

%% Test script for Q2.3

%% Load fundamental matrix and intrinsics
load('q2_1.mat');
load('../data/intrinsics.mat');

%% Compute essential matrix
E = essentialMatrix(F, K1, K2)
