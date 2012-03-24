function save_LFP_power_matrix(electrode, lfp_time_series, cue_times)
% save_LFP_power_matrix(electrode, lfp_time_series, cue_times)
% 
% LFP_power_matrix is the name of the variable saved.  It has
% frequencies X trials X ms in window.  The saved file is
% [electrodeID]-filtered_trials.mat.

n_trials = length(cue_times);
% Generate list of log_2-spaced frequencies.
frequencies = 2.^(0:0.5:8);
for i = 1:length(frequencies)
    freq = frequencies(i);
    sp = get_signal_parameters('sampling_rate',1000,...
                                             'number_points_time_domain',...
                                             length(lfp_time_series));
    g1 = design_chirplet(freq,sp);
    filtered_LFP = filter_with_chirplet('raw_signal', lfp_time_series, ...
                                        'signal_parameters', sp, ...
                                        'chirplet', g1);
    LFP_amplitude = abs(filtered_LFP.time_domain);
    normed_amp = (LFP_amplitude - mean(LFP_amplitude)) / std(LFP_amplitude);
    normed_power = normed_amp.^2;
    for j = 1:n_trials
        power_matrix(j,:)=normed_power(cue_times(j)-500:cue_times(j)+3250);
    end
    LFP_power_matrix(i, :, :) = power_matrix;
end
save([int2str(electrode) '-filtered_trials'], 'LFP_power_matrix')