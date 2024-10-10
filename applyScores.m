function ScoredResults = applyScores(DiffResults, numFeatures)
    % Initialize a cell array to store scored results
    ScoredResults = cell(size(DiffResults));
    
    for kIdx = 1:size(DiffResults, 1)
        for bagIdx = 1:size(DiffResults, 2)
            % Access the current difference matrix
            diffMatrix = DiffResults{kIdx, bagIdx};
            if isempty(diffMatrix)
                continue;  % Skip if empty
            end
            
            % Extract the first 20 columns (difference data) and the last 3 (label, class, index)
            data = diffMatrix(:, 1:numFeatures);
            Y = diffMatrix(:, numFeatures+1:end);  % label, class, index
            
            % Count the number of negative values per row in the difference data
            negCount = sum(data < 0, 2);
            
            % Concatenate the negative count with label, class, and index
            scored = [negCount, Y];
            
            % Store the result in the cell array
            ScoredResults{kIdx, bagIdx} = scored;
        end
    end
end
