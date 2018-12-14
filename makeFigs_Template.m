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

%Eexample of specific file
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
    %mkdir(outputDir)
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
    
    %plot fft of non-epoched data from 0 to 20 Hz, 
    %NOTE:this will use the bandpassed EEG, to use non-bandpassed EEG
    %reload set file
    FigObj.plotfft_whole_chans([9], 'fft of whole channel', [0 20 0 100000]);
    
    %Plot all channel plot, and save figure
    %This uses Epoch 1, with limits set to -10 to 10 and generate a new
    %figure
    fig = FigObj.plotEpochAvg_chans( [1:64], 'All Chans', 1,[-10 10], []);
    %use painters renderer to save as vector pdf for better image quality
    fig.Renderer = 'Painters'; 
    figname = [outputDir,files(fileIdx).fileDesc, '_AllChans'];
    %saveas(fig, figname,'pdf') %dont actually save because this is a test
    
    %Plot Carrier all channel plot, and save figure
    %This uses Epoch 1, with limits set to -10 to 10 and generate a new
    %figure
    fig = FigObj.plotEpochAvg_chans( [1:64], 'All Chans Carrier', 2,[-10 10], []);
    fig.Renderer = 'Painters';
    figname = [outputDir,files(fileIdx).fileDesc, '_Carrier_AllChans'];
    
    %% Make topograph hilbert animation
   
    %take hilbert transform and set it to a new Epoch structure to get
    %carrier envelope
    %NOTE: this struct (FigObj.Epochs(3)) will only contain contain 
    %       FigObj.Epochs(3).EpochsAvg, which is used for all the epoch
    %       graphing, Epochs.Epoch and Epochs.name will be empty
    for chanIdx = 1:64
        FigObj.Epochs(3).EpochsAvg(chanIdx,:) = ...
            abs(hilbert(FigObj.Epochs(2).EpochsAvg(chanIdx,:)));
    end
    
    %plot Fp1 and Fp2, The envalope for these channels is fairly low, so
    %the axes are reduced to [0,1], also note, the envelope is always
    %positive
    FigObj.plotEpochAvg_chans( [1:2], 'Envelope for Fp1 & Fp2', 3,[0 1], []);
    
    %Make animations with hilbert transforms
    
    %find length of envelope in points
    envelopeLength = length(FigObj.Epochs(3).EpochsAvg);
    numBins = 20; % make a numBins image gif (this can change)
    binLength = floor(envelopeLength / numBins);
    
    %make figures for a GIF of Epoch, Carrier Epoch and topo graph 
    GifDir = [outputDir, files(fileIdx).fileDesc, '_GIFImages/'];
    if ~exist(GifDir, 'dir')
        %mkdir(GifDir)
    end
    for sampIdx = 1:binLength:envelopeLength
        
        fig = figure;
        
        %average a bin 
        %Find the Mean value of the envelope within the bin at each channel
        envBin = FigObj.Epochs(3).EpochsAvg(:,[sampIdx:(sampIdx + binLength -1)]);
        avgEnvelope =  mean(envBin, 2);
        
        %Draw topoGraph excluding chan 32 (far location obscures topoplot)
        subplot(2,2,[2,4]);  % Draw on full right side of plot
        topoplot(avgEnvelope([1:31, 33:64], :), FigObj.EEG.chanlocs([1:31, 33:64]))
        caxis([-1.3, 1.3]); % fairly arbitrary limit
        title({FigObj.desc, 'Carrier Amplitude'});
        
        
        %draw all channels full epoch
        subfig = subplot(2,2,1); %Draw on top left
        hold
        FigObj.plotEpochAvg_chans( [1:64],'All Channels: Full Epoch', ...
            1, [-20 20], subfig);
        
        %set referece line to the time in seconds of the plot
        refTime = (sampIdx) / FigObj.srate;
        lineMax = 60; % this can be any number higher than the y lim of graph
        lineMin = -60;
        refLine = line([refTime, refTime], [lineMin, lineMax]);
        refLine.Color = 'k';
        refLine.LineWidth = 2;
        
        %Draw bandpassed line
        subfig = subplot(2,2,3); %Draw on top right
        hold
        FigObj.plotEpochAvg_chans( [1:64],'All Channels: Carrier Freq', ...
            2, [-20 20], subfig);
        
        refLine = line([refTime, refTime], [lineMin, lineMax]);
        refLine.Color = 'k';
        refLine.LineWidth = 2;
        
        %Save figure
        figname = [GifDir, '_carrier_topo_', ...
            num2str(floor(sampIdx/FigObj.srate)), 's'];
        saveas(fig, figname,'png')
    end
    
    
end