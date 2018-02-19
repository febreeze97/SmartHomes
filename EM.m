clear all;
warning('off')

classes = 4;

RSSI = []; Labels = [];
Folder = "Constant/LowPassFilter";
%Folder = "Constant/MedianAndLowFilter"; % Reformatted and MovingMedian don't work

for i = 1:10
   File = Folder+"/"+int2str(i)+".csv";
   T = readtable(File);
   RSSI = [RSSI; [T.(1), T.(2), T.(3), T.(4)]];
   Labels = [Labels; T.(5)];
end

T = readtable(Folder+"/freeliving-pub.csv");
TestRSSI = [T.(1), T.(2), T.(3), T.(4)];
TestLabels = [T.(5)];

clear T;
warning('on')

%[U,~,~] = svd(cov(RSSI));

%Test = RSSI*U;

%figure;
%plot3(Test(Labels==1,1),Test(Labels==1,2),Test(Labels==1,3),'bx')
%hold on
%plot3(Test(Labels==2,1),Test(Labels==2,2),Test(Labels==2,3),'rx')
%plot3(Test(Labels==3,1),Test(Labels==3,2),Test(Labels==3,3),'gx')
%plot3(Test(Labels==4,1),Test(Labels==4,2),Test(Labels==4,3),'kx')

Means = cell(classes,1);
Covar = cell(classes,1);

for i = 1:classes
    Means{i} = mean( RSSI(Labels==i,:) );
    Covar{i} = cov ( RSSI(Labels==i,:) );
end

Prob = zeros(length(TestRSSI),classes);

for i = 1:classes
    Prob(:,i) = mvnpdf(TestRSSI,Means{i},Covar{i});
end

%figure;
%plot(Prob(:,1)./sum(Prob,2))
%
%figure;
%plot(TestLabels==1)

T = [1/3, 1/3,   0, 1/3;
     1/3, 1/3,   0, 1/3;
       0,   0, 1/2, 1/2;
     1/4, 1/4, 1/4, 1/4];

% T = [0.99998, 0.00001,      0, 0.00001;
%      0.00001, 0.99998,      0, 0.00001;
%           0,      0, 0.99999, 0.00001;
%      0.00001, 0.00001, 0.99997, 0.00001];
 
% T = [0.9926, 0.0042,      0, 0.0032;
%      0.0043, 0.9939,      0, 0.0019;
%           0,      0, 0.9842, 0.0158;
%      0.0158, 0.0132, 0.0211, 0.9499];

%Prob(1,:) = [0,0,1,0];
ModProb = Prob;
for n = 2:size(ModProb,1)
    Prior = Prob(n-1,:) * T;
    if n == 515
%         Prob(n-1,:)
%         Prior
         Prob(n,:)/sum(Prob(n,:))
         (Prob(n,:).*Prior)/sum(Prob(n,:).*Prior)
    end
    ModProb(n,:) = (Prob(n,:).*Prior)/sum(Prob(n,:).*Prior);
end

[~,Class1] = max(Prob,[],2);
[~,Class2] = max(ModProb,[],2);

% Classification = zeros(size(TestLabels));
% for n = 1:length(Classification)
%     if max(Prob(n,:)) == Prob(n,1)
%         Classification(n) = 1;
%     elseif max(Prob(n,:)) == Prob(n,2)
%         Classification(n) = 2;
%     elseif max(Prob(n,:)) == Prob(n,3)
%         Classification(n) = 3;
%     elseif max(Prob(n,:)) == Prob(n,4)
%         Classification(n) = 4;
%     end
% end

figure;
plot(Class1-TestLabels)
M1 = confusionmat(TestLabels,Class1); M1 = M1./sum(M1,2)
sum((Class1-TestLabels)==0)/length(TestLabels)

figure;
plot(Class2-TestLabels)
M2 = confusionmat(TestLabels,Class2); M2 = M2./sum(M2,2)
sum((Class2-TestLabels)==0)/length(TestLabels)