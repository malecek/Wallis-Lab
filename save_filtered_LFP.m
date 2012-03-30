function save_filtered_LFP(session, electrode, SpikeInfo, SpikeData)
% save_filtered_LFP(session, electrode, SpikeInfo, SpikeData)

raw_signal = SpikeData{SpikeInfo.LFPIndex(SpikeInfo.LFPID == electrode)};
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
    save(['~/Science/wallis/filtered_LFP/' int2str(electrode) '-' ...
          num2str(f)], 'filtered_LFP')
end