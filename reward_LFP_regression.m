function stats = reward_LFP_regression(session, electrode, SpikeInfo)
% reward_LFP_regression(session, electrode, SpikeInfo)
    
cd(['~/data/wallis/' session '/LFP_time_series'])
load([int2str(electrode) '-filtered_trials'], 'LFP_power_matrix')
% LFP_power_matrix has frequencies X trials X ms from -500-3250
% relative to the reward cue.  To classify whether electrodes are
% reward selective, use just 0-1500 ms (i.e., from the cue onset to
% the end of the first delay period).
LFP_power_matrix = LFP_power_matrix(:, :, 501:2001);
% Use the mean from 0-1500 ms for each trial.  mean_power is
% frequencies X trials.
mean_power = mean(LFP_power_matrix, 3);
reward_conditions = get_reward_conditions(SpikeInfo);
% Make reward_conditions a column vector.
reward_conditions = reward_conditions';
for i = 1:17
    freq_mean_power = mean_power(i, :);
    % Make freq_mean_power a column vector
    freq_mean_power = freq_mean_power';
    stats(i) = regstats(freq_mean_power, reward_conditions);
end