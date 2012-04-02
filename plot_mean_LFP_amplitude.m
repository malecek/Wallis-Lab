function plot_mean_LFP_amplitude(session, electrode, low_reward, ...
                                 high_reward, lower_bound, upper_bound)
% plot_mean_LFP_amplitude(session, electrode, low_reward,
% high_reward, lower_bound, upper_bound)
% 
% Plot lowest reward on the left and highest on the right.

frequencies = 2.^(0:0.5:8);
n_frequencies = length(frequencies);
figure;
subplot(1, 2, 1)
hold on
contourf(low_reward);
set(gca, 'CLim', [lower_bound upper_bound]);
ylabel('Frequency (Hz)');
xlabel('Time Relative to Reward Cue (ms)')
title([session '-' int2str(electrode) ': Lowest Reward'])
plot([501 501], [1 n_frequencies], 'k', 'LineWidth', 1.5)
plot([2001 2001], [1 n_frequencies], 'k', 'LineWidth', 1.5)
set(gca, 'XTick', [501 2001], 'XTickLabel', [0 1500], ...
         'YTick', 1:2:n_frequencies, 'YTickLabel', frequencies(1:2:end));
c = colorbar;
set(get(c, 'ylabel'), 'string', 'standardized analytic amplitude');

subplot(1, 2, 2)
hold on
contourf(high_reward);
set(gca, 'CLim', [lower_bound upper_bound]);
ylabel('Frequency (Hz)');
xlabel('Time Relative to Reward Cue (ms)')
title([session '-' int2str(electrode) ': Highest Reward'])
plot([501 501], [1 n_frequencies], 'k', 'LineWidth', 1.5)
plot([2001 2001], [1 n_frequencies], 'k', 'LineWidth', 1.5)
set(gca, 'XTick', [501 2001], 'XTickLabel', [0 1500], ...
         'YTick', 1:2:n_frequencies, 'YTickLabel', frequencies(1:2:end));
c = colorbar;
set(get(c, 'ylabel'), 'string', 'standardized analytic amplitude');

print('-dpdf', ['~/Science/wallis/figures/' session '_' int2str(electrode) ...
                '_LFP_amplitude'])