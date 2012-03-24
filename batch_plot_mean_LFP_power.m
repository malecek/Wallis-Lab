cd ~/data/wallis

load encoders
for i = 1:length(pos_encoders)
    session_neuron = pos_encoders(i, :);
    [session, neuron] = strtok(session_neuron, '-');
    electrode = str2num([neuron(2:4) '0']);
    LFP_power = get_LFP_power(session, electrode);
    plot_mean_LFP_power([session '-' int2str(electrode)], LFP_power)
end
for i = 1:length(neg_encoders)
    session_neuron = neg_encoders(i, :);
    [session, neuron] = strtok(session_neuron, '-');
    electrode = str2num([neuron(2:4) '0']);
    LFP_power = get_LFP_power(session, electrode);
    plot_mean_LFP_power([session '-' int2str(electrode)], LFP_power)
end