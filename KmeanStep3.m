clc;
clear all;
close all;

load('LSHData.mat');  % Load the LSHData cell array
Data = LSHData; 

Nbags = 10; 
kValues = [3, 5, 7, 9, 13, 17, 20];  % Define k values
numKValues = length(kValues);  % Number of k values
KMeansResults = cell(numKValues, Nbags);  % Initialize cell array for results

for i = 1:Nbags
    Bag = Data{1, i};  % Take each bag
    num_vec = 20; 
    XData = Bag(:, 1:end - 2);   % Extract data features 
    index = Bag(:, end);          % Extract the index column
    label = Bag(:, end - 1);      % Extract the label
    
    %% K-means Clustering for each k
    for kIndex = 1:numKValues
        k = kValues(kIndex);  % Get current k value
        KMeansResults{kIndex, i} = KMean3(XData, k, label, num_vec, index);  % Store the combined result array in cell
    end
end

% Optional: Save the KMeansResults cell array to a .mat file
save('KMeansResults.mat', 'KMeansResults');

%%_________________________________________________________________________
%% The data are stored as a table in the cell array KMeansResults so 
% if you wish to see the feature data and column names run this code 
% After running the K-means clustering
%K3table1 = KMeans3Results{1};  % Access the first result table

% Convert to array
%dataArrayK3 = table2array(K3table1(:, 1:end-1));  % All numeric columns

% Extract labels
%columnLabels = K3table1.Properties.VariableNames;  % Get the column names

% Display results
%disp('data Array K3:');
%disp(dataArrayK3);
%disp('Column Labels K3:');
%disp(columnLabels);
%%_________________________________________________________________________