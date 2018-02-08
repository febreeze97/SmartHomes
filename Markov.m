clear all;

[~, RSSI, ~, RoomIndex, ~] = OpenCSVFile("Test","freeliving-pub",0);

RoomIndex = RoomIndex';

Trans = [0.7, 0.15,   0.01, 0.14;
         0.3,  0.5,   0.01,  0.19;
           0.01,    0.01, 0.8,  0.18;
         0.3,  0.3, 0.3,  0.1];
     
%Emm = eye(4); % 0.25*ones(4,4);
Right = 0.6;
Emm = Right*eye(4) + ((1-Right)/4)*ones(4,4);

[ESTTR,ESTEMIT] = hmmtrain(RoomIndex,Trans,Emm)