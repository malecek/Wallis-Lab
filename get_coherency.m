function coherency = get_coherency(encoding_neuron)
% coherency = get_coherency(encoding_neuron)
% 
% Returns array of spike-field coherences for a bunch of frequencies.
    
match = regexp(encoding_neuron, '-', 'split');
session = match{1};
neuron = str2num(match{2});
cd('~/Science/wallis/data')
[SpikeInfo, ~, ~, SpikeData] = spk_read([session '.spk']);
spike_struct = get_spike_struct(neuron, SpikeInfo, SpikeData);

electrode = round2(neuron, 10)
frequencies = 2.^(0:0.5:8);
for i = 1:length(frequencies)
    LFP = SpikeData{SpikeInfo.LFPIndex(SpikeInfo.LFPID == electrode)};
    LFP = double(LFP);
    LFP_by_trial = cut_LFP_by_trial(LFP, SpikeInfo);
    params.Fs = 1000;
    params.fpass = [1 256];
    coherency = coherencycpt(LFP_by_trial, spike_struct, params);
    coherency = mean(C, 2);
end