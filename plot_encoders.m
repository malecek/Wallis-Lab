function plot_encoders(r_squareds, p_values, encoder_type)
% plot_encoders(r_squareds, encoder_type)
% 
% Inputs
% ------
% r_squareds : matrix
%   Neurons by windows.
% 
% p_values : matrix
%   Neurons by windows.
% 
% encoder_type : string
%   'neg', 'pos', or 'mixed'

r_squareds = sort_r_squareds_by_latency(r_squareds, p_values);
figure
hold on
h = pcolor(r_squareds.*100);
a = get(h, 'Parent');
set(a, 'CLim', [0 20]);
c = colorbar;
set(get(c, 'ylabel'), 'string', 'PEV');
shading('flat')
xlabel('Time Relative to Reward Cue (ms)')
ylabel('Neurons')
n_neurons = size(r_squareds, 1);
plot([41 41], [1 n_neurons], 'k', 'LineWidth', 1.5)
plot([191 191], [1 n_neurons], 'k', 'LineWidth', 1.5)
set(gca, 'XTick', [41 191], 'XTickLabel', {'-100 to 99' '1400 to 1599'}, ...
         'XLim', [1 366], 'YLim', [1 n_neurons])
switch encoder_type
  case 'pos'
    title('Positive Encoders')
    print('-dpdf', '~/Science/wallis/figures/positive_pseudocolor')
  case 'neg'
    title('Negative Encoders')
    print('-dpdf', '~/Science/wallis/figures/negative_pseudocolor')
  case 'mixed'
    title('Mixed Encoders')
    print('-dpdf', '~/Science/wallis/figures/mixed_pseudocolor')
end