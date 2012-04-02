function plot_mean_firing_rate(session, neuron, SpikeInfo, SpikeData)
% plot_mean_firing_rate(session, neuron, SpikeInfo, SpikeData)

trial_spikes = get_trial_spikes(SpikeInfo, SpikeData, neuron);
trial_spikes = smooth_spikes(trial_spikes);
reward_conditions = get_reward_conditions(SpikeInfo);
mean_firing_rate = get_condition_spikes(reward_conditions, trial_spikes);
colors = [0 0 0; 0 0 1; 0.5 0.3 0.8; 1 0.3 0.6; 1 0 0];
neuron = int2str(neuron);
figure;
hold on
for i=1:5
    plot(mean_firing_rate(i, :), 'Color', colors(i, :))
end
y_range = get(gca, 'ylim');
plot([501 501], y_range, 'k', 'LineWidth', 1.5)
plot([2001 2001], y_range, 'k', 'LineWidth', 1.5)
title([session '-' neuron])
ylabel('Firing Rate (Hz)');
set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000);
xlabel('Time Relative to Reward Cue (ms)')
legend('0.1 g', '0.2 g', '0.3 g', '0.4 g', '0.5 g', 'Location', 'Best');
print(['~/Science/wallis/figures/mean_firing_rate_' session '_' neuron],...
      '-djpeg');