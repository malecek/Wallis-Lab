cd ~/data/wallis
session_dirs = dir;
for i = 1:length(session_dirs)
    session = session_dirs(i).name;
    if length(session) > 2 & session(1:3) == 'B21'
        cd(session)
        [SpikeInfo, ~, ~, SpikeData] = spk_read([session '.spk']);
        cue_times = get_cue_times(SpikeInfo);
        cd LFP_time_series
        for j = 1:length(SpikeInfo.LFPIndex)
            i_electrode = SpikeInfo.LFPIndex(j);
            lfp_time_series = SpikeData{i_electrode};
            lfp_time_series = double(lfp_time_series);
            electrode = SpikeInfo.LFPID(j);
            save_LFP_power_matrix(electrode, lfp_time_series, cue_times);
        end
        cd('../../')
        fclose('all');
    end
end