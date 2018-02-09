function [percent_error] = running_mean_max(FolderName, FileName, MeanWidth, freq_diff)

ROOM = [];
n = 1;

File = FolderName+"/"+FileName+".csv";

ss = readtable(File);

a = MeanWidth;
b = MeanWidth;


dataa = [movmean(ss.(1),[a b]),movmean(ss.(2),[a b]),movmean(ss.(3),[a b]),movmean(ss.(4),[a b])]';

while n < 4*length(ss.(1))
    a = dataa(n);
    b = dataa(n+1);
    c = dataa(n+2);
    d = dataa(n+3);
    A = [a b c d];
    
    if max(A) == a 
        room = 1;
    end
    
    
    if max(A) == b
        room = 2;
    end
    
    if max(A) == c
        room = 3;
    end
    
    if max(A) == c && abs(c-a) < freq_diff
       room = 1;
    end
    
    if max(A) == d
        room = 4;
    end
    
    n = n+4;
        
        
    ROOM = [ROOM room];
end

er = ss.(5)' - ROOM;
sum_error = sum(nnz(er == 0));
percent_error = (length(ss.(1))-sum_error)/length(ss.(1));
% ERROR = [ERROR percent_error]
% plot(dataa')
figure(1); plot(er)

end