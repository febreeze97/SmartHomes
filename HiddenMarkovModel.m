%% Random Forests - cross validation
clear all;

%% Import Data

[~,~,~,RoomIndex,~] = OpenCSVFile("Test","freeliving-pub",0,0);
Data = readtable('Random_Forest_Data.csv');
Pred = Data.(2); Pred(1) = []; clear Data;

%% Split data into bins
BinIndex = 1:12; % Index of each bin

elem = floor(length(RoomIndex)/BinIndex(end));
Stat = zeros(BinIndex(end),elem); Seq = Stat;
for i = BinIndex
    Stat(i,:) = RoomIndex(elem*(i-1)+1:elem*i);
    Seq(i,:) = Pred(elem*(i-1)+1:elem*i);
end
%clear RoomIndex; clear Pred;


%% Cross Validation

PSEUDO = [ 0.99, 0.005,     0, 0.005;
          0.005,  0.99,     0, 0.005;
              0,     0, 0.995, 0.005;
          0.005, 0.005, 0.005, 0.985];

OrigConf = zeros(4,4); UpConf = zeros(4,4);
      
%c = cvpartition(BinIndex,'kFold',10);
%c = cvpartition(BinIndex,'HoldOut',0.7);
%c = cvpartition(BinIndex,'LeaveOut');
c = cvpartition(BinIndex,'resubstitution');
for i = 1:c.NumTestSets
    TrainStat = Stat( training(c,i), :);
    TrainSeq  = Seq(  training(c,i), :);
    TestStat  = Stat(     test(c,i), :);
    TestSeq   = Seq(      test(c,i), :);
    
    [TRAN, EMIS] = hmmestimate(TrainSeq,TrainStat,'Pseudotransitions',PSEUDO);
    %[TRAN, EMIS] = hmmestimate(TrainSeq,TrainStat);
    
    PredStat = zeros(size(TestStat));
    for n = 1:size(TestSeq,1)
        PredStat(n,:) = hmmviterbi(TestSeq(n,:),TRAN,EMIS);
    end
    %TestStat = TestStat'; TestSeq = TestSeq'; PredStat = PredStat';
    OrigConf = OrigConf + confusionmat(TestStat(:),TestSeq(:),'order',[1;2;3;4]);
    UpConf = UpConf + confusionmat(TestStat(:),PredStat(:),'order',[1;2;3;4]);
end

OrigAcc = sum(diag(OrigConf))/sum(sum(OrigConf))
UpdatedAcc =  sum(diag(UpConf))/sum(sum(UpConf))
OrigConf = OrigConf./sum(OrigConf,2)
UpConf = UpConf./sum(UpConf,2)

%% Non-cross validation

% % [TRAN, EMIS] = hmmestimate(Pred,RoomIndex);
% % PredStat = hmmviterbi(Pred,TRAN,EMIS);
% % OrigConf = confusionmat(RoomIndex,Pred,'order',[1;2;3;4]);
% % UpConf =   confusionmat(RoomIndex,PredStat,'order',[1;2;3;4]);
% % OrigAcc = sum(diag(OrigConf))/sum(sum(OrigConf))
% % UpdatedAcc =  sum(diag(UpConf))/sum(sum(UpConf))
% % OrigConf = OrigConf./sum(OrigConf,2)
% % UpConf = UpConf./sum(UpConf,2)