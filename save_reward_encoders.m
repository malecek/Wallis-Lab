cd ~/data/wallis/
session_dirs = dir;
pos_encoders = [];
neg_encoders = [];
for i = 1:length(session_dirs)
    session = session_dirs(i).name;
    if session(1) == 'A' | session(1) == 'B'
        cd(session)
        [SpikeInfo, ~, ~, ~] = spk_read([session '.spk']);
        for j = 1:length(SpikeInfo.NeuronID)
            neuron = int2str(SpikeInfo.NeuronID(j));
            load([neuron '_reward_regression'], 'stats');
            if stats.fstat.pval < 0.001
                if stats.beta(2) < 0
                    neg_encoders = [neg_encoders; [session '-' neuron]];
                elseif stats.beta(2) > 0
                    pos_encoders = [pos_encoders; [session '-' neuron]];
                end
            end
        end
        cd('..')
    end
end
save('encoders', 'pos_encoders', 'neg_encoders')