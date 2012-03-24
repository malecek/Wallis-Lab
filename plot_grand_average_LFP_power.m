home_dir = '~/data/wallis';
cd(home_dir)
load('encoders', 'pos_encoders')
% Remove duplicate entries corresponding to neurons from the same electrode.
pos_encoders = unique(pos_encoders(:, 1:end-1), 'rows');
all_matrices = zeros(17, 3751, length(pos_encoders));
for i = 1:length(pos_encoders)
    session_electrode = pos_encoders(i, :);
    [session, electrode] = strtok(session_electrode, '-');
    electrode = [electrode(2:end) '0'];
    cd([session '/LFP_time_series'])
    load([electrode '-filtered'])
    all_matrices(:, :, i) = LFP_power_matrix;
    cd('../../')
end
grand_average = mean(all_matrices, 3);
for i = 1:17
    for j = 1:3751
        standard_error(i,j) = std(all_matrices(i,j,:))/ ...
            sqrt(length(pos_encoders));
    end
end
cd(home_dir)
plot_mean_LFP_power('grand_average_pos', grand_average, standard_error)

close
clear all

home_dir = '~/data/wallis';
load('encoders', 'neg_encoders')
neg_encoders = unique(neg_encoders(:, 1:end-1), 'rows');
all_matrices = zeros(17, 3751, length(neg_encoders));
for i = 1:length(neg_encoders)
    session_electrode = neg_encoders(i, :);
    [session, electrode] = strtok(session_electrode, '-');
    electrode = [electrode(2:end) '0'];
    cd([session '/LFP_time_series'])
    load([electrode '-filtered'])
    all_matrices(:, :, i) = LFP_power_matrix;
    cd('../../')
end
grand_average = mean(all_matrices, 3);
for i = 1:17
    for j = 1:3751
        standard_error(i,j) = std(all_matrices(i,j,:))/ ...
            sqrt(length(neg_encoders));
    end
end
cd(home_dir)
plot_mean_LFP_power('grand_average_neg', grand_average, standard_error)