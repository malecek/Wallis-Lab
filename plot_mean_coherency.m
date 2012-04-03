cd ~/Science/wallis/spike_regression
load encoders
for i = 1:size(pos_encoders)
    encoder = pos_encoders(i, :);
    [coherency fs] = get_coherency(encoder);
    pos_coherencies(i, :) = coherency';
end
for i = 1:size(neg_encoders)
    encoder = neg_encoders(i, :);
    [coherency fs] = get_coherency(encoder);
    neg_coherencies(i, :) = coherency';
end
for i = 1:size(mixed_encoders)
    encoder = mixed_encoders(i, :);
    [coherency fs] = get_coherency(encoder);
    mixed_coherencies(i, :) = coherency';
end
mean_pos_c = mean(pos_coherencies, 1);
se_pos_c = std(pos_coherencies) / sqrt(size(pos_coherencies, 1));
mean_neg_c = mean(neg_coherencies, 1);
se_neg_c = std(neg_coherencies) / sqrt(size(neg_coherencies, 1));
mean_mixed_c = mean(mixed_coherencies, 1);
se_mixed_c = std(mixed_coherencies) / sqrt(size(mixed_coherencies, 1));
figure
errorbar(fs, mean_pos_c, se_pos_c, 'r')
errorbar(fs, mean_neg_c, se_neg_c, 'b')
errorbar(fs, mean_mixed_c, se_mixed_c, 'k')
xlabel('Frequency (Hz)')
ylabel('Coherency')
legend('Positive', 'Negative', 'Mixed', 'Location', 'Best')
print('-dpdf', '~/Science/wallis/figures/coherency')