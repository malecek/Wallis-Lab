function save_regression_results(SpikeInfo, data_by_trial, save_string)
% save_regression_results(SpikeInfo, data_by_trial, save_string)
% 
% Save betas and p-values for sliding regression from -500 to 3250
% relative to the reward cue.  The regression uses a 200 ms window
% (centered on the points in the range mentioned) and moves in 10 ms steps.

reward_conditions = get_reward_conditions(SpikeInfo);
betas = [];
p_values = [];
r_squareds = [];
for i = 1:10:size(data_by_trial,2)-199
    window_mean = mean(data_by_trial(:, i:i+199), 2);
    stats = regstats(window_mean, reward_conditions);
    betas = [betas; stats.beta(2)];
    p_values = [p_values; stats.fstat.pval];
    r_squareds = [r_squareds; stats.rsquare];
end
save(['~/Science/wallis/' save_string], 'betas', 'p_values', 'r_squareds')