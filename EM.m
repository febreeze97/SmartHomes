clear all;

RSSI = []; Labels = [];
Folder = "LowPassFilter";

%for i = 1:1
%    File = Folder+"/"+int2str(i)+".csv";
%    T = readtable(File);
%    RSSI = [RSSI; [T.(1), T.(2), T.(3), T.(4)]];
%    Labels = [Labels; T.(5)];
%end

T = readtable("Reformatted/freeliving-pub.csv");
RSSI = [T.(1), T.(2), T.(3), T.(4)];
Labels = [T.(5)];

clear T;

[U,~,~] = svd(cov(RSSI));

Test = RSSI*U;

figure;
plot3(Test(Labels==1,1),Test(Labels==1,2),Test(Labels==1,3),'bx')
hold on
plot3(Test(Labels==2,1),Test(Labels==2,2),Test(Labels==2,3),'rx')
plot3(Test(Labels==3,1),Test(Labels==3,2),Test(Labels==3,3),'gx')
plot3(Test(Labels==4,1),Test(Labels==4,2),Test(Labels==4,3),'kx')



