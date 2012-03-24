% Suppress the warning that occurs every time regstats is called.
warning('off', 'stats:pvaluedw:ExactUnavailable');
cd ~/data/wallis/
session_dirs = dir;
for i = 1:length(session_dirs)
    session = session_dirs(i).name;
    if session(1) == 'A' | session(1) == 'B'
        cd(session)
        [SpikeInfo, ~, ~, ~] = spk_read([session '.spk']);
        for j = 1:length(SpikeInfo.LFPID)
            electrode = SpikeInfo.LFPID(j);
            stats = reward_LFP_regression(session, electrode, SpikeInfo);
            save([int2str(electrode) '_reward_regression'], 'stats');
        end
        fclose('all');
        cd('../..')
    end
end