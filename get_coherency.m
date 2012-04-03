function [coherency fs] = get_coherency(encoding_neuron)
% [coherency fs] = get_coherency(encoding_neuron)
% 
% Returns array of spike-field coherences for a bunch of frequencies.
    
match = regexp(encoding_neuron, '-', 'split');
session = match{1};
neuron = str2num(match{2});
cd('~/Science/wallis/data')
[SpikeInfo, ~, ~, SpikeData] = spk_read([session '.spk']);
spike_struct = get_spike_struct(neuron, SpikeInfo, SpikeData);
electrode = round2(neuron, 10);
LFP = SpikeData{SpikeInfo.LFPIndex(SpikeInfo.LFPID == electrode)};
LFP = double(LFP);
LFP_by_trial = cut_LFP_by_trial(LFP, SpikeInfo);
LFP_by_trial = LFP_by_trial(:, 501:2001);
LFP_by_trial = LFP_by_trial';

% spike_struct is a struct of dimension trial with a row vector of
% spike times in seconds (relative to trial start) for each trial.

% LFP_by_trial is now samples X trials.


params.Fs = 1000;
params.trialave = 1;
[coherency, ~, ~, ~, ~, fs] = coherencycpt(LFP_by_trial, spike_struct, params);