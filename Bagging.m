% Bagging Function
function [Bags] = Bagging(Data, per, NBag)
    % Add an index column to the data
    index = (1:size(Data,1))';
    Data(:,end+1) = index;

    % Create bags
    for i = 1:NBag
        Data1 = Data(randperm(size(Data,1)),:);  % Randomize rows
        m = floor(per * size(Data,1));           % 20% of data size
        train_data = Data1(1:m,:);               % Select the first m rows
        Bags{i} = train_data;                    % Store the bag
    end
end