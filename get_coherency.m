function coherency = get_coherency(encoding_neuron)
% coherency = get_coherency(encoding_neuron)
% 
% Returns array of spike-field coherences for a bunch of frequencies.
    
match = regexp(encoding_neuron, '-', 'split');
session = match{1};
neuron = str2num(match{2});
cd('~/Science/wallis/data')
[SpikeInfo, ~, ~, SpikeData] = spk_read([session '.spk']);
i_neuron = SpikeInfo.NeuronIndex(SpikeInfo.NeuronID == neuron);
spike_times = round(SpikeData{i_neuron}*1000);

electrode = round2(neuron, 10);
LFP = SpikeData{SpikeInfo.LFPIndex(SpikeInfo.LFPID == electrode)};
LFP = double(LFP);

% coherencycpt needs a time X trials matrix for the LFP.  We will
% build this by assuming that each 3000 ms segment of the session
% is a trial, cutting out the remainder at the end of the session.
remainder = mod(length(LFP), 3000);
LFP = LFP(1:end-remainder);
while spike_times(end) > length(LFP)
    spike_times = spike_times(1:end-1);
end
LFP = reshape(LFP, 3000, length(LFP)/3000);

params.Fs = 1000;
params.fpass = [1 256];
coherency = coherencycpt(LFP, spike_times, params);
coherency = mean(C, 2);