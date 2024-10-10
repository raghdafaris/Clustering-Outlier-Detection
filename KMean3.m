function XkResults = KMean3(XData, k, label, num_vec, index)
    % Perform k-means clustering
    [class, ~] = kmeans(XData, k);
    
    % Add the label, class, and index columns to XData
    XData(:, num_vec + 1) = label;
    XData(:, num_vec + 2) = class;
    XData(:, num_vec + 3) = index;
    
    % Initialize an array to hold results for all clusters
    XkResults = [];  % Initialize an empty array

    % Assign each data point to the correct cluster and concatenate results
    for j = 1:k
        clusterData = XData(XData(:, num_vec + 2) == j, :);  % Get data points for cluster j
        
        % Create a table for the cluster data with column names
        clusterTable = array2table(clusterData, 'VariableNames', ...
            [strcat('Feature', string(1:num_vec)), 'Label', 'Class', 'Index']);  % Convert to table and add column names
        
        % Concatenate the cluster table to the results array
        XkResults = [XkResults; clusterTable];  % Append cluster data
    end
end