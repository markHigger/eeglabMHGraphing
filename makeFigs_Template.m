%Make Figs Template is a template for making EEG figures using the
%EEG_images class with Epoching

%% Set perameters for each eeg file

files = []; %File data will be stored in a struct as follow
%files [1 x n] struct
%   path [string] - full path of eeg input set file
%   EpSize [time (s)] - Window length for Epoching
%   EpPeriod [time (s)] - Distance between windows in Epochs (usually period)
%   desc [str] - File description used for Headers of plots
%   fileDesc [path str] - file description in file compatable format
%                           for use in saving figures

%input directory for batch of files 
%*processed data is usually in a processed data folder for the date of the
%run in yyyymmdd format
inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181102/'; %example Dir

%Example of specific file
inputName = 'EEG_20181102_0002_ET06_12_02_single_blink.set'; % example file name
files(end + 1).path = {[inputDir, inputName]}; % set input path
files(end).EpSize = 10; %Window allows for 2 periods
files(end).EpPeriod = 5; %Period of 0.2 hz function
files(end).CarrierFreq = 12; % Set carrier Frequency
%Set Titles to have Carrier Freq, TargetFreq, period and Epoch size specified
files(end).desc = ['12 Hz / 0.2 Hz, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['0002_12_02_02_', num2str(files(end).EpSize), 's'];

%set or make output directory for figures
outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/testFigs/';        
if ~exist(outputDir, 'dir')
    mkdir(outputDir)
end
%% Perform Operations on File
%Loop through all files to find information
for fileIdx = 1:length(files)
    %% Set up EEG_images obj information for EEG and Epochs
    %Create EEG images object for current file
    FigObj = EEG_images(files(fileIdx).desc);
    
    %Load EEG into object
    FigObj.loadEEG_set(files(fileIdx).path);
    
    %Find Start and End codes for Epoching
    startOfEEG = [];
    endOfEEG = [];
    %Find start and end of EEG using the S 255 boundry indicator, Starting
    %on S 14(target onset) and ending on S255
    %*NOTE: this is poorly coded, but works
    for eventIdx = 1:length(FigObj.EEG.event)
        EEG_event = FigObj.EEG.event(eventIdx);
        if strcmp(EEG_event.type, 'S 14')|| strcmp(EEG_event.type, 'S255')
            if isempty(startOfEEG) && ~strcmp(EEG_event.type, 'S255')
               startOfEEG = EEG_event.latency / FigObj.srate;
            elseif(strcmp(EEG_event.type, 'S255'))
                endOfEEG = EEG_event.latency / FigObj.srate;
            end
            
        end
    end
    
    %create Epoched data from EEG, from the first S 14 to the last S255
    %trigger, creating an EpSize length Window every EpPeriod seconds.
    %This Epoch can now be accessed through FigObj.Epochs(1) with
    %Epochs(1).name = 'Full'
    FigObj.EpochPeriod_Continous( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Full');
    
    %Get Indecies for front/back and Left/Right Channels based off of
    %eeglab polar coordinates
    ChansLeft = FigObj.ChansLeft;
    ChansRight = FigObj.ChansRight;
    ChansFront = FigObj.ChansFront;
    ChansBack = FigObj.ChansBack;   
    
    %Bandpass EEG data to carrier frequency
    %NOTE: this changes out the FigObj EEG member so any future functions
    %   that use the whole EEG (ie. any epoch function or plotfft_whole_chans) 
    %   will be effected
    lowCutoff = files(fileIdx).CarrierFreq - 1;
    highCutoff = files(fileIdx).CarrierFreq + 1;
    FigObj.EEG = EEG_Bandpass_Matlab(FigObj.EEG, lowCutoff, highCutoff, 3);
    
    %second epoched similarly to the first epoch, but using the new
    %bandpassed EEG for data, this PEoch can be accessed with
    %FigObj.Epochs(2)
    FigObj.EpochPeriod_Continous( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Carrier');
    
    %Set file descrption for FigObj which is used for automatic figure
    %saving within figure generation
    %NOTE: automatic figure saving is not implemented yet in most functions
    FigObj.setsaveFigsFlag(outputDir, files(fileIdx).fileDesc);
    
    %% plots for Epochs
    
    %Plot fft of Back Right channels of non-bandpassed epochs with a black 
    %line at the carrier Freq
    fig = figure;
    hold
    Fc = files(fileIdx).CarrierFreq;
    line([Fc Fc], [0, 7000], 'Color','k')
    FigObj.plotfftEpochAvg_chans([intersect(ChansRight, ChansBack)], ...
        'Back-Right Chans fft (whole)', 1, [0 20], [0 7000] , fig);
    
    %Plot fft of just the carrier freqencies of channel 9, 10, 11 an 12
    %with a black line at the carrier frequency
    fig = figure;
    hold
    Fc = files(fileIdx).CarrierFreq;
    line([Fc Fc], [0, 7000], 'Color','k')
    FigObj.plotfftEpochAvg_chans([9:12], ...
        ' Chans 9:12 (Carrier)', 2, [0 20], [0 2000] , fig);
   
end