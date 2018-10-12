function fig = DrawEventLines(EEG, ERPName, fig, ylim, color)
%Draws lines at ERP times, draws with time (n / srate) in x axis
%Inputs
%   EEG [eeglab struct] - eeglab eeg struct
%       Uses EEG.event, EEG.srate, EEG.data
%   ERPName [str] - name of event
%   fig [figure struct] - Matlab figure to draw lines on
%       Default: create new figure
%   ylim [1 x 2] - [ymax ymin] limits of line height at event
%   color [1 x 3] - rgb color of line or matlab color str
%               (https://www.mathworks.com/help/matlab/ref/colorspec.html)
%       Default: [0 0 0]- black
    
    %Create new figure if figure is not sepcified
    if isempty(fig)
        fig = figure();
    end
    
    %Set ymax and ymin to the max and min val of eeg data 
    if isempty(ylim)
        ylim = [max(max(EEG.data)), min(min(EEG.data))];
    end
    
    %set Default color to black
    if isempty(color)
        color = [0 0 0];
    end
    
    %set current figure to fig
    set(0,'CurrentFigure',fig);
    hold
    
    %find latencies when events match
    events = EEG.event(:);
    ERPIdx = 1;
    for eventIdx = 1:length(events)
        if strcmp(events(eventIdx).type, ERPName)
            ERPEventLat(ERPIdx) = events(eventIdx).latency;
            ERPIdx = ERPIdx + 1;
        end
    end
    %set
    for ERPIdx = 1:length(ERPEventLat)
        Lat = ERPEventLat(ERPIdx);
        xlim = [Lat / EEG.srate, Lat / EEG.srate];
        line(xlim, ylim, 'Color', color);
    end
    
end