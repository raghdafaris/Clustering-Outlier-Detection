clc;
clear all;
close all;

% Load DifferenceResults.mat
load('DifferenceResults.mat');

% Number of different K-values and number of bags
[numKValues, numBags] = size(DifferenceResults);

% Initialize variables to collect aggregated outlier scores
aggregatedScores = {};
aggregatedLabels = [];
aggregatedClasses = [];
aggregatedIndices = [];

% Loop through all the bags and K-values to aggregate the outlier scores
for kIndex = 1:numKValues
    for bagIndex = 1:numBags
        if isempty(DifferenceResults{kIndex, bagIndex})
            continue;
        end
        
        % Extract the scores (first 20 columns) and labels, class, index (last 3 columns)
        scores = DifferenceResults{kIndex, bagIndex}(:, 1:20);
        labels = DifferenceResults{kIndex, bagIndex}(:, 21);
        classes = DifferenceResults{kIndex, bagIndex}(:, 22);
        indices = DifferenceResults{kIndex, bagIndex}(:, 23);
        
        % Aggregate the scores, labels, class, and index across different K-values
        aggregatedScores = [aggregatedScores; scores];
        aggregatedLabels = [aggregatedLabels; labels];
        aggregatedClasses = [aggregatedClasses; classes];
        aggregatedIndices = [aggregatedIndices; indices];
    end
end

% Convert aggregated scores to matrix
aggregatedScores = cell2mat(aggregatedScores);

% Calculate the training size as 5% of the total data
totalDataPoints = size(aggregatedScores, 1);
trainingSize = floor(0.099 * totalDataPoints);  % 5% of total data

% Train separate SVM models for each K-value
SVMModels = cell(numKValues, 1);
for kIndex = 1:numKValues
    % Select 5% of the data for training
    randomIndices = randperm(totalDataPoints, trainingSize);
    trainingScores = aggregatedScores(randomIndices, :);
    trainingLabels = aggregatedLabels(randomIndices);
    
    % Train the SVM model for this K-value
    SVMModels{kIndex} = fitcsvm(trainingScores, trainingLabels, 'KernelFunction', 'linear', 'Standardize', true, 'ClassNames', [0,1]);
end

% Perform Majority Voting on the test set
testIndices = setdiff(1:totalDataPoints, randomIndices);  % Indices not used in training
testScores = aggregatedScores(testIndices, :);  % Features for test set
testLabels = aggregatedLabels(testIndices);     % Actual labels for test set

% Initialize prediction storage for all SVMs
predictions = zeros(length(testLabels), numKValues);

% Get predictions from each SVM
for kIndex = 1:numKValues
    predictions(:, kIndex) = predict(SVMModels{kIndex}, testScores);
end

% Apply majority voting: Final prediction is the mode of the SVM predictions
finalPredictions = mode(predictions, 2);

% Evaluate the results with AUC
[~, scores] = predict(SVMModels{1}, testScores);  % Just using one model for the ROC curve
positiveClassScores = scores(:, 2);
[rocX, rocY, T, AUC] = perfcurve(testLabels, positiveClassScores, 1);

% Display AUC
disp(['AUC: ', num2str(AUC)]);

% Plot ROC curve
figure;
plot(rocX, rocY, 'LineWidth', 2);
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title(['ROC Curve (AUC = ' num2str(AUC) ')']);
grid on;

% Plot confusion matrix
confMat = confusionmat(testLabels, finalPredictions);
figure;
confusionchart(confMat);
title('Confusion Matrix');
