clear all;

[~,~,~,RoomIndex,~] = OpenCSVFile("Constant/Test","freeliving-pub",0);

Data = readtable('Random_Forest_Data.csv');
Seq = Data.(2); Seq(1) = [];

Trans = [0.9926, 0.0042, 0.0009, 0.0023;
         0.0043, 0.9939,      0, 0.0019;
              0,      0, 0.9842, 0.0158;
         0.0158, 0.0132, 0.0211, 0.9499];
     
Emis  = [0.9203,      0, 0.0797,      0;
         0.0033, 0.9962,      0, 0.0005;
         0.0883,      0, 0.8943, 0.0174;
         0.1372, 0.0106,      0, 0.8522];

States = hmmviterbi(Seq,Trans,Emis);

figure;
plot(States - RoomIndex','g-')
hold on
plot(Seq - RoomIndex,'r--')

Accuracy = sum(States==RoomIndex')/length(States);