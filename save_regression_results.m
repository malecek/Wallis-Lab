function save_regression_results(session, neuron, SpikeInfo, SpikeData)
% save_regression_results(session, neuron, SpikeInfo, SpikeData)
% 
% Save betas and p-values for sliding regression from -500 to 3250
% relative to the reward cue.  The regression uses a 200 ms window
% (centered on the points in the range mentioned) and moves in 10 ms steps.

trial_spikes = get_trial_spikes(SpikeInfo, SpikeData, neuron);
reward_conditions = get_reward_conditions(SpikeInfo);
betas = [];
p_values = [];
r_squareds = [];
for i = 1:10:size(trial_spikes,2)-199
    window_rates = mean(trial_spikes(:, i:i+199), 2);
    stats = regstats(window_rates, reward_conditions);
    betas = [betas; stats.beta(2)];
    p_values = [p_values; stats.fstat.pval];
    r_squareds = [r_squareds; stats.rsquare];
end
cd ~/Science/wallis/regression_results
save([session(1:4) '-' num2str(neuron)], 'betas', 'p_values', 'r_squareds')