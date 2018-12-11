fileIdx = 1;
files = [];

inputDir = '~/Documents/NKI/EEG_Data/Processed_Data/20181102/';

epochTime = 20; %20 second epochs

%Load in 12Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0002_ET06_12_02_single_blink.set';
inputName = 'EEG_20181102_0002_ET06_12_02_single_raw.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 30; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 4;
files(end).startOffset = 0.5; %skip first 0.5s
files(end).desc = ['12 Hz / 0.2 Hz, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['0002_12_02_02_', num2str(files(end).EpSize), 's'];

Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0003_ET06_12_05_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 20; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 10;
files(end).startOffset = 0.5; %skip first 0.5s
files(end).desc = ['12 Hz / 0.5 Hz, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['0003_12_05_05_', num2str(files(end).EpSize), 's'];

% Load in 12Hz/1 Hz on both sides
inputName = 'EEG_20181102_0004_ET06_12_10_single_blink.set';
files(end + 1).path = {[inputDir, inputName]};
files(end).EpSize = 20; %epoch size in seconds creates 4 periods
files(end).EpPeriod = 5;
files(end).startOffset = 0.5; %skip first 0.5s
files(end).desc = ['12 Hz / 1 Hz, ', ...
    num2str(files(end).EpSize) 's window, ' ...
    num2str(files(end).EpPeriod) 's period '];
files(end).fileDesc = ['0004_12_10_10_', num2str(files(end).EpSize), 's'];


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
            if isempty(startOfEEG) && ~strcmp(EEG_event.type, 'S255')
               startOfEEG = EEG_event.latency / FigObj.srate;
            else
                if strcmp(EEG_event.type, 'S255')
                    endOfEEG = EEG_event.latency / FigObj.srate;
                end
            end
            
        end
    end
    
    %create first epoch without BP filter
    FigObj.EpochPeriod_single( startOfEEG, ...
                                endOfEEG, files(fileIdx).EpSize, ...
                                files(fileIdx).EpPeriod, 'Epoch');
    
    %apply filters for next Epoch
    %FigObj.EEG = EEG_Bandpass_Matlab(FigObj.EEG, 3, 3.5, 3);
    FigObj.EEG = EEG_Bandpass_Matlab(FigObj.EEG, 11, 13, 3);
    %FigObj.EEG = EEG_Notch_Matlab(FigObj.EEG, 7.5, 4, 3);
    %start at half second and create epochs every 10 seconds
    
    %second epoch is BP
%     FigObj.EpochPeriod_single( startOfEEG, ...
%                                 endOfEEG, files(fileIdx).EpSize, ...
%                                 files(fileIdx).EpPeriod, 'Epoch');
                                    
    %save figures                       
    FigObj.setsaveFigsFlag(outputDir, files(fileIdx).fileDesc);
    
%     %test plotting fft channels
%     FigObj.plotffts_single([7, 8], [0.2, 12], [0, 20, 0, 1000], 1);
    
    for colorIdx = 1:64
        colors{colorIdx} = [1 1 1] * colorIdx / 64;
    end
    
    %% plot non bandpassed epochs
    fig = FigObj.plotEpochAvg_MSE_single( [1:5], colors, 1);
    fig.Renderer = 'Painters';
    figname = [outputDir, 'allChans/',files(fileIdx).fileDesc, '_allChans'];
    %saveas(fig, figname,'pdf')
%     
    %% plot bandpassed
%     fig = FigObj.plotEpochAvg_MSE_single( 9, colors, 2);
%     fig.Renderer = 'Painters';
%     figname = [outputDir, 'allChans/',files(fileIdx).fileDesc, '_bp_01_3_allChans'];
%     saveas(fig, figname,'pdf')
    
    EpochData = FigObj.Epochs(2).EpochsAvg;
    chanrms = [];
    preCheckData = [];
    preCheckrms = [];
    for chanIdx = 1:64
        %Find local Extrema using matlab 'findpeaks' function.
        % *find peaks only works for maxima, so the min are found seperatly
        
        %find local maxima
        [MaxPks, MaxLocs] = findpeaks(EpochData(chanIdx,:));
        
        %find local minima by finding maxima of inverted function
        [NegMinPks, MinLocs] = findpeaks(-1 * EpochData(chanIdx,:));
        MinPks = NegMinPks * -1;
        
        %Create 2xNumExtrema matrix of extrema
        Pks = horzcat(MaxPks, MinPks);
        Locs = horzcat(MaxLocs, MinLocs);
        ExtremaUnsort = vertcat(Locs, Pks)';
        Extrema = sortrows(ExtremaUnsort);
        
        %find relative distance of extrema 
        ExtremaRel = Extrema(2:end, :) - Extrema(1:end - 1, :);
        ExtremaAbs = abs(ExtremaRel);
        ExtremaMax(chanIdx) = max(ExtremaAbs(:,2));
        
        %find normalized max
        %find rms voltage of each channel
        chanrms(chanIdx) = sqrt(sum(EpochData(chanIdx,:).^2) / length(EpochData(chanIdx,:)));
        chanPower(chanIdx) = sum(EpochData(chanIdx,:).^2) / length(EpochData(chanIdx,:));
        %Find rms Avg of voltage before start of checkerboard for
        %normalization
        preCheckData = FigObj.EEG.data(chanIdx, [1:(startOfEEG * FigObj.srate)]);
        preCheckrms(chanIdx) = sqrt(sum(preCheckData.^2) / length(preCheckData));
        
        
        %MaxNorm(chanIdx) = ExtremaMax(chanIdx) / chanrms(chanIdx);
        MaxNorm(chanIdx) = ExtremaMax(chanIdx) / preCheckrms(chanIdx);
        
        
        
        %find peaks over 2 std from mean
%         peakMean = mean(ExtremaAbs(:,2));
%         peakStd = std(ExtremaAbs(:,2));
%         peakcuttoff = peakMean + 2*peakStd;
%         highPeakIdx = (abs(ExtremaAbs(:,2) - peakMean) > peakStd);
%         outlierValues = ExtremaAbs(highPeakIdx,2)
        %scatter(Extrema(:,1) / 500, Extrema(:,2))
        %scatter(Extrema(2:end,1) / 500, ExtremaRel(:,2))
        %figure
        %hist(abs(ExtremaRel(:,2)))
    end
     %figure
     %topoplot(ExtremaMax, FigObj.EEG.chanlocs)
%     figure
    %topoplot(MaxNorm([1:31, 33:64]), FigObj.EEG.chanlocs([1:31, 33:64]))
%     topoplot(chanPower([1:31, 33:64]), FigObj.EEG.chanlocs([1:31, 33:64]))
%     title({FigObj.desc, 'Channel Power'});
%     caxis([-7, 7])
%     
%     fig = figure;
%     topoplot(chanrms([1:31, 33:64]), FigObj.EEG.chanlocs([1:31, 33:64]))
%     title({FigObj.desc, 'Channel RMS'});
%     caxis([-4, 4])
    
%     fig.Renderer = 'Painters';
%     figname = [outputDir,files(fileIdx).fileDesc, '_rms_topo'];
%     saveas(fig, figname,'pdf')
%     
%     bar(MaxNorm)
% %     ylim([0 600])
%     
%     xlabel('Chan #');
%     ylabel('\DeltaV (preCheck)/V_{rms}')
%    
end