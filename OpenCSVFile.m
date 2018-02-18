function [Times, RSSI, Acc, RoomIndex, Act] = OpenCSVFile(FolderName, FileName, Miss, Disp)
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
if Miss == 0
    RSSI = fillmissing(RSSI,'constant',-100);
elseif Miss == 1
    RSSI = fillmissing(RSSI,'linear');
end

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
    PlotRSSI(RSSI,RoomIndex)
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
        RSSI = zeros(length(Times),4); RSSI = NaN*RSSI;
        for i = 1:size(RSSI,1)
            Time = Times(i);
            A = Values(AllTimes==Time);
            B = Gateway(AllTimes==Time);
            for n = 1:length(B)
                RSSI(i,B(n)) = A(n);
            end
        end
        RSSI(1, isnan(RSSI(1,:)) ) = -100;
        RSSI(end, isnan(RSSI(end,:)) ) = -100;
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