cd ~/Science/wallis/coherencies
% Remove data for frequencies > 300 Hz.
load pos_coherencies 
pos_coherencies = pos_coherencies(:, 1:615);
load mixed_coherencies 
mixed_coherencies = mixed_coherencies(:, 1:615);
load neg_coherencies
neg_coherencies = neg_coherencies(:, 1:615);
load('frequencies', 'fs')
fs = fs(1:615);
mean_pos_c = nanmean(pos_coherencies, 1);
se_pos_c = nanstd(pos_coherencies) / sqrt(size(pos_coherencies, 1));
mean_neg_c = nanmean(neg_coherencies, 1);
se_neg_c = nanstd(neg_coherencies) / sqrt(size(neg_coherencies, 1));
mean_mixed_c = nanmean(mixed_coherencies, 1);
se_mixed_c = nanstd(mixed_coherencies) / sqrt(size(mixed_coherencies, 1));
figure
encoder_types = {'pos'; 'neg'; 'mixed'};
colors = 'rbk';
for i = 1:3
    hp = boundedline(fs, eval(['mean_' encoder_types{i} '_c']), ...
                eval(['se_' encoder_types{i} '_c']), 'alpha', colors(i));
    hold on
    set(get(get(hp(1),'Annotation'),'LegendInformation'), ...
        'IconDisplayStyle','off')
end
xlabel('Frequency (Hz)')
ylabel('Coherency')
legend('Positive', 'Negative', 'Mixed', 'Location', 'Best')
print('-dpdf', '~/Science/wallis/figures/coherency_plot')