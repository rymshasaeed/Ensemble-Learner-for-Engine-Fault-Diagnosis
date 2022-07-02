clc, clearvars, close all

% Read the features data
data = readtable('Features.xlsx');

% Extract predictors and response variables
predictors = data.Properties.VariableNames(1:end-1);
X = data(:, predictors);
response = data.Properties.VariableNames(end);
Y = table2array(data(:, response));

% Shuffle the data
rng(394)
idx = randperm(size(data, 1));
X = X(idx, :);
Y = Y(idx, :);

% Set up holdout validation
cvp = cvpartition(Y, 'Holdout', 0.3);

% Partition the data
X_train = X(cvp.training, :);
Y_train = Y(cvp.training, :);
X_test = X(cvp.test, :);
Y_test = Y(cvp.test, :);

% Create decision trees template
template = templateTree('MaxNumSplits', length(Y)-1);

% Fit k-fold ensemble of learners for classification
k = 10;
iterations = 100;
model = fitcensemble(X_train, Y_train, ...
                     'Method', 'Bag', ...,
                     'Type', 'classification', ...
                     'NumLearningCycles', iterations, ...
                     'Learners', template, ...
                     'ClassNames', unique(Y), ...
                     'KFold', k);

% Classification loss
cost = kfoldLoss(model, 'Mode', 'cumulative');

% Plot the cumulative, 10-fold cross-validated, misclassification rate.
figure;
plot(cost)
grid on
xlabel('Learning cycle')
ylabel('10-fold Misclassification rate')
title(['Generalization error: ', num2str(cost(end))])
legend('Model performance')

% Export trained model to local directory
save('model.mat', 'model')

% Make predictions
Y_pred = predict(model.Trained{1}, X_test);
    
% Compute model accuracy
p = Y_pred == Y_test;
accuracy = sum(p) / numel(p);

% Plot confusion matrix
figure;
C = confusionchart(Y_test, Y_pred, ...
                   'RowSummary','row-normalized', ...
                   'ColumnSummary','column-normalized');
title({'Confusion matrix - Bagged Trees', ['Accuracy: ', num2str(accuracy*100), '%']})