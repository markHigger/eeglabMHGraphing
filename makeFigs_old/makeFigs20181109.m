fileIdx = 1;
files = [];

inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181109/';

epochTime = 20; %20 second epochs

%Load in 12Hz/0.2 Hz on both sides
% inputName = 'EEG_20181109_0001_ET07_75_75_02_02_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 20; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 10;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 0.2 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0001_75_02_02_', num2str(epochTime), 's'];

% inputName = 'EEG_20181109_0002_ET07_75_75_05_05_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 4; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 2;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 0.5 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0002_75_05_05_', num2str(epochTime), 's'];
% 
inputName = 'EEG_20181109_0003_ET07_75_75_10_10_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 4; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0; %skip first 0.5s
files(end).desc = ['7.5 Hz / 1 Hz, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['0003_75_10_10_', num2str(epochTime), 's'];
% 
% inputName = 'EEG_20181109_0005_ET07_75_75_02_05_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 20; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 10;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 0.2 Hz, 0.5 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0005_75_02_05_', num2str(epochTime), 's'];
% 
% inputName = 'EEG_20181109_0006_ET07_75_75_05_02_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 20; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 10;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 0.5 Hz, 0.2 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0006_75_05_02_', num2str(epochTime), 's'];
% 
% 
% inputName = 'EEG_20181109_0007_ET07_75_75_10_10_passive_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 12; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 4;
% files(end).startOffset = 0; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 1 Hz, Passive, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0006_75_01_01_passive_', num2str(epochTime), 's'];
% 
inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181102/';
%outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/20181109/';
% inputName = 'EEG_20181102_0002_ET06_12_02_single_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize =10; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 5;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['12 Hz / 0.2 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0002_12_02_02_', num2str(files(end).EpSize), 's'];

% 
% inputName = 'EEG_20181102_0003_ET06_12_05_single_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 4; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 2;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['12 Hz / 0.5 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0003_12_05_05_', num2str(files(end).EpSize), 's'];
% 
% inputName = 'EEG_20181102_0004_ET06_12_10_single_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 2; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 1;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['12 Hz / 1 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0004_12_10_10_', num2str(files(end).EpSize), 's'];

for fileIdx = 1:length(files)
    %Create EEG images object for current file
    FigObj = EEG_images(files(fileIdx).desc);
    
    
    %Load EEG into object
    FigObj.loadEEG_set(files(fileIdx).path);
    
    startOfEEG = [];
    endOfEEG = [];
    for eventIdx = 1:length(FigObj.EEG.event)
        EEG_event = FigObj.EEG.event(eventIdx);
        if strcmp(EEG_event.type, 'S 14')|| strcmp(EEG_event.type, 'S255')
            if isempty(startOfEEG) && ~strcmp(EEG_event.type, 'S255')
               startOfEEG = EEG_event.latency / FigObj.srate;
            else
                if strcmp(EEG_event.type, 'S255')
                    endOfEEG = EEG_event.latency / FigObj.srate;
                end
            end
            
        end
    end
    %FigObj.EEG = EEG_Bandpass_Matlab(FigObj.EEG, 0.1, 3, 2);
    %FigObj.EEG = EEG_Notch_Matlab(FigObj.EEG, 7.5, 4, 3);
    %start at half second and create epochs every 10 seconds
    FigObj.EpochPeriod_Continous( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Epoch');
                                    
    %save figures                       
    FigObj.setsaveFigsFlag(outputDir, files(fileIdx).fileDesc);
    
%     %test plotting fft channels
%     FigObj.plotffts_single([7, 8], [0.2, 12], [0, 20, 0, 1000], 1);
    
    %FigObj.plotEpochAvg_MSE_single( [51 52], {'b', 'r'})
    
        %Seperate channels by front/back
    ChansFront = [];
    ChansBack = [];
    frntIdx = 1;
    backIdx = 1;
    for chanIdx = 1:64
        if(abs(FigObj.EEG.chanlocs(chanIdx).theta) <= 90)
            ChansFront(frntIdx) = chanIdx;
            frntIdx = frntIdx + 1;
        end
        if(abs(FigObj.EEG.chanlocs(chanIdx).theta) > 90)
            ChansBack(backIdx) = chanIdx;
            backIdx = backIdx + 1;
        end
    end
    
    %Seperate channels by left/right
    ChansLeft = [];
    ChansRight = [];
    leftIdx = 1;
    rightIdx = 1;
    for chanIdx = 1:64
        if(FigObj.EEG.chanlocs(chanIdx).theta < 0)
            ChansLeft(leftIdx) = chanIdx;
            leftIdx = leftIdx + 1;
        end
        if(FigObj.EEG.chanlocs(chanIdx).theta > 0)
            ChansRight(rightIdx) = chanIdx;
            rightIdx = rightIdx + 1;
        end
    end
    for colorIdx = 1:64
        colors{colorIdx} = [1 1 1] * colorIdx / 64;
    end
    fig = figure;
    hold
    FigObj.plotEpochAvg_chans([1:64], ...
         'All Channels and Pupillometry', 1, [-20 20], fig);
     fig.Renderer = 'Painters';
    fig = figure;
    hold
    subfig = subplot(2,2,1);
    hold
    FigObj.plotEpochAvg_chans([intersect(ChansLeft,ChansFront)], ...
         'Front Left Channels', 1, [-20 20], subfig);
    subfig = subplot(2,2,2); 
    hold
    FigObj.plotEpochAvg_chans(intersect(ChansRight,ChansFront), ...
        'Front Right Channels', 1, [-20 20], subfig);
    subfig = subplot(2,2,3); 
    hold
    FigObj.plotEpochAvg_chans(intersect(ChansLeft,ChansBack), ...
        'Back Left Channels', 1, [-20 20], subfig);
    subfig = subplot(2,2,4); 
    hold
    FigObj.plotEpochAvg_chans(intersect(ChansRight,ChansBack), ...
        'Back Right Channels', 1, [-20 20], subfig);
%     figname = [outputDir, 'allChans/',files(fileIdx).fileDesc, '_allChans'];
    %saveas(fig, figname,'pdf')
    
    
    %plots for all channels *Should be replaced by class method
    for chanIdx = 1:64
        
        %FigObj.create_cwt_singleChan(1, chanIdx);
        %Plot Time series of each channe
        
        %close figures for ram reasons
        if ~mod(chanIdx, 32)
            %close all
        end
    end
end