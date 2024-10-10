clc;
clear all;
close all;

%% Set Random Seed for Reproducibility
rng(42); % You can replace 42 with any seed value of your choice

%% Load Bags Data
load('All10Bags.mat');  % Load the bags cell array from step 1
Data = Bags;
NBag = 10;    % Number of bags
num_vec = 20; % Number of random vectors for the LSH

% Initialize the LSHData as a cell array to store results for each bag
LSHData = cell(1, NBag);

for i = 1:NBag
    Bag = Data{1, i};  % Take each bag
    
    XData = Bag(:, 1:end-2);   % Extract data features 
    index = Bag(:, end);       % Extract the index column
    label = Bag(:, end-1);     % Extract the labels
    dim = size(XData, 2);      % Get the number of features (dimensionality)
    len_data = size(XData, 1); % Get the number of data points
    
    %% Generate random vectors for LSH
    vectors = round(2*rand(num_vec, dim) - 1); % Random LSH vectors
    
    % Scaling factor to normalize the bucket values
    a = max(XData(:)) / num_vec;
    
    % Initialize LSH bucket matrix for this bag
    LSHBag = zeros(len_data, num_vec);
    
    % Compute bucket numbers for each data point
    for j = 1:len_data
        D = XData(j, :);  % Extract the j-th data point
        for jj = 1:num_vec
            % Compute the LSH bucket value for each random vector
            LSHBag(j, jj) = floor((D * vectors(jj, :)') / (norm(vectors(jj, :)) * a));
        end
    end
    
    % Combine LSH results with label and index columns
    LSHBag = [LSHBag, label, index];
    
    % Store the LSH results for this bag in the cell array
    LSHData{i} = LSHBag;
end

% Save the LSHData cell array to a .mat file
save('LSHData.mat', 'LSHData');
