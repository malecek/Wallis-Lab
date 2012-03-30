function plot_encoders(r_squareds, encoder_type)
% plot_encoders(r_squareds, encoder_type)
% 
% Inputs
% ------
% r_squareds : matrix
%   Neurons by windows.  Values are r^2.
% 
% encoder_type : string
%   'neg', 'pos', or 'mixed'

figure
hold on
pcolor(r_squareds)
c = colorbar;
set(get(c, 'ylabel'), 'string', 'r^2');
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