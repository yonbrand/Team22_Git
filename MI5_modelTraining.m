function [test_results] = MI5_modelTraining()
% MI5_LearnModel_Scaffolding outputs a weight vector for all the features
% using a simple multi-class linear approach.
% Add your own classifier (SVM, CSP, DL, CONV, Riemann...), and make sure
% to add an accuracy test.

%% This code is part of the BCI-4-ALS Course written by Asaf Harel
% (harelasa@post.bgu.ac.il) in 2021. You are free to use, change, adapt and
% so on - but please cite properly if published.
%% Folder init if none given
recordingFolder = strcat('C:/BCI4ALS/Team22','/','Good recordings/Yonatan1');
%% Read the features & labels 

FeaturesTrain = cell2mat(struct2cell(load(strcat(recordingFolder,'\FeaturesTrainSelected.mat'))));   % features for train set
LabelTrain = cell2mat(struct2cell(load(strcat(recordingFolder,'\LabelTrain'))));                % label vector for train set

% label vector
LabelTest = cell2mat(struct2cell(load(strcat(recordingFolder,'\LabelTest'))));      % label vector for test set
load(strcat(recordingFolder,'\FeaturesTest.mat'));                                  % features for test set

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Split to train and validation sets %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% test data
testPrediction = classify(FeaturesTest(:,1:9),FeaturesTrain(:,1:9),LabelTrain,'linear');          % classify the test set using a linear classification object (built-in Matlab functionality)
W = LDA(FeaturesTrain,LabelTrain);                                                  % train a linear discriminant analysis weight vector (first column is the constants)

% prediction by softmax
L = [ones(15,1) FeaturesTest] * W';
P = exp(L) ./ repmat(sum(exp(L),2),[1 3]); %probability
[M, I] = max(P');
Acc=sum(I==LabelTest)/length(LabelTest); %accuracy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Add your own classifier %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Test data
% test prediction from linear classifier
test_results = (testPrediction'-LabelTest);                                         % prediction - true labels = accuracy
test_results = (sum(test_results == 0)/length(LabelTest))*100;
disp(['test accuracy - ' num2str(test_results) '%'])

save(strcat(recordingFolder,'\TestResults.mat'),'test_results');                    % save the accuracy results
save(strcat(recordingFolder,'\WeightVector.mat'),'W');                              % save the model (W)

end


