clear all;

Acc = [];
Act = [];
for i = 1:10
    File = "Constant/Reformatted/"+int2str(i)+".csv";
    T = readtable(File);
    Acc = [Acc; T.(6), T.(7), T.(8)];
    Act = [Act; T.(9)];
end

Colours = ['rx','bx','gx','kx'];
figure
plot3(Acc(Act==1,1),Acc(Act==1,2),Acc(Act==1,3),'rx')
hold on
plot3(Acc(Act==2,1),Acc(Act==2,2),Acc(Act==2,3),'bx')
plot3(Acc(Act==3,1),Acc(Act==3,2),Acc(Act==3,3),'gx')
plot3(Acc(Act==4,1),Acc(Act==4,2),Acc(Act==4,3),'kx')
legend('Sitting','Walking','Lying','Custom')
xlabel('Acc X'); ylabel('Acc Y'); zlabel('Acc Z')