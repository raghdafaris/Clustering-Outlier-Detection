clc;
clear all;
close all;

% Load the DifferenceResults.mat cell array
load('DifferenceResults.mat');  % Assuming this contains the DifferenceResults cell array

% Define the parameters
numFeatures = 20;  % The number of feature columns (first 20 columns)

% Apply scoring function
ScoredResults = applyScores(DifferenceResults, numFeatures);

% Optionally, save the results to a .mat file
save('ScoredResults.mat', 'ScoredResults');
