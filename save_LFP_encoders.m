cd ~/data/wallis/
session_dirs = dir;
pos_encoders = [];
neg_encoders = [];
for i = 1:length(session_dirs)
    session = session_dirs(i).name;
    if session(1) == 'A' | session(1) == 'B'
        cd(session)
        [SpikeInfo, ~, ~, ~] = spk_read([session '.spk']);
        cd LFP_time_series
        for j = 1:length(SpikeInfo.LFPID)
            electrode = int2str(SpikeInfo.LFPID(j));
            load([electrode '_reward_regression'], 'stats');
            for i_f = 1:17
                if stats(i_f).fstat.pval < 0.001
                    if i_f < 10
                        f = ['0' int2str(i_f)];
                    else
                        f = int2str(i_f);
                    end
                    if stats(i_f).beta(2) < 0
                        neg_encoders = [neg_encoders; [session '-' ...
                                            electrode '-' f]];
                    elseif stats(i_f).beta(2) > 0
                        pos_encoders = [pos_encoders; [session '-' ...
                                            electrode '-' f]];
                    end
                end
            end
        end
        cd('../..')
    end
end
save('LFP_encoders', 'pos_encoders', 'neg_encoders')