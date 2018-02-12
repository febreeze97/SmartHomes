function [] = ReformatData(InputFolder, OutputFolder, FileName, Pre)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Disp = 1;

[Times, RSSI, Acc, RoomIndex, Act] = OpenCSVFile(InputFolder, FileName, 0);
Orig = RSSI;

switch Pre
    case 0
        % Do nothing to preprocess the data
    case 1
        Fs = 1;
        fmax = Fs*0.5;
        
        FM = fft(RSSI);
        FM = fftshift(FM);
        
        freq = 0.1;
        num = floor( 0.5 * (freq/fmax) * size(FM,1));
        N_clear = floor(size(FM,1)/2) - num + 1;
        FilteredFM = FM;
        FilteredFM(1:N_clear,1:4) = 0;
        FilteredFM(end-N_clear+2:end,1:4) = 0;
        %plot(log(abs(FilteredFM(:,1))+1))
        FilteredFM = fftshift(FilteredFM);

        RSSI = ifft(FilteredFM);
    case 2
        RSSI = movmean(RSSI,[10,10]);
    case 3
        RSSI = movmedian(RSSI,[10,10]);
        
    case 4
        Fs = 1;
        fmax = Fs*0.5;
        
        FM = fft(RSSI);
        FM = fftshift(FM);
        
        freq = 0.1;
        num = floor( 0.5 * (freq/fmax) * size(FM,1));
        N_clear = floor(size(FM,1)/2) - num + 1;
        FilteredFM = FM;
        FilteredFM(1:N_clear,1:4) = 0;
        FilteredFM(end-N_clear+2:end,1:4) = 0;
        %plot(log(abs(FilteredFM(:,1))+1))
        FilteredFM = fftshift(FilteredFM);

        RSSI = ifft(FilteredFM);
        
        RSSI = movmean(RSSI,[10,10]);
end

Output = OutputFolder+"/"+FileName+".csv";

fid = fopen(Output,'w'); 
fprintf(fid,'Sensor 1,Sensor 2,Sensor 3,Sensor 4,Room,AccX,AccY,AccZ,Activity\n');
fclose(fid);

dlmwrite(Output,[RSSI,RoomIndex,Acc,Act],'-append')
%csvwrite(Output,[RSSI,RoomIndex])

if Disp
    PlotRSSI(Orig,RoomIndex)
    PlotRSSI(RSSI,RoomIndex)
end

end