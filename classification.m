clear all;
dataFolder = fullfile('C:\Users\13729\Documents\WeChat Files\wxid_a6l9v8idcwc822\FileStorage\File\2023-04');
location = fullfile(dataFolder, 'n8days');
ads = tabularTextDatastore(location);

filepaths = ads.Files;
[~, filenames] = cellfun(@fileparts, filepaths, 'UniformOutput', false);

timeLabels = cellfun(@(x) x(1:4), filenames, 'UniformOutput', false);
timeLabels = categorical(timeLabels);

% 读取所有数据并存储在一个表格中
allData = [];
for i = 1:numel(filepaths)
    T = readtable(filepaths{i});
    T.Label = repmat(timeLabels(i), height(T), 1);
    allData = [allData; T];
end

% 保存处理后的数据到一个新文件
outputFileName = fullfile(dataFolder, 'processedData.csv');
writetable(allData, outputFileName);

% 划分数据为训练集和测试集
cv = cvpartition(height(allData), 'Holdout', 0.2); % 80%训练集，20%测试集
trainData = allData(cv.training,:);
testData = allData(cv.test,:);

% 将训练集和测试集保存到文件中
trainOutputFileName = fullfile(dataFolder, 'trainData.csv');
testOutputFileName = fullfile(dataFolder, 'testData.csv');
writetable(trainData, trainOutputFileName);
writetable(testData, testOutputFileName);
