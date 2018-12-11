fileIdx = 1;
files = [];

inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181109/';

epochTime = 20; %20 second epochs

%Load in 12Hz/0.2 Hz on both sides
inputName = 'EEG_20181109_0001_ET07_75_75_02_02_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 20; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 10;
files(end).startOffset = 0.5; %skip first 0.5s
files(end).desc = ['7.5 Hz / 0.2 Hz, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['0001_75_02_02_', num2str(epochTime), 's'];

% inputName = 'EEG_20181109_0002_ET07_75_75_05_05_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 10; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 2;
% files(end).startOffset = 0.5; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 0.5 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0002_75_05_05_', num2str(epochTime), 's'];
% 
% inputName = 'EEG_20181109_0003_ET07_75_75_10_10_blink.set';
% files(end + 1).path = {[inputDir, inputName]};
% files(end).EpSize = 12; %epoch size in seconds creates 4 periods
% files(end).EpPeriod = 4;
% files(end).startOffset = 0; %skip first 0.5s
% files(end).desc = ['7.5 Hz / 1 Hz, ', ...
%     num2str(files(end).EpSize) 's window, ' ...
%     num2str(files(end).EpPeriod) 's period '];
% files(end).fileDesc = ['0003_75_10_10_', num2str(epochTime), 's'];
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


outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/20181109/';
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
    FigObj.EEG = EEG_Bandpass_Matlab(FigObj.EEG, 0.1, 3, 2);
    %FigObj.EEG = EEG_Notch_Matlab(FigObj.EEG, 7.5, 4, 3);
    %start at half second and create epochs every 10 seconds
    FigObj.EpochPeriod_single( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Epoch');
                                    
    %save figures                       
    FigObj.setsaveFigsFlag(outputDir, files(fileIdx).fileDesc);
    
%     %test plotting fft channels
%     FigObj.plotffts_single([7, 8], [0.2, 12], [0, 20, 0, 1000], 1);
    
    %FigObj.plotEpochAvg_MSE_single( [51 52], {'b', 'r'})
    for colorIdx = 1:64
        colors{colorIdx} = [1 1 1] * colorIdx / 64;
    end
    fig = FigObj.plotEpochAvg_MSE_single( 1:2, colors);
    figname = [outputDir, 'allChans/',files(fileIdx).fileDesc, '_allChans'];
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