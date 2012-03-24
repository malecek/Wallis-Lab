cd ~/data/wallis
load LFP_encoders
frequencies = 2.^(0:0.5:8);
for i = 1:length(pos_encoders)
    encoder = pos_encoders(i, :);
    [session, elec_freq] = strtok(encoder, '-');
    elec_freq = elec_freq(2:end);
    [elec, freq] = strtok(elec_freq, '-');
    freq = str2num(freq(2:end));
    cd(session)
    [SpikeInfo, ~, ~, ~] = spk_read([session '.spk']);
    cd LFP_time_series
    load([elec '-filtered_trials'], 'LFP_power_matrix')
    reward_conditions = get_reward_conditions(SpikeInfo);
    condition_matrix = get_condition_power(reward_conditions,LFP_power_matrix);
    figure
    subplot(2, 1, 2);
    hold on
    reward_matrix = squeeze(condition_matrix(:, 5, :));
    [rew_mean, rew_sd] = get_reward_mean_sd(reward_matrix);
    contourf(reward_matrix);
    ylabel('Frequency (Hz)');
    xlabel('Time Relative to Reward Cue (ms)');
    title('Largest Reward');
    set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, 'YTick', ...
             1:2:length(frequencies),'YTickLabel',frequencies(1:2:end));
    c = colorbar;
    caxis([0 rew_mean+4.5*rew_sd]);
    set(get(c, 'ylabel'), 'string', 'normalized power');
    subplot(2, 1, 1);
    hold on
    reward_matrix = squeeze(condition_matrix(:, 1, :));
    contourf(reward_matrix);
    ylabel('Frequency (Hz)');
    xlabel('Time Relative to Reward Cue (ms)');
    title('Smallest Reward');
    set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, 'YTick', ...
             1:2:length(frequencies),'YTickLabel',frequencies(1:2:end));
    c = colorbar;
    caxis([0 rew_mean+4.5*rew_sd]);
    set(get(c, 'ylabel'), 'string', 'normalized power');
    print('-dpdf', ['reward_LFP_' elec]);
    close;
    fclose('all');
    cd('../../')
end
for i = 1:length(neg_encoders)
    encoder = neg_encoders(i, :);
    [session, elec_freq] = strtok(encoder, '-');
    elec_freq = elec_freq(2:end);
    [elec, freq] = strtok(elec_freq, '-');
    freq = str2num(freq(2:end));
    cd(session)
    [SpikeInfo, ~, ~, ~] = spk_read([session '.spk']);
    cd LFP_time_series
    load([elec '-filtered_trials'], 'LFP_power_matrix')
    reward_conditions = get_reward_conditions(SpikeInfo);
    condition_matrix = get_condition_power(reward_conditions,LFP_power_matrix);
    figure
    subplot(2, 1, 1)
    hold on
    reward_matrix = squeeze(condition_matrix(:, 1, :));
    [rew_mean, rew_sd] = get_reward_mean_sd(reward_matrix);
    contourf(reward_matrix);
    ylabel('Frequency (Hz)')
    xlabel('Time Relative to Reward Cue (ms)')
    title('Smallest Reward')
    set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, 'YTick', ...
             1:2:length(frequencies),'YTickLabel',frequencies(1:2:end));
    c = colorbar;
    caxis([0 rew_mean+4.5*rew_sd]);
    set(get(c, 'ylabel'), 'string', 'normalized power');
    subplot(2, 1, 2)
    hold on
    reward_matrix = squeeze(condition_matrix(:, 5, :));
    contourf(reward_matrix);
    ylabel('Frequency (Hz)')
    xlabel('Time Relative to Reward Cue (ms)')
    title('Largest Reward')
    set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000, 'YTick', ...
             1:2:length(frequencies),'YTickLabel',frequencies(1:2:end));
    c = colorbar;
    caxis([0 rew_mean+4.5*rew_sd]);
    set(get(c, 'ylabel'), 'string', 'normalized power');
    print('-dpdf', ['reward_LFP_' elec]);
    close;
    fclose('all');
    cd('../../')
end