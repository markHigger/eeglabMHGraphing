files = [];
inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181115/';

% %Load in 12Hz/0.2 Hz on both sides
inputName = 'EEG_fMRI_20181115_0001_ET12_75_75_02_02_passive_resample.set';

files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 20; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 10;
files(end).CarrierFreq = 7.5;
files(end).desc = ['7.5 Hz / 0.2 Hz passive, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['20181115_0001_75_02_02_passive_', num2str(files(end).EpSize), 's'];

inputName = 'EEG_fMRI_20181115_0002_ET12_75_75_05_05_passive_resample.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 4; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 2;
files(end).CarrierFreq = 7.5;
files(end).desc = ['7.5 Hz / 0.5 Hz passive, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['20181115_0002_75_05_05_passive_', num2str(files(end).EpSize), 's'];

inputName = 'EEG_fMRI_20181115_0003_ET12_75_75_10_10_passive_resample.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 4; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 2;
files(end).CarrierFreq = 7.5;
files(end).desc = ['7.5 Hz / 1 Hz passive, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['20181115_0002_75_10_10_passive_', num2str(files(end).EpSize), 's'];


outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/20181115/';        
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end

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
        if strcmp(EEG_event.type, 'S255')
            if isempty(startOfEEG) 
               startOfEEG = EEG_event.latency / FigObj.srate;
            elseif(strcmp(EEG_event.type, 'S255'))
                endOfEEG = EEG_event.latency / FigObj.srate;
            end
            
        end
    end
    
    
    FigObj.EpochPeriod_Continous( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Carrier');
                            
    %Set EEG to bandpassed at car freq
    lowCutoff = files(fileIdx).CarrierFreq - 1;
    highCutoff = files(fileIdx).CarrierFreq + 1;
    FigObj.EEG = EEG_Bandpass_Matlab(FigObj.EEG, lowCutoff, highCutoff, 3);
    
    %Set Epoch 1 to carrier freq
    FigObj.EpochPeriod_Continous( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Carrier');
                            
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
    
    %find hilbert transform of all channels
    for chanIdx = 1:64
        FigObj.Epochs(2).EpochsAvg(chanIdx,:) = ...
            abs(hilbert(FigObj.Epochs(1).EpochsAvg(chanIdx,:)));
    end
%     fig = figure;
%     FigObj.plotEpochAvg_chans([1:64], 'thing', 1, [], [])
%     fig = figure;
%     FigObj.plotEpochAvg_chans([1:64], 'thing', 2, [], [])
    
    fig = figure;
    hold
    subfig = subplot(2,2,1);
    hold
    FigObj.plotEpochAvg_chans([intersect(ChansLeft,ChansFront)], ...
         'Front Left Channels', 1, [], subfig);
    subfig = subplot(2,2,2); 
    hold
    FigObj.plotEpochAvg_chans(intersect(ChansRight,ChansFront), ...
        'Front Right Channels', 1, [], subfig);
    subfig = subplot(2,2,3); 
    hold
    FigObj.plotEpochAvg_chans(intersect(ChansLeft,ChansBack), ...
        'Back Left Channels', 1, [], subfig);
    subfig = subplot(2,2,4); 
    hold
    FigObj.plotEpochAvg_chans(intersect(ChansRight,ChansBack), ...
        'Back Right Channels', 1, [], subfig);
    %figname = [outputDir,files(fileIdx).fileDesc, '_Carrier_HemiSplit'];
    %saveas(fig, figname,'pdf')
    
                            
end