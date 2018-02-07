function [Times, RSSI, Acc, RoomIndex, Act] = OpenCSVFile(FolderName, FileName, Disp)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

File = FolderName+"/"+FileName+".csv";

T = readtable(File);

AllTimes = T.(1);
Times = unique(AllTimes);

Gateway = T.(2);
GateIndex = RoomIndexer(Gateway);

Acc = RepeatRemover(T.(3),AllTimes,Times,1);
Acc(:,2) = RepeatRemover(T.(4),AllTimes,Times,1);
Acc(:,3) = RepeatRemover(T.(5),AllTimes,Times,1);

AllRSSI = T.(6);
RSSI = CreateMatrixRSSI(AllRSSI,GateIndex,AllTimes,Times);

Room = T.(7);
RoomIndex = RoomIndexer(Room);
RoomIndex = RepeatRemover(RoomIndex,AllTimes,Times,0);

%Act = [];
%Act = cell2mat(T);
if size(T,2) >= 8
    Activity = RepeatRemover(T.(8),AllTimes,Times,0);
    Act = ActivityIndexer(Activity);
else
    Act = [];
end

%% Visulise result graph plotting
if Disp == 1
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
    
    % define background colours
    Colours = ['r','b','g','k'];
    
    for m = 2:size(RSSI,1)
        X = [m-2, m-1, m-1, m-2]; Y = [0 0 -100 -100];
        patch(X,Y, Colours(RoomIndex(m)), 'FaceAlpha',0.2, 'EdgeColor','none')
    end
    
end


%% Define required functions
    function [Index] = RoomIndexer(Text)
        Index = zeros(size(Text));
        for i = 1:length(Text)
            if isequal(Text(i),{'living'})
                Index(i) = 1;
            elseif isequal(Text(i),{'kitchen'})
                Index(i) = 2;
            elseif isequal(Text(i),{'bedroom'})
                Index(i) = 3;
            elseif isequal(Text(i),{'custom'}) || isequal(Text(i),{'stairs'})
                Index(i) = 4;
            end
        end
    end

    function [Index] = ActivityIndexer(Text)
        Index = zeros(size(Text));
        for i = 1:length(Text)
            if isequal(Text(i),{'sitting'})
                Index(i) = 1;
            elseif isequal(Text(i),{'walking'})
                Index(i) = 2;
            elseif isequal(Text(i),{'lying'})
                Index(i) = 3;
            elseif isequal(Text(i),{'custom'})
                Index(i) = 4;
            end
        end
    end

    function [RSSI] = CreateMatrixRSSI(Values,Gateway,AllTimes,Times)
        RSSI = zeros(length(Times),4); RSSI = RSSI - 100;
        for i = 1:size(RSSI,1)
            Time = Times(i);
            A = Values(AllTimes==Time);
            B = Gateway(AllTimes==Time);
            for n = 1:length(B)
                RSSI(i,B(n)) = A(n);
            end
        end
    end

%     function [Processed] = RepeatIntRemover(Original,AllTimes,Times)
%         %Index = Indexer(Original);            
%         
%         for i = 1:size(Times,1)
%             Temp = Original(AllTimes==Times(i));
%             Processed(i,1) = Temp(1);
%         end
%     end
    
    function [Processed] = RepeatRemover(Original,AllTimes,Times,Mean)
        %Index = Indexer(Original);
        if iscell(Original)
            Processed = cell(size(Times,1),1,1);
        else
            Processed = zeros(size(Times));
        end
        %Processed = zeros(size(Times));
        for i = 1:size(Times,1)
            Temp = Original(AllTimes==Times(i));
            if Mean
                Processed(i) = mean(Temp);
            else
                Processed(i) = Temp(1);
            end
        end
    end

end