# eeglabMHGraphing
Custom graphing tools for eegalab

Most functions are implemented in the EEG_images class.   

The main properties of the EEG_images class are as follows

        EEG             % [eeglab struct] data structure for EEG data
        
        Epochs          % [struct] epochs for epoched data
        % Members:
        %   name     [str] - name identifier
        %   Epoch    [eeglab struct] - Actual Epoch information
        %   EpochsAvg[numChans x numData(per Epoch)] - average epoch value
        inputEEGfile    % [path] full path of EEG dat

        desc            % [str] Name used for headers
        
        fileDesc        % [str] Name used for files
        
For an example of how this is used please refer to makeFigs_Template.m which has example code and explainations for image usage

For specific use cases of ceritain functions you can refer to the old makeFigs files, however they may not run immediatly since class method names and inputs may have changed

For any questions or concerns feel free to reach me at markbhigger@gmail.com
