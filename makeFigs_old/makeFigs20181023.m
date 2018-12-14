fileIdx = 1;
files = [];

inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181023/';

%Load in 0.5 Hz on both sides
inputName = 'EEG_20181023_0001_Entrainment_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = '0.5 Hz, 10s Epoch';
files(end).fileDesc = '0001_0_5_10s';
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 0.2 Hz on both sides
inputName = 'EEG_20181023_0002_Entrainment_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = '0.2 Hz, 25s Epoch';
files(end).fileDesc = '0002_0_2_25s';
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 5;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 1.0 Hz on both sides
inputName = 'EEG_20181023_0003_Entrainment_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = '1.0 Hz, 5s Epoch';
files(end).fileDesc = '0003_1_0_5s';
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 0.2hz on T, 0.5 NTz
inputName = 'EEG_20181023_0004_Entrainment_Short_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = '0.2 Hz T / 0.5 HZ NT, 25s Epoch';
files(end).fileDesc = '0004_0_2T_0_5NT_25s';
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 10;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 0.5hz on T, 1.0 NT
inputName = 'EEG_20181023_0005_Entrainment_Short_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = '0.5 Hz T / 1.0 HZ NT, 25s Epoch';
files(end).fileDesc = '0005_0_5T_1_0NT_25s';
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 2;
files(end).startOffset = 0.5; %skip first 0.5s

%Load in 0.2hz on T, 0.1 NT
inputName = 'EEG_20181023_0006_Entrainment_Short_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).desc = '0.2 Hz T / 0.1 HZ NT, 30s Epoch';
files(end).fileDesc = '0006_0_2T_0_1NT_30s';
files(end).EpSize = epochTime; %epoch size in seconds creates 
files(end).EpPeriod = 10;
files(end).startOffset = 0.5; %skip first 0.5s

outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/20181023/';
for fileIdx = 1:length(files)
    %Create EEG images object for current file
    FigObj = EEG_images(files(fileIdx).desc);
    
    %Load EEG into object
    FigObj.loadEEG_set(files(fileIdx).path);
    
    %Find length of data in seconds
    endOfEEG =  length(FigObj.EEG.data) / FigObj.srate;
    
    %start at half second and create epochs every 10 seconds
    FigObj.EpochPeriod_single( files(fileIdx).startOffset, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Epoch');
    %save figures                       
    FigObj.setsaveFigsFlag(outputDir, files(fileIdx).fileDesc);
    
%     FigObj.plotFFTLoc({FigObj.Epochs(1).EpochsAvg},[], [0, 5, 0 , 5000], [])
%     FigObj.plotFFTLoc({FigObj.Epochs(1).EpochsAvg},[], [8, 16, 0 , 5000], [])
%     [f, fft_data] = FigObj.EEG_fft(FigObj.Epochs(1).EpochsAvg);
    
%     %plot for cwt for all channels *Should be replaced by class method
    for chanIdx = 1:64
        FigObj.create_cwt_singleChan(1, chanIdx);
        
        %close figures for ram reasons
        if ~mod(chanIdx, 32)
            close all
        end
    end
end