classdef EEG_images < handle
    %Creates and saves images for EEG
    
    properties
        EEG             % [eeglab struct] data structure for EEG data
        Epochs          % [struct] epochs for epoched data
        % Members:
        %   name     [str] - name identifier
        %   Epoch    [eeglab struct] - Actual Epoch information
        %   EpochsAvg[numChans x numData(per Epoch)] - average epoch value
        inputEEGfile    % [path] full path of EEG dat

        desc            % [str] Name used for headers
        fileDesc        % [str] Name used for files
        
        
    end
    properties (SetAccess = protected)
        saveFlag = false; % [bool] 1 if image should be saved
        outputFigDir      % [path] full directory to where images are saved 
        %                       (if saveFlag = 1)
        srate           % [scalar] sample rate for EEG
    end
    properties (Dependent = true)
        EpochAvg_check  % [numChans X numData] averaged epoch of checkerboard data
        EpochAvg_rest   % [numChans X numData] averaged epoch of rest data
        EpochAvg_misc   % [numChans X numData] averaged epoch of misc data
        EEG_fileDesc    % [str] Description used for file of images (no spaces)
        %                   in form: dir/[EEG_fileDesc]_[imageDesc].png
    end
    
    methods
        function self = EEG_images(Desc)
            %constructor
            %input
            %   Desc [str] - Description of EEG used for headers and file
            %   names
            self.desc = Desc;
        end
        
        function loadEEG_set(self, input_path)
            %load set file for EEG
            
            %Load in EEG
            self.EEG = pop_loadset(input_path);
            self.srate = self.EEG.srate;
            self.inputEEGfile = input_path;
            
        end
        
        function loadEEG_bv(self, input_path)
            %Load Brain Vision format data into EEG
        end % empty
        
        function EpochEEG_checkNRest(self)
            %Epoch EEG data and average Epochs
        end % empty
        
        function EpochPeriod_Continous(self, epoch_start, epoch_end, ...
                windowLength, period, ...
                epoch_name)
            %Epoch EEG from start time to end time periodically
            %Input:
            %   epoch_start [scalar] - start time in seconds for first Epoch
            %   epoch_end   [scalar] - end time in seonds for last epoch
            %   epoch_dur   [scalar] - duration in seconds of epoch
            %   epoch_name  [str] - name of Epoch (if multiple Epochs are
            %       stored
            
            %Set add eeglab events to EEG to signify start of epochs
            EEG_events =  ...
                EEG_Epoch_Periodic(self.EEG, ...
                                    epoch_start * self.srate,...
                                    epoch_end * self.srate, ...
                                    period * self.srate, ...
                                    'EpochTag');
            
            %Create new Epoch
            self.Epochs(end+1).name  = epoch_name;
            
            %split EEG into Epochs 
            self.Epochs(end).Epoch = pop_epoch( EEG_events, {'EpochTag'}, [0  ,windowLength]);
            
            %find mean of all epochs
            self.Epochs(end).EpochsAvg = mean(self.Epochs(end).Epoch.data, 3);
        end
        
        function fig = create_cwt_singleChan(self, EpochNum, chan)
            % create wavlet transform figure to show freq response over
            %   time for the averaged epoch
            %       Saves figure when saveflag is set
            % Input:
            %   EpochNum [scalar] - number of epoch *TODO change to name
            %   chan [scalar] - Channel number to plot
            % Output:
            %   fig [figure] - figure to which cwt is drawn 
            %                   (for save  and/or hold purposes)
            
            %Get the header for the cwt in format [Epoch Description. 
            ChanName = self.EEG.chanlocs(chan).labels;
            header = [self.desc, '; cwt; ', ChanName];
            
            %Get Average of Epochs
            EpochAvg = self.Epochs(EpochNum).EpochsAvg;
            
            %Create CWT on new figyre
            fig = figure;
            cwt(double(EpochAvg(chan,:)), self.srate);
            title(header);
            
            %Save figure if saveFlag is set to
            % [outputdir]/cwts/[filename].png
            dir = [self.outputFigDir, 'cwts', filesep];
            fileName = [self.fileDesc, '_' ,ChanName];
            self.saveFigs(fig, dir, fileName);  
            
        end %Not finished
        
        function [fft_data, f] = EEG_fft(self, data)
            %get fft of eeg data
            %Inputs:
            %   data     [numChans x numPoints] - EEG channel data by sample
            %Outputs:
            %   fft_data [numChans x numPoints] - fft dta by sample
            %   f        [sizefft]  - frequency axis of fft
            
            
            %preallocate size of fft_data for lower speed and ram usage
            size_fft = size(data);
            fft_data = zeros(size_fft);
            
            %calculate fft data at each channel *this may be possible
            %       without for loop
            for chanIdx = 1:size(data, 1)
                fft_data(chanIdx, :) = fft(data(chanIdx, :));
            end
            
            %
            f = linspace(0, self.srate, length(fft_data));
            
        end
        
        function plotffts_chans(self, chans, targetFreqs, limits, colors)
        %plots ffts for sets of data with target frequencies
        %****not finished needs figure saving, titles, default limits and
        %colors
        %Input: 
        %   Chans [1 x numChans] - channal numbers to plot
        %   targetFreqs [1 x numfreqs] - target frequencys to indicate
        %   limits - [fmin fmax ymin ymax] fft limits 
        %   colors - {numchans cells of [3 x 1] color}
        
            %get fft of all the chans
            for chanIdx = 1:length(chans)
                [fft_data(chanIdx, :), f] = self.EEG_fft( ...
                    self.Epochs.EpochsAvg(chans(chanIdx), :));
            end
            
            %create figure with axis limits and chan names for title
            fig = figure;
            xlim(limits(1:2));
            ylim(limits(3:4));
            %change header to show channels being plaoted
            header = self.desc;
            title(header);
            hold;
            
            %Draw target frequencies
            for targetIdx = 1:length(targetFreqs)
                targetFreq = targetFreqs(targetIdx);
                %check if freq is within draw range
                if targetFreq >= limits(1) && targetFreq <= limits(2)
                    %black line at target frequency spanning the y axis
                    line([targetFreq, targetFreq], [limits(3), limits(4)], 'color', 'k');
                end
            end
            
            %Draw fft data in order
            for chanIdx = 1:length(chans)
                plot(f, abs(fft_data(chanIdx, :)), 'linewidth' , 1);
            end
            
            
        end
        function [fig,  avgPower]= avgPowerPlot_single(self, data, freqBand, excChan, makeFigFlag)
            %plot an average power plot of head using eeglab topoplot
            %Inputs: 
            %   data: [numChans x numData] time data to plot
            %   freqband [1 x 2] freqcy band in Hz to aerage across
            %   excChan % not implemented
            avgPower = [];
            incChans = [];
            for chanIdx = 1:size(data, 1)

                if chanIdx ~= excChan
                    avgPower(chanIdx) = ...
                        bandpower(data(chanIdx,:), self.srate, [freqBand(1) freqBand(2)]);
                    incChans(end + 1) = chanIdx;
                end
            end
            fig = nan;
            if (makeFigFlag)
                fig = figure;
                title(self.desc);
                topoplot(avgPower(incChans), self.EEG.chanlocs(incChans));
            end
        end
        function fig = plotFFTLoc(self, data, targetFreqs, limits, colors) % Needs debugging
            %plot fft at all chans using eeglab plottopo func using
            %Input:
            %   data    [1 x numDataSetsCell{numChans x numData}] - 
            %               raw data to plot, will plot each data set in
            %               order
            %   targetFreqs
            %   limits  [1 x 4] - the [Xmin, Xmax, Ymin, Ymax] limits of 
            %                               the fft to show in Hz
            %           Default: [0, 60, min(data), max(data)
            %   colors  [1 x numDatasets(Color vectors)]
            
            numDataSets = size(data, 3);
            
            %find ffts of data
            for dataIdx = 1:numDataSets
                [EEG_ft(:,:,dataIdx), f] = self.EEG_fft(data{dataIdx});
            end
            numfftData = size(EEG_ft, 2);            
            %set  x Limits of window if not specified
            if isempty(limits)
                limits([1, 2]) = [0 60]; % 0-60Hz on x axis
                limits([3, 4]) = [0,1*10^4]; %0-max power on y axis
            end
            %Find the index of f which is closest to the axit limits
            [~, freqLimitMaxIdx] = min(abs(f - limits(2)));
            [~, freqLimitMinIdx] = min(abs(f - limits(1)));
            
            %
            topoData = [];
            
            %Set target frequencies if they are specified
            if ~isempty(targetFreqs)
                for freqIdx = 1:length(targetFreqs)
                    %initailize all data to all zeroes
                    ftEmpty = ...
                        zeros(size(EEG_ft(:,freqLimitMinIdx:freqLimitMaxIdx,:)));
                    topoData = cat(3, topoData, ftEmpty);
                    
                    %find value closeset to target freq on x axis
                    [~, targetFreqIdx] = min(abs(f - targetFreqs(targetIdx)));
                    
                    %set target frequnecy value to -1 to replace with upper
                    %limitof ft, 
                    %*NOTE -1 is unique and wont apear in the abs of an ft
                    topoData(:, targetFreqIdx, end) = -1;
                end
            end
            
            %set data within limits of the ft data
            for ftIdx = 1:numDataSets
                ftData = abs(EEG_ft(:,freqLimitMinIdx:freqLimitMaxIdx,ftIdx));
                topoData = cat(3, topoData, ftData);      
            end
            
            %if y limits are not specified use max value within boundries
            if (length(limits) < 4) || isempty(limits([3,4]))
                limits([3, 4]) = [0,max(topoData(:))]; %0-max power on y axis
            end
             
            %Set target Freq values to the y limit
            for freqIdx = 1:length(targetFreqs)
                %set limit of target frequency *note target freq uses -1 as placeholder 
                topoData(:,:,freqIdx) =...
                    topoData(:,:,freqIdx) * -1 * limits(4);
            end
            
            %set default colors to red blue and green for first 3 datasets
            %and black for all others
            if isempty(colors)
                for colorIdx = 1:numDataSets
                    if colorIdx == 1
                        colors{colorIdx} = 'r';                    
                    elseif colorIdx == 2
                        colors{colorIdx} = 'b';            
                    elseif colorIdx == 3
                        colors{colorIdx} = 'g';
                    else
                        colors{colorIdx} = 'k';
                    end
                end
            end
            
            %put colors in reverse order for topo plot, for draw order,
            %putting target frequencies first
            
            topoColors = {};
            %Set target Freqs to dashed black
            for colorIdx = 1:length(targetFreqs)
                topoColors{colorIdx} = '--k';
            end
            %set colors in reverse order
            for datasetIdx = 1:numDataSets
                colorIdx = length(colors) - (datasetIdx - 1);
                topoColors{end + 1} = colors{colorIdx};
            end
            

            
            
            %draw topograph
            fig = figure;
            plottopo(topoData, ...
                'chanlocs', self.EEG.chanlocs, ...
                'frames', freqLimitMaxIdx, ...
                'title', self.desc, ...
                'limits', limits, ...
                'colors', topoColors, ...
                'ydir', 1);

        end
        
        function fig = plotEpochAvg_chans(self, chans, subtitle, epochNum, ylimit, fig)
            %plot the Average epoch with a boreder shade for mean standard error
            %*NOTE not finished no figure saving 
            %Inputs:
            %   chans [1 x n] - channels to plot
            %   subtitle [string] - subheading for graph title 
            %   epochNum [int] - The epoch number identifier for epoch to avg
            %       and plot
            %   ylimit [1 x 2] - The lower and upper y limit of graph
            %       Default - [-10, 10]
            %   fig [Mat fig obj] - figure for graph to be plotted on
            %       Default - New figure is created
            %Output:
            %   fig - figure with channels ploted
        
            %Use the raw epochs for epoch mean
            %EpochData = self.Epochs(epochNum).Epoch.data;
            %EpochMean = mean(EpochData, 3);
            EpochMean = self.Epochs(epochNum).EpochsAvg;
            

            %set time axis, at every sample
            t = (1 : length(EpochMean)) / self.srate;
            
            %create new figure if none is specified
            if isempty(fig)
                fig = figure;
            end
            
            %Use EEG description for title of graph
            header = {self.desc, subtitle};
            title(header);
            
            %set Y limit
            if isempty(ylimit)
                ylimit = [-10 10];
            end
            ylim(ylimit)
            
            
            xlabel('Time (s)')
            ylabel('Voltage (\muV)')
            hold;
            
            for chanIdx = 1:length(chans)
                chan = chans(chanIdx);
                plot(t, EpochMean(chan, :), 'linewidth',0.2)
            end
        
     
        end %Needs work
                
        function setsaveFigsFlag(self, outputDir, fileDesc)
            % set the save figs flag property to save figures generated to
            % output derectory
            % *Must Specify output directory and file description
            %Input:
            %   outputDir   [directory] - directory for figures to go
            %   fileDesc    [str in file format] file Description for file
            self.saveFlag = true;
            self.outputFigDir = outputDir;
            self.fileDesc = fileDesc;
            
        end
    end
    methods (Access = private)
        function saveFigs(self, fig, dir, filename)
        %Save figures 
            if self.saveFlag
                if ~exist(dir, 'dir')
                    mkdir(dir)
                end
                filepng = [dir, filename, '.png'];
                saveas(fig, filepng)
            end
        end
    end
end