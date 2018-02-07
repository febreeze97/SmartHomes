clear all;

[~, RSSI, ~, RoomIndex, ~] = OpenCSVFile("Test","freeliving-pub",0);

RoomIndex = RoomIndex';

Trans = [0.7, 0.15,   0, 0.15;
         0.3,  0.5,   0,  0.2;
           0,    0, 0.8,  0.2;
         0.3,  0.3, 0.3,  0.1];
     
%Emm = eye(4); % 0.25*ones(4,4);
Emm = 0.6*eye(4) + 0.1*ones(4,4);

[ESTTR,ESTEMIT] = hmmtrain(RoomIndex,Trans,Emm)