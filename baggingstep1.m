clc;
clear all;
close all;

%% Set Random Seed for Reproducibility
rng(42); % You can replace 42 with any seed value of your choice

%% Load Data
load('arrhythmia.mat');
Data = X; % Assuming X is the feature matrix from arrhythmia.mat

% Generate index vector
num_samples = size(Data, 1); % Get the number of samples
index = (1:num_samples)'; % Create a column vector with indices from 1 to num_samples

% Append index and label vectors to Data
Data = [Data, index]; % Add index as the last column
Data = [Data, y];     % Add labels as the last column

% Set parameters
per = 0.2;          % 20% of the dataset
NBag = 10;          % Number of bags

%% Call the Bagging function
Bags = Bagging(Data, per, NBag);

%% Save the Bags cell array to a .mat file
save('All10Bags.mat', 'Bags');
