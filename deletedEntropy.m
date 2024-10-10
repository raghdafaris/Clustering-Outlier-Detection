function deletedEntropies = deletedEntropy(data)
    numRows = size(data, 1);
    numFeatures = size(data, 2);
    deletedEntropies = zeros(1, numFeatures);
    
    for featureIndex = 1:numFeatures
        entropySum = 0;  % To accumulate the deleted entropy for the feature
        
        for sampleIndex = 1:numRows
            % Create a temporary dataset excluding the current sample
            tempData = data;
            tempData(sampleIndex, :) = [];  % Remove the sample
            
            % Calculate the entropy of the feature without the current sample
            x = tempData(:, featureIndex);
            
            % Check if x is empty after removal
            if isempty(x)
                continue;  % Skip if there's no data left
            end
            
            uniqueValues = unique(x);
            
            % Ensure uniqueValues has valid numeric entries
            if isempty(uniqueValues)
                continue;  % Skip if there are no unique values
            end
            
            % Create bin edges for histcounts
            % Using linspace to define bins based on unique values
            binEdges = linspace(min(uniqueValues), max(uniqueValues), numel(uniqueValues) + 1);
            counts = histcounts(x, binEdges);  % Counts based on unique values
            
            % Calculate probabilities
            probabilities = counts / (numRows - 1);  % Adjust for the removed sample
            
            % Calculate the entropy
            entropy = -sum(probabilities(probabilities > 0) .* log2(probabilities(probabilities > 0)));
            entropySum = entropySum + entropy;  % Accumulate
        end
        
        % Calculate the average deleted entropy for the feature
        deletedEntropies(featureIndex) = entropySum / numRows;  % Average over all samples
    end
end