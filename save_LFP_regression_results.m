function save_LFP_regression_results(session, electrode, SpikeInfo, SpikeData)
% save_filtered_LFP(session, electrode, SpikeInfo, SpikeData)

raw_signal = SpikeData{SpikeInfo.LFPIndex(SpikeInfo.LFPID == electrode)};
% LFP is saved as an array of integers, and fft requires double precision.
raw_signal = double(raw_signal);
sp = get_signal_parameters('sampling_rate',1000,'number_points_time_domain',...
                                         length(raw_signal));
frequencies = 2.^(0:0.5:8);
for i = 1:length(frequencies)
    f = frequencies(i);
    g.center_frequency = f;
    g.fractional_bandwidth = 0.25;
    g.chirp_rate = 0;
    g = make_chirplet('chirplet_structure', g, 'signal_parameters', sp);
    filtered_LFP = filter_with_chirplet('raw_signal', raw_signal, ...
                                        'signal_parameters', sp, ...
                                        'chirplet', g);
    % The filtered time domain is complex; take the absolute value to get the
    % amplitude.
    filtered_LFP = abs(filtered_LFP.time_domain);
    LFP_by_trial = cut_LFP_by_trial(filtered_LFP, SpikeInfo);
    save_string = ['LFP_regression/' session '-' int2str(electrode) ...
                   '-' regexprep(num2str(f), '\.', '_')];
    save_regression_results(SpikeInfo, LFP_by_trial, save_string)
end