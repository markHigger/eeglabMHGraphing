function EEG = pop_qbin_eeglab_insert_epochs(EEG_input,epochNameList,epochLatency)
% Epoch times input as latency values



%% Load File
EEG = eeg_checkset( EEG_input );



%% Insert event codes
eventSize = size(EEG.event,2);
ureventSize = size(EEG.urevent,2);
for ii = 1:length(epochNameList)
    EEG.event(eventSize+ii).latency = epochLatency(ii);
    EEG.event(eventSize+ii).channel = 0;
    EEG.event(eventSize+ii).duration = 0;
    EEG.event(eventSize+ii).type = epochNameList{ii};
    EEG.event(eventSize+ii).code = 'Stimulus';
    
    EEG.event(eventSize+ii).urevent = ureventSize+ii;
    EEG.urevent(ureventSize+ii).latency = EEG.event(eventSize+ii).latency;
    EEG.urevent(ureventSize+ii).duration = EEG.event(eventSize+ii).duration;
    EEG.urevent(ureventSize+ii).type = EEG.event(eventSize+ii).type;
    EEG.urevent(ureventSize+ii).code = EEG.event(eventSize+ii).code;
end
EEG = eeg_checkset( EEG);