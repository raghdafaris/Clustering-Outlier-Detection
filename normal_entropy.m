function entropies = normal_entropy(numFeatures, data, numRows)
    entropies = zeros(1, numFeatures);
    
    for featureIndex = 1:numFeatures
        % Extract the feature data
        x = data(:, featureIndex);
        
        % Get unique values
        uniqueValues = unique(x);
        
        % Calculate the probability of each unique value
        counts = histcounts(x, [uniqueValues; max(uniqueValues)+1]);  % Include last bin
        probabilities = counts / numRows;
        
        % Calculate the entropy using the formula
        entropies(featureIndex) = -sum(probabilities(probabilities > 0) .* log2(probabilities(probabilities > 0)));
    end
end