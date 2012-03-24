function plot_mean_LFP_power(fig_title, power_matrix, standard_error)
% plot_mean_LFP_power(title, power_matrix, standard_error)

frequencies = 2.^(0:0.5:8);
figure;
% Note: The highest frequency is the top row of the plot (even
% though it's the bottom row of the matrix).
subplot(3, 1, 1)
contourf(power_matrix - standard_error);
ylabel('Frequency (Hz)');
xlabel('Time Relative to Reward Cue (ms)')
set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, ...
         'YTick', 1:2:length(frequencies), 'YTickLabel', frequencies(1:2:end));
c = colorbar;
set(get(c, 'ylabel'), 'string', 'normalized power - std. err.');

subplot(3, 1, 2)
contourf(power_matrix);
ylabel('Frequency (Hz)');
xlabel('Time Relative to Reward Cue (ms)')
set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, ...
         'YTick', 1:2:length(frequencies), 'YTickLabel', frequencies(1:2:end));
c = colorbar;
set(get(c, 'ylabel'), 'string', 'normalized power');

subplot(3, 1, 3)
contourf(power_matrix + standard_error);
ylabel('Frequency (Hz)');
xlabel('Time Relative to Reward Cue (ms)')
set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, ...
         'YTick', 1:2:length(frequencies), 'YTickLabel', frequencies(1:2:end));
c = colorbar;
set(get(c, 'ylabel'), 'string', 'normalized power + std. err.');

print('-dpdf', ['mean_LFP_power_' fig_title]);