function spike_struct = get_spike_struct(neuron, SpikeInfo, SpikeData)
% spike_struct = get_spike_struct(neuron, SpikeInfo, SpikeData)
% 
% Structure array with dimension trials; each entry has ms into
% trial at which spike occurred.

trial_spikes = get_trial_spikes(SpikeInfo, SpikeData, neuron);
trial_spikes = trial_spikes(:, 501:2001);
for i = 1:size(trial_spikes, 1)
    spike_struct(i).times = find(trial_spikes(i, :));
end