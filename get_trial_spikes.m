function trial_spikes = get_trial_spikes(SpikeInfo, SpikeData, neuron)
% trial_spikes = get_trial_spikes(SpikeInfo, SpikeData, neuron)
% 
% Return trials X ms relative to reward cue (-550 to 3299).

cue_time_array = get_cue_times(SpikeInfo);
i_neuron = SpikeInfo.NeuronIndex(SpikeInfo.NeuronID == neuron);
spike_times = round(SpikeData{i_neuron}*1000);
trial_spikes = zeros(length(cue_time_array),3850);
for i = 1:length(cue_time_array)
    cue_time = cue_time_array(i);
    spikes_in_window = spike_times(spike_times > cue_time-551 & ...
                                   spike_times < cue_time+3300);
    spikes_in_window = spikes_in_window-cue_time+551;
    for j = 1:length(spikes_in_window)
        spike_time = spikes_in_window(j);
        trial_spikes(i, spike_time) = 1000;
    end
end