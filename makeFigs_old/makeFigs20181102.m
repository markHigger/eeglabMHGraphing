fileIdx = 1;
files = [];

inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181102/';

epochTime = 20; %20 second epochs

%Load in 12Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0002_ET06_12_02_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz / 0.2 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0002_12_02_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 5;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0003_ET06_12_05_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz / 0.5 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0003_12_02_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 10 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0004_ET06_12_10_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz / 1 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0004_12_10_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 20 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 7.5 Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0005_ET06_75_02_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['7.5 Hz / 0.2 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0005_75_02_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 3 periods
files(end).EpPeriod = 5;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 7.5 Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0006_ET06_75_05_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['7.5 Hz / 0.5 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0006_75_05_', num2str(epochTime), 's'];;
files(end).EpSize = epochTime; %epoch size in seconds creates 5 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 7.5 Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0007_ET06_75_10_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['7.5 Hz / 1 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0007_75_10_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 10 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz w 1 Hz T & 0.5 Hz NT
inputName = 'EEG_20181102_0008_ET06_12_01_02_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz - 1Hz (T), 0.5Hz (NT), ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0008_12_10_05_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 10/5 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s


%Load in 12Hz w 1 Hz T & 0.2 Hz NT
inputName = 'EEG_20181102_0009_ET06_12_10_02_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz - 1Hz (T), 0.2Hz (NT), ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0009_12_10_02_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 10/5 periods
files(end).EpPeriod = 5;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz & 75 Hz w 0.5 Hz
inputName = 'EEG_20181102_0010_ET06_12_75_05_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz(T), 7.5 Hz(NT), 0.5 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0010_12_75_05_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz & 75 Hz w 1 Hz
inputName = 'EEG_20181102_0011_ET06_12_75_10_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz(T), 7.5 Hz(NT), 1.0 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0011_12_75_10_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 10/5 periods
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 75Hz & 12 Hz w 0.5 Hz
inputName = 'EEG_20181102_0012_ET06_75_12_05_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['7.5 Hz(T), 12 Hz(NT), 0.5 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0012_75_12_05_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 12 Hz w 0.2 Hz
inputName = 'EEG_20181102_0013_ET06_12_02_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = ['12 Hz, 0.2 Hz, ', num2str(epochTime) 's Epoch'];
files(end).fileDesc = ['0013_12_02_', num2str(epochTime), 's'];
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 5;
files(end).startOffset = 0.5; %skip first 0.5s

% %Load in 75Hz & 12 Hz w 1.0 Hz
% inputName = 'EEG_20181102_0014_ET06_75_12_10_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).desc = ['7.5 Hz(T), 12 Hz(NT), 1.0 Hz, ', num2str(epochTime) 's Epoch'];
% files(end).fileDesc = ['0014_75_12_10_', num2str(epochTime), 's'];
% files(end).EpSize = epochTime; %epoch size in seconds creates 
% files(end).EpPeriod = 2;
% files(end).startOffset = 0.5; %skip first 0.5s




outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/20181102/';
for fileIdx = 1:length(files)
    %Create EEG images object for current file
    FigObj = EEG_images(files(fileIdx).desc);
    
    
    %Load EEG into object
    FigObj.loadEEG_set(files(fileIdx).path);
    
    
    startOfEEG = [];
    endOfEEG = [];
    %Find start and end of EEG using the S 255 boundry indicator
    for eventIdx = 1:length(FigObj.EEG.event)
        EEG_event = FigObj.EEG.event(eventIdx);
        if strcmp(EEG_event.type, 'S 14')|| strcmp(EEG_event.type, 'S255')
            if isempty(startOfEEG)
               startOfEEG = EEG_event.latency / FigObj.srate;
            else
                if strcmp(EEG_event.type, 'S255')
                    endOfEEG = EEG_event.latency / FigObj.srate;
                end
            end
            
        end
    end
    
    %start at half second and create epochs every 10 seconds
    FigObj.EpochPeriod_single( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Epoch');
                                    
    %save figures                       
%    FigObj.setsaveFigsFlag(outputDir, files(fileIdx).fileDesc);
    
%     %test plotting fft channels
%     FigObj.plotffts_single([7, 8], [0.2, 12], [0, 20, 0, 1000], 1);
    
    %FigObj.plotEpochAvg_MSE_single( [51 52], {'b', 'r'})
    for colorIdx = 1:64
        colors{colorIdx} = [1 1 1] * colorIdx / 64;
    end
    fig = FigObj.plotEpochAvg_MSE_single( 1:64, colors);
    figname = [outputDir, 'allChans/',files(fileIdx).fileDesc, '_allChans.png'];
    saveas(fig, figname)
    
    
    %plots for all channels *Should be replaced by class method
    for chanIdx = 1:64
        
%         FigObj.create_cwt_singleChan(1, chanIdx);
        %Plot Time series of each channe
        
        %close figures for ram reasons
        if ~mod(chanIdx, 32)
            %close all
        end
    end
end