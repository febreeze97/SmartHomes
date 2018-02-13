clear all;

[Times, RSSI, Acc, RoomIndex, Act] = OpenCSVFile("Training","2",0);
%[Times, RSSI, Acc, RoomIndex, Act] = OpenCSVFile("Test","Freeliving-pub",0);

%M(:,1) = M(:,1) - mean(M(:,1));

Fs = 1;
fmax = Fs*0.5;
Hz = linspace(-fmax,fmax,size(RSSI,1));

FM = fft(RSSI);
FM = fftshift(FM);

%FM(51:end-50,1:4) = 0;

MagFM = abs(FM);

%Phase = angle(FM);

figure;
plot( Hz, log(MagFM(:,1)+1) ,'k-')
xlabel('Freq / Hz'); ylabel('Magnitude'); ylim([0,12])
patch([-0.5, -0.1, -0.1, -0.5],[12 12 0 0], 'r', 'FaceAlpha',0.1, 'EdgeColor','none')
patch([-0.1,  0.1,  0.1, -0.1],[12 12 0 0], 'g', 'FaceAlpha',0.1, 'EdgeColor','none')
patch([ 0.1,  0.5,  0.5,  0.1],[12 12 0 0], 'r', 'FaceAlpha',0.1, 'EdgeColor','none')
%plot(MagFM(:,1))

%figure;
%plot( Phase )


freq = 0.1;

num = floor( 0.5 * (freq/fmax) * size(FM,1));
N_clear = floor(size(FM,1)/2) - num + 1;
FilteredFM = FM;
FilteredFM(1:N_clear,1:4) = 0; %FilteredFM(freq+1:N_clear,1:4) = 0;
FilteredFM(end-N_clear+2:end,1:4) = 0; %FilteredFM(end-N_clear+2:end-freq,1:4) = 0;
FilteredFM = fftshift(FilteredFM);

FilteredSignal = ifft(FilteredFM);

figure;
plot( Hz, log(abs(fftshift(FilteredFM(:,1)))+1) ,'k-')
xlabel('Freq / Hz'); ylabel('Magnitude'); ylim([0,12])
patch([-0.5, -0.1, -0.1, -0.5],[12 12 0 0], 'r', 'FaceAlpha',0.1, 'EdgeColor','none')
patch([-0.1,  0.1,  0.1, -0.1],[12 12 0 0], 'g', 'FaceAlpha',0.1, 'EdgeColor','none')
patch([ 0.1,  0.5,  0.5,  0.1],[12 12 0 0], 'r', 'FaceAlpha',0.1, 'EdgeColor','none')

%FilteredSignal = real(FilteredSignal);

% % figure;
% % subplot(2,1,1)
% % plot(RSSI(:,1),'r-')
% % hold on
% % plot(RSSI(:,2),'b-')
% % plot(RSSI(:,3),'g-')
% % plot(RSSI(:,4),'k-')
% % 
% % subplot(2,1,2)
% % plot(FilteredSignal(:,1),'r-')
% % hold on
% % plot(FilteredSignal(:,2),'b-')
% % plot(FilteredSignal(:,3),'g-')
% % plot(FilteredSignal(:,4),'k-')


% % 
% % %K = 0.25*[1,2,1];
% % %K = 0.1*[1,2,4,2,1];
% % K = [1,2,4,8,4,2,1]/22;
% % 
% % %M_dash = ifft(FM);
% % M_dash = conv(M(1:100,1),K,'same');
% % 
% % figure;
% % plot(M(1:100,1))
% % %hold on
% % figure;
% % plot(M_dash)
% % 
