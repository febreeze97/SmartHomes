function [] = PlotRSSI(RSSI, Labels)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% define colours
Colours = ['r','b','g','k'];

figure;
hold on;
Num = 1:size(RSSI,1);
%xlim(datetime(2014,[7 8],[12 23]))
xlim([0, Num(end)-1]);
%xlim([min(Times), max(Times)])
%set(gca,'XLim',[min(Times), max(Times)]) 
ylim([-100,0])
plot(Num, RSSI(:,1), 'r-')
plot(Num, RSSI(:,2), 'b-')
plot(Num, RSSI(:,3), 'g-')
plot(Num, RSSI(:,4), 'k-')

if nargin == 2
    for m = 2:size(RSSI,1)
        X = [m-2, m-1, m-1, m-2]; Y = [0 0 -100 -100];
        patch(X,Y, Colours(Labels(m)), 'FaceAlpha',0.2, 'EdgeColor','none')
    end
end
    
legend('Living Room','Kitchen','Bedroom','Stairs','location','northwest')
ylabel('RSSI'); xticks([])

end

