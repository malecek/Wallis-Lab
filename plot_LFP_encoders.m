cd ~/data/wallis/
frequencies = 2.^(0:0.5:8);
load LFP_encoders
freq_counts = zeros(1, 17);
for i = 1:size(pos_encoders, 1)
    encoder = pos_encoders(i, :);
    [subject, elec_freq] = strtok(encoder, '-');
    elec_freq = elec_freq(2:end);
    [elec, freq] = strtok(elec_freq, '-');
    freq = str2num(freq(2:end));
    freq_counts(freq) = freq_counts(freq) + 1;
end
figure
subplot(2, 1, 1);
hold on
bar(freq_counts)
xlabel('Frequencies (Hz)')
ylabel('Number of Positively Encoding Electrodes')
set(gca, 'XTick', 1:2:17, 'XTickLabel', frequencies(1:2:end))

freq_counts = zeros(1, 17);
for i = 1:size(neg_encoders, 1)
    encoder = neg_encoders(i, :);
    [subject, elec_freq] = strtok(encoder, '-');
    elec_freq = elec_freq(2:end);
    [elec, freq] = strtok(elec_freq, '-');
    freq = str2num(freq(2:end));
    freq_counts(freq) = freq_counts(freq) + 1;
end
subplot(2, 1, 2);
hold on
bar(freq_counts)
xlabel('Frequencies (Hz)')
ylabel('Number of Positively Encoding Electrodes')
set(gca, 'XTick', 1:2:17, 'XTickLabel', frequencies(1:2:end))
print('-dpdf', 'frequency_encoding_histogram')