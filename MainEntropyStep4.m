clc;
clear all;
close all;

% Load the KMeansResults.mat cell array
load('KMeansResults.mat');  % Assuming this contains the KMeansResults cell array

% Get the size of KMeansResults
[numKValues, Nbags] = size(KMeansResults);

% Initialize cell arrays to store the entropy results
NormalEntropyResults = cell(numKValues, Nbags);  % Cell array for normal entropies
DeletedEntropyResults = cell(numKValues, Nbags);  % Cell array for deleted entropies
DifferenceResults = cell(numKValues, Nbags);      % Cell array for differences

% Loop over each k value and each bag
for kIndex = 1:numKValues
    for bagIndex = 1:Nbags
        % Access the table and convert it to an array
        if isempty(KMeansResults{kIndex, bagIndex})
            continue;  % Skip empty cells
        end
        
        % Convert the table to an array
        dataArray = table2array(KMeansResults{kIndex, bagIndex});  % Convert table to array
        
        % Extract the class column (assumed to be the second last column)
        classColumn = dataArray(:, end - 1);
        
        % Get the unique classes
        uniqueClasses = unique(classColumn);
        
        % Initialize arrays for storing entropy results
        numDataPoints = size(dataArray, 1);
        numFeatures = size(dataArray, 2) - 3; % Exclude Label, Class, Index
        normalEntropies = zeros(numDataPoints, numFeatures);  % Normal entropies for each data point
        deletedEntropies = zeros(numDataPoints, numFeatures);  % Deleted entropies for each data point
        
        % Loop through each data point to calculate normal and deleted entropy
        for dataIndex = 1:numDataPoints
            % Get the feature vector for the current data point
            currentDataPoint = dataArray(dataIndex, 1:end-3);  % Exclude last 3 columns
            
            % Calculate normal entropy for each feature of the current data point
            normalEntropies(dataIndex, :) = normal_entropy(numFeatures, dataArray(:, 1:end-3), numDataPoints);
            
            % Calculate deleted entropy for each feature of the current data point
            tempData = dataArray([1:dataIndex-1, dataIndex+1:end], 1:end-3);  % Exclude the current data point
            deletedEntropies(dataIndex, :) = deletedEntropy(tempData);
        end
        
        % Store the results in the corresponding cell arrays including the last three columns
        NormalEntropyResults{kIndex, bagIndex} = [normalEntropies, dataArray(:, end-2:end)];  % Include last 3 columns
        DeletedEntropyResults{kIndex, bagIndex} = [deletedEntropies, dataArray(:, end-2:end)];  % Include last 3 columns
        
        % Calculate the differences only for the first 20 columns (features)
        differences = normalEntropies(:, 1:20) - deletedEntropies(:, 1:20);  % Calculate the difference
        
        % Create a new array to store the differences along with labels, class, and index
        combinedResults = [differences, dataArray(:, end-2:end)];  % Combine differences with last 3 columns
        
        % Store the combined results in the DifferenceResults cell array
        DifferenceResults{kIndex, bagIndex} = combinedResults;  % Store combined results
    end
end

% Save the results to .mat files
%save('NormalEntropyResults.mat', 'NormalEntropyResults');
%save('DeletedEntropyResults.mat', 'DeletedEntropyResults');
%save('DifferenceResults.mat', 'DifferenceResults');
