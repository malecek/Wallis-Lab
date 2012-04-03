cd ~/Science/wallis/LFP_regression
load('encoders', 'pos_encoders', 'neg_encoders')
frequencies = 2.^(0:0.5:8);
% The frequency values saved in encoders are only to four decimal
% places (not rounded, but the first four in the actual numbers).
% In order to compare them to the actual frequencies, we need to
% round to three decimal places.
for i = 1:length(frequencies)
    frequencies(i) = round2(frequencies(i), 1e-3);
end
encoder_types = ['pos'; 'neg'];
for i = 1:size(encoder_types, 1)
    sign = encoder_types(i, :);
    eval([sign '_counts = zeros(1, 17);'])
    for j = 1:size(eval([sign '_encoders']), 2)
        match = regexp(eval([sign '_encoders{j}']), '-', 'split');
        freq = str2num(regexprep(match{3}, '_', '.'));
        freq = round2(freq, 1e-3);
        i_freq = find(frequencies == freq);
        eval([sign '_counts(i_freq) = ' sign '_counts(i_freq) + 1;'])
    end
end
colors = 'rb';
figure
hold on
for i = 1:size(encoder_types, 1)
    sign = encoder_types(i, :);
    plot(eval([sign '_counts']), colors(i))
end
xlabel('Frequencies (Hz)')
ylabel('Number of Encoding Electrodes')
legend('Positive', 'Negative', 'Location', 'Best')
set(gca, 'XTick', 1:2:17, 'XTickLabel', frequencies(1:2:end))
print('-dpdf', '~/Science/wallis/figures/LFP_encoders')