%% Hidden Markov  - cross validation
clear all;
addpath(genpath('HMMall'))

% best is Constant/LowPassFilter/ - not work on reformatted or movingmedian
T = readtable("Constant/LowPassFilter/freeliving-pub.csv");
RSSI = [T.(1), T.(2), T.(3), T.(4)]; RoomIndex = [T.(5)];
clear T;

%% Split the data

O = size(RSSI,2); % I think number of outputs
nex = 2; % I think number of sequences
T = floor(size(RSSI,1)/nex); % I think length of sequences

BinIndex = 1:nex; % Index of each bin - 12 optimal

data = zeros(O,T,nex); %BinIndex(end),elem);
Seq = zeros(T,nex);
for i = BinIndex
    data(:,:,i) = RSSI( T*(i-1)+1:T*i, : )';
    Seq(:,i) = RoomIndex( T*(i-1)+1:T*i );
end
%data = randn(O,T,nex); % RSSI data

M = 1; % Number of gaussians
Q = 4; % Number of states

Prior = normalise(ones(Q,1)); % prior probability of each state
%Trans = eye(Q,Q); % Transition matrix, no probems
Trans = [0.98, 0.01,    0, 0.01;
         0.01, 0.98,    0, 0.01;
            0,    0, 0.99, 0.01;
         0.01, 0.01, 0.01, 0.97];
     
c = cvpartition(BinIndex,'LeaveOut');

MeanErr = zeros(nex,1);
ConfMat = zeros(Q,Q);
for i = 1:c.NumTestSets
    % Extract training and test sets
    TrainData = data(:,:,training(c,i)); TrainLabel = Seq(:,training(c,i));
    TestData  = data(:,:,test(c,i)); TestLabel  = Seq(:,test(c,i));
    
    % Learn means and covariances of Training
    mu0 = zeros(O,Q); % means size [O Q (M)] - column vector of means
    Sigma0 = zeros(O,O,Q); % covariances [O O Q (M)]
    for n = 1:Q
        mu0(:,n) = mean(TrainData(:,TrainLabel==n),2);
        Sigma0(:,:,n) = cov(TrainData(:,TrainLabel==n)');
    end
    
    % Update transition matrix and priors
    [LL, Prior1, Trans1, Mu1, Sigma1,~] = ...
        mhmm_em(TrainData, Prior, Trans, mu0, Sigma0, [], 'max_iter', 10, 'verbose',0, 'adj_mu',0,'adj_Sigma',0);
    
    % Test
    B = mixgauss_prob(TestData, Mu1, Sigma1, ones(Q,1));
    [path] = viterbi_path(Prior, Trans1, B);
    %plot(path-TestLabel')
    MeanErr(i) = sum((path-TestLabel')==0)/length(path);
    ConfMat = ConfMat + confusionmat(TestLabel,path,'order',[1;2;3;4]);
end
ConfMat = ConfMat./sum(ConfMat,2)
mean(MeanErr)*100

% % %%
% % TrainData = data(:,:,1); TrainLabel = Seq(:,1);
% % TestData  = data(:,:,2); TestLabel  = Seq(:,2);
% % 
% % %% Learn means and covariances of Training
% % mu0 = zeros(O,Q); % means size [O Q (M)] - column vector of means
% % Sigma0 = zeros(O,O,Q); % covariances [O O Q (M)]
% % for i = 1:Q
% %     mu0(:,i) = mean(TrainData(:,TrainLabel==i),2);
% %     Sigma0(:,:,i) = cov(TrainData(:,TrainLabel==i)');
% % end
% % 
% % %% Update Means, Covariances, Priors and Transition Matrix
% % 
% % [LL, Prior1, Trans1, Mu1, Sigma1,~] = ...
% %     mhmm_em(TrainData, Prior, Trans, mu0, Sigma0, [], 'max_iter', 10,'adj_mu',0,'adj_Sigma',0);
% % 
% % %% Predict training sequence
% % 
% % B = mixgauss_prob(TestData, Mu1, Sigma1, ones(Q,1));
% % [path] = viterbi_path(Prior, Trans1, B);
% % plot(path-TestLabel')
% % sum((path-TestLabel')==0)/length(path)