function plot_mean_firing_rate(varargin)
% 1) plot_mean_firing_rate(session, neuron, SpikeInfo, SpikeData)
% 2) plot_mean_firing_rate(neuron_matrix, encoding_sign)
% 
% neuron_matrix is neurons X conditions X ms relative to reward cue
% (-500 to 3250).

if length(varargin) == 4
    session = varargin{1};
    neuron = varargin{2};
    SpikeInfo = varargin{3};
    SpikeData = varargin{4};
    mean_firing_rate = get_mean_firing_rate(neuron, SpikeInfo, SpikeData);
else
    neuron_matrix = varargin{1};
    encoding_sign = varargin{2};
    mean_firing_rate = mean(neuron_matrix, 1);
    std_error = squeeze(std(mean_firing_rate)) / sqrt(size(neuron_matrix,1));
end
colors = [0 0 1; 0.25 0 0.75; 0.5 0 0.5; 0.75 0 0.25; 1 0 0];
figure;
hold on
for i=1:5
    [hl,hp]=boundedline(1:size(mean_firing_rate,2),mean_firing_rate(i,:),...
                        std_error(i,:),colors(i,:));
    set(get(get(hp,'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
end
ylabel('Firing Rate (Hz)');
set(gca, 'XTick', 501:500:3501, 'XTickLabel', 0:500:3000);
xlabel('Time Relative to Reward Cue (ms)')
legend('0.1 g', '0.2 g', '0.3 g', '0.4 g', '0.5 g', 'Location', 'SouthEast');
if length(varargin) == 4
    print(gcf, ['mean_firing_rate_' session '_' neuron], '-dpdf');
else
    print(gcf, ['grand_average_firing_rate_' encoding_sign], '-dpdf');
fclose('all');