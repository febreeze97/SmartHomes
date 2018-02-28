RSSI = []; Labels = [];

warning('off')
%Folder = "Constant/MedianAndLowFilter"; % Reformatted and MovingMedian don't work
Folder = "Constant/Reformatted";

for i = 1:9
   File = Folder+"/"+int2str(i)+".csv";
   T = readtable(File);
   RSSI = [RSSI; [T.(1), T.(2), T.(3), T.(4)]];
   Labels = [Labels; T.(5)];
end
clear T;
warning('on')


%[U,V,~] = svd(cov(RSSI));
%Test = RSSI*U;

%figure;
%plot3(Test(Labels==1,1),Test(Labels==1,2),Test(Labels==1,3),'bx')
%hold on
%plot3(Test(Labels==2,1),Test(Labels==2,2),Test(Labels==2,3),'rx')
%plot3(Test(Labels==3,1),Test(Labels==3,2),Test(Labels==3,3),'gx')
%plot3(Test(Labels==4,1),Test(Labels==4,2),Test(Labels==4,3),'kx')

[coeff, score, latent] = pca(RSSI);
latent = cumsum(latent/sum(latent));

figure;
plot3(score(Labels==1,1),score(Labels==1,2),score(Labels==1,3),'bx')
hold on
plot3(score(Labels==2,1),score(Labels==2,2),score(Labels==2,3),'rx')
plot3(score(Labels==3,1),score(Labels==3,2),score(Labels==3,3),'gx')
plot3(score(Labels==4,1),score(Labels==4,2),score(Labels==4,3),'kx')
hleg1 = legend('Living Room','Kitchen','Bedroom','Stairs');
set(hleg1,'Location','northeast')
xl = xlabel('1^{st} Principle Component'); yl = ylabel('2^{nd} Principle Component'); zlabel('3^{rd} Principle Component')
set(xl,'Rotation',15); set(yl,'Rotation',-25);
PosX = get(xl,'Position'); PosY = get(yl,'Position');
set(xl,'Position',PosX+[20,0,0]); set(yl,'Position',PosY+[0,15,5]);