cd ~/Science/wallis/spike_regression
load encoders
cd ~/Science/wallis/coherencies
for i = 1:size(pos_encoders)
    encoder = pos_encoders(i, :);
    [coherency fs] = get_coherency(encoder);
    pos_coherencies(i, :) = coherency';
end
save('pos_coherencies', 'pos_coherencies')
for i = 1:size(neg_encoders)
    encoder = neg_encoders(i, :);
    [coherency fs] = get_coherency(encoder);
    neg_coherencies(i, :) = coherency';
end
save('neg_coherencies', 'neg_coherencies')
for i = 1:size(mixed_encoders)
    encoder = mixed_encoders(i, :);
    [coherency fs] = get_coherency(encoder);
    mixed_coherencies(i, :) = coherency';
end
save('mixed_coherencies', 'mixed_coherencies')