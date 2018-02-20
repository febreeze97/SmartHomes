function [Graph] = ErrorGraphPlotter(Class,Label)
%ERRORGRAPHPLOTTER Plots errors with colours to represent actual room
%
% Inputs: Class - Column vector of labels predicted by the classification
%         Label - Column vector of actual room which the person is in
% Output: Graph - MATLAB graph object of the Error Graph

Colours = [1,0,0;
           0,0,1;
           0,1,0;
           0,0,0];
       
ColVec = zeros(3,size(Label,1));
for i = 1:size(Label,1)
    ColVec(:,i) = Colours(Label(i),:);
end
ColVec = ColVec';
set(groot,'defaultAxesColorOrder',ColVec)

Num = 1:size(Label,1);
Error = [zeros(size(Label))'; (Class~=Label)'];

figure;
%set(gca,'ColorOrder',ColVec,'NextPlot','replacechildren')
plot([Num; Num],Error)%,ColVec)
hold on
set(gca,'ColorOrderIndex',1)
plot([0,Num(1:end-1);1,Num(2:end)],zeros(2,length(Num)),'LineWidth',3)
xlim([0,Num(end)])

end