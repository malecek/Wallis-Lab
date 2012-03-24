% Suppress the warning that occurs every time regstats is called.
warning('off', 'stats:pvaluedw:ExactUnavailable');
cd ~/data/wallis/
session_dirs = dir;
for i = 1:length(session_dirs)
    session = session_dirs(i).name;
    if session(1) == 'A' | session(1) == 'B'
        cd(session)
        [SpikeInfo, ~, ~, ~] = spk_read([session '.spk']);
        for j = 1:length(SpikeInfo.NeuronID)
            neuron = SpikeInfo.NeuronID(j);
            stats = reward_regression(session, neuron);
            save([int2str(neuron) '_reward_regression'], 'stats');
        end
        fclose('all');
        cd('..')
    end
end