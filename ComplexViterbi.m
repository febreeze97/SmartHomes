function [path] = ComplexViterbi(Prior, IndTrans, EvProbs)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

N = size(EvProbs,2);
O = size(IndTrans,1);
path = zeros(1,N);


if size(IndTrans,3) ~= 1
    fprintf('Non-constant transition matrix\n')
else
    Trans = IndTrans;
    fprintf('Constant transition matrix\n')
end

T1 = zeros(O,N); T2 = T1;
T1(:,1) = EvProbs(:,1).*Prior;

for j = 2:N
    if size(IndTrans,3) ~= 1
        Trans = IndTrans(:,:,j);
    end
    for i = 1:O
        [M,I] = max( T1(:,j-1).*Trans(:,i)*EvProbs(i,j) );
        T1(i,j) = M;
        T2(i,j) = I;
    end
    T1(:,j) = T1(:,j)/sum(T1(:,j));
end

[~,I] = max(T1(:,end));
path(end) = I;

for j = length(path)-1:-1:1
    path(j) = T2(path(j+1),j+1);
end

end