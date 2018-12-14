
fileIdx = 1;
%% import EOG
files_EOG = [];

inputDir_EOG = '~/Documents/NKI/EEG_Data/Processed_Data/20181102/';

epochTime = 20; %20 second epochs

%Load in 12Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0002_ET06_12_02_single_blink.set';
files_EOG(end + 1).path = {[inputDir_EOG, inputName]};
files_EOG(end).desc = ['12 Hz / 0.2 Hz, ', num2str(epochTime) 's Epoch'];
files_EOG(end).fileDesc = ['0002_12_02_', num2str(epochTime), 's'];
files_EOG(end).EpSize = epochTime; %epoch size in seconds creates 4 periods
files_EOG(end).EpPeriod = 5;
files_EOG(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0003_ET06_12_05_single_blink.set';
files_EOG(end + 1).path = {[inputDir_EOG, inputName]};
files_EOG(end).desc = ['12 Hz / 0.5 Hz, ', num2str(epochTime) 's Epoch'];
files_EOG(end).fileDesc = ['0003_12_02_', num2str(epochTime), 's'];
files_EOG(end).EpSize = epochTime; %epoch size in seconds creates 10 periods
files_EOG(end).EpPeriod = 2;
files_EOG(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0004_ET06_12_10_single_blink.set';
files_EOG(end + 1).path = {[inputDir_EOG, inputName]};
files_EOG(end).desc = ['12 Hz / 1 Hz, ', num2str(epochTime) 's Epoch'];
files_EOG(end).fileDesc = ['0004_12_10_', num2str(epochTime), 's'];
files_EOG(end).EpSize = epochTime; %epoch size in seconds creates 20 periods
files_EOG(end).EpPeriod = 2;
files_EOG(end).startOffset = 0.5; %skip first 0.5s

%Load in 7.5 Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0005_ET06_75_02_single_blink.set';
files_EOG(end + 1).path = {[inputDir_EOG, inputName]};
files_EOG(end).desc = ['7.5 Hz / 0.2 Hz, ', num2str(epochTime) 's Epoch'];
files_EOG(end).fileDesc = ['0005_75_02_', num2str(epochTime), 's'];
files_EOG(end).EpSize = epochTime; %epoch size in seconds creates 3 periods
files_EOG(end).EpPeriod = 5;
files_EOG(end).startOffset = 0.5; %skip first 0.5s

%% import no EOG
files_noEOG = [];

inputDir_noEOG = '~/Documents/NKI/EEG_Data/Processed_Data/20181102_noEOG/';

epochTime = 20; %20 second epochs

%Load in 12Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0002_ET06_12_02_single_noEOG_blink.set';
files_noEOG(end + 1).path = {[inputDir_noEOG, inputName]};
files_noEOG(end).desc = ['12 Hz / 0.2 Hz no EOG, ', num2str(epochTime) 's Epoch'];
files_noEOG(end).fileDesc = ['0002_12_02_', num2str(epochTime), 's'];
files_noEOG(end).EpSize = epochTime; %epoch size in seconds creates 4 periods
files_noEOG(end).EpPeriod = 5;
files_noEOG(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0003_ET06_12_05_single_noEOG_blink.set';
files_noEOG(end + 1).path = {[inputDir_noEOG, inputName]};
files_noEOG(end).desc = ['12 Hz / 0.5 Hz no EOG, ', num2str(epochTime) 's Epoch'];
files_noEOG(end).fileDesc = ['0003_12_02_', num2str(epochTime), 's'];
files_noEOG(end).EpSize = epochTime; %epoch size in seconds creates 10 periods
files_noEOG(end).EpPeriod = 2;
files_noEOG(end).startOffset = 0.5; %skip first 0.5s

%Load in 12Hz/0.5 Hz on both sides
inputName = 'EEG_20181102_0005_ET06_12_10_single_noEOG_blink.set';
files_noEOG(end + 1).path = {[inputDir_noEOG, inputName]};
files_noEOG(end).desc = ['12 Hz / 1 Hz no EOG, ', num2str(epochTime) 's Epoch'];
files_noEOG(end).fileDesc = ['0004_12_10_', num2str(epochTime), 's'];
files_noEOG(end).EpSize = epochTime; %epoch size in seconds creates 20 periods
files_noEOG(end).EpPeriod = 2;
files_noEOG(end).startOffset = 0.5; %skip first 0.5s

%Load in 7.5 Hz/0.2 Hz on both sides
inputName = 'EEG_20181102_0005_ET06_75_02_single_noEOG_ica.set';
files_noEOG(end + 1).path = {[inputDir_noEOG, inputName]};
files_noEOG(end).desc = ['7.5 Hz / 0.2 Hz no EOG, ', num2str(epochTime) 's Epoch'];
files_noEOG(end).fileDesc = ['0005_75_02_', num2str(epochTime), 's'];
files_noEOG(end).EpSize = epochTime; %epoch size in seconds creates 3 periods
files_noEOG(end).EpPeriod = 5;
files_noEOG(end).startOffset = 0.5; %skip first 0.5s

outputDir = '~/Documents/NKI/eeglabMHGraphing/figures/20181102_EOGComp/';
power_EOG_05_70 = [];
power_noEOG_05_70 = [];
for fileIdx = 1:length(files_EOG)
    %Create EEG images object for current file
    FigObj_wEOG = EEG_images(files_EOG(fileIdx).desc);
    FigObj_noEOG = EEG_images(files_noEOG(fileIdx).desc);
    
    %Load EEG into object
    FigObj_wEOG.loadEEG_set(files_EOG(fileIdx).path);
    FigObj_noEOG.loadEEG_set(files_noEOG(fileIdx).path);
    
    %Find length of data in seconds
    endOfEEG =  length(FigObj_wEOG.EEG.data) / FigObj_wEOG.srate;
    
    %start at half second and create epochs every 10 seconds
    FigObj_wEOG.EpochPeriod_single( files_EOG(fileIdx).startOffset, ...
                                endOfEEG, files_EOG(fileIdx).EpSize, ...
                                files_EOG(fileIdx).EpPeriod, 'Epoch');
                            
    FigObj_noEOG.EpochPeriod_single( files_noEOG(fileIdx).startOffset, ...
        endOfEEG, files_noEOG(fileIdx).EpSize, ...
        files_noEOG(fileIdx).EpPeriod, 'Epoch');

    
      %% create field power bands for full band (0.5 - 70 Hz)
      [~, power_EOG_05_70(fileIdx,:)] = FigObj_wEOG.avgPowerPlot_single(FigObj_wEOG.EEG.data, [0.5 70], 32, []);
      [~, power_noEOG_05_70(fileIdx,:)] = FigObj_noEOG.avgPowerPlot_single(FigObj_noEOG.EEG.data, [0.5 70], 32, []);
    
      %find mean power between full bands
      power_mean_05_70(fileIdx, :) = ...
          (power_EOG_05_70(fileIdx, :) +  power_noEOG_05_70(fileIdx, :)) ./ 2;
      
      %find difference between eog and non eog
      power_diffs_05_70(fileIdx, :) = ...
          abs(power_EOG_05_70(fileIdx, :) - power_noEOG_05_70(fileIdx, :));
      
      power_normDiffs(fileIdx, :) = ...
          power_diffs_05_70(fileIdx, :) ./ power_mean_05_70(fileIdx, :);
      
      fig = figure;
      bar(power_normDiffs(fileIdx,:));
      title(['Run #', num2str(fileIdx) + 1, '; 0.5 - 70 Hz; % power change']);
      ylim([0, .50]);
      ylabel('Percent Change')
      xlabel('Chan Number')
      
      figName = [outputDir, 'Run', num2str(fileIdx) + 1, '_Full_pctChngBar.png'];
      saveas(fig, figName);
      
  %% create alpha power bands
          
      %create field power bands for Alpha band (7.5 - 12.5 Hz)
      [~, power_EOG_alpha(fileIdx,:)] = FigObj_wEOG.avgPowerPlot_single(FigObj_wEOG.EEG.data, [7.5 12.5], 32, []);
      [~, power_noEOG_alpha(fileIdx,:)] = FigObj_noEOG.avgPowerPlot_single(FigObj_noEOG.EEG.data, [7.5 12.5], 32, []);
    
      %find mean power between full bands
      power_mean_alpha(fileIdx, :) = ...
          (power_EOG_alpha(fileIdx, :) +  power_noEOG_alpha(fileIdx, :)) ./ 2;
      
      %find difference between eog and non eog
      power_diffs_alpha(fileIdx, :) = ...
          abs(power_EOG_alpha(fileIdx, :) - power_noEOG_alpha(fileIdx, :));
      
      power_normDiffs_alpha(fileIdx, :) = ...
          power_diffs_alpha(fileIdx, :) ./ power_mean_alpha(fileIdx, :);
      
      fig = figure;
      bar(power_normDiffs_alpha(fileIdx,:));
      title(['Run #', num2str(fileIdx) + 1, '; Alpha(7.5 - 12.5 Hz); % power change']);
      ylim([0, .50]);
      ylabel('Percent Change')
      xlabel('Chan Number')
      
      %save figures for alpha band                      
      figName = [outputDir, 'Run', num2str(fileIdx) + 1, '_Alpha_pctChngBar.png'];
      saveas(fig, figName);
      
end