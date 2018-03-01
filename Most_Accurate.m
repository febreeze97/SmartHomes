function [percent_error1] = Most_Accurate(FileName,walkingData)

clear vars

File = FileName+".csv";

ss = readtable(File);

Width = 5;
freq = 0.1;
freq_diff = 7;
ERROR = [];
% for freq_diff = (7:1:7)

    ROOM  = [];
dataa1 = [movmean(ss.(1),[Width Width]),movmean(ss.(2),[Width Width]),movmean(ss.(3),[Width Width]),movmean(ss.(4),[Width Width])];




    
Fs = 1;
fmax = Fs*0.5;
Hz = linspace(-fmax,fmax,size(dataa1,1));

FM = fft(dataa1);
FM = fftshift(FM);


MagFM = abs(FM);

num = floor( 0.5 * (freq/fmax) * size(FM,1));
N_clear = floor(size(FM,1)/2) - num + 1;
FilteredFM = FM;
FilteredFM(1:N_clear,1:4) = 0; %FilteredFM(freq+1:N_clear,1:4) = 0;
FilteredFM(end-N_clear+2:end,1:4) = 0; %FilteredFM(end-N_clear+2:end-freq,1:4) = 0;
FilteredFM = fftshift(FilteredFM);

FilteredSignal = ifft(FilteredFM);



dataa = FilteredSignal';


n = 1;

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
    
    if max(A) == c && abs(c-a) < freq_diff && c < -60
       room = 1;
    end
    
     if max(A) == c && abs(d-a) < 10
       room = 3;
    end
    
    if max(A) == d
        room = 4;
    end
   
        
        
    n = n+4;
        
    
        
    ROOM = [ROOM room];
    
  
   

end

for i = (5:1:length(ROOM)-1)
if walkingData(i) < 0.15  && walkingData(i-1) < 0.15 && walkingData(i-2) < 0.15 && walkingData(i-3) < 0.15 && walkingData(i-4) < 0.15 
    ROOM(i+1) = ROOM(i);
end

realroom = ss.(5)';
er = realroom - ROOM;
sum_error = sum(nnz(er == 0));
percent_error = (length(ss.(1))-sum_error)/length(ss.(1));
ERROR = [ERROR percent_error];
percent_error1 = (1 - percent_error)*100;
C = confusionmat(ss.(5),ROOM);
matrix = C./sum(C,2);
% freq_diff = freq_diff + 0.1;
%freq = freq + 0.01
% Width = Width + 0.1;

end