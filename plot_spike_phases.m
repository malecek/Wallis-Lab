function plot_spike_phases(session, neuron)

cd(['~/data/wallis/' session])
[SpikeInfo, ~, ~, SpikeData] = spk_read([session '.spk']);
spike_times = SpikeData{SpikeInfo.NeuronIndex(SpikeInfo.NeuronID == neuron)};
spike_times = round(spike_times * 1000);
electrode = int2str(neuron);
electrode = [electrode(1:3) '0'];
cd LFP_time_series
load(electrode, 'lfp_time_series')
filtered_LFP = eegfilt(lfp_time_series', 1000, 14, 18);
LFP_phases = angle(hilbert(filtered_LFP));
spike_phases = LFP_phases(spike_times);
rose(spike_phases, 24)