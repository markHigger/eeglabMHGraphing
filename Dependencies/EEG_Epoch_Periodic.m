function EEG_output = EEG_Epoch_Periodic(EEG_input, latency_min, latency_max, duration, eventName)
   

eventIdx = 1;
for latency_current = latency_min:duration:latency_max
    latencies(eventIdx) = latency_current; %add event
    names{eventIdx} = eventName;
    eventIdx = eventIdx + 1;
end

EEG_output = pop_qbin_eeglab_insert_epochs(EEG_input,names,latencies);

end
