% LFP analysis - phase coupling
%
%  Does the spiking of a given neuron fall in a particular LFP phase of a
% neighboring channel during a given task epoch in various frequency bands?
%
%  The top part of the script collects the data, while the bottom part
% plots the data.
%
% Calls these non-Matlab-exclusive functions:
% find_neighbor, locate_fileclus, spk_read, get_correct_trials,
% group_conds, get_code_time_freq, gaussian_filter_signal
%   Optional: deg2rad, if need [-pi, pi] to be [0, 2pi]
%
% Inputs: 
%   celllist, center_freqs
%       Optional: fractional_bandwidths
%
% Outputs: 
%   phi = a vector with all the instantaneous LFP phases for each spike
%   phi is stored as .mat file in the following format:
%   "phi_<freq band index>_<neuron ID in celllist>_<LFP neighbor ID in celllist>_<cond. grp>"
%   
%   <freq band index> = index of the frequency band the LFP has been
%   isolated for
%     If you have n frequency bands, then the lowest band has freq band
%     index of 1, the 2nd lowest band has index 2, and so on. The highest
%     band will have index n. Higher indices correspond to bands with
%     higher frequencies.
%       
%   <neuron ID in celllist> = index of the cell from which you are taking
%   spikes
%
%   <LFP neighbor ID in celllist> = index of a cell in celllist that is a
%   neighbor of the cell from which you are taking spikes
%       This analysis assumes LFPs are taking from electrodes that also
%       contain neurons and hence is present in celllist
%
%   <cond. grp> = the group of conditions of trials from which you are
%   taking spikes and LFPs
%       For instance, if your task has pictures A and B paired with rewards
%       X and Y, you have 4 conditions: AX, AY, BX, and BY. You may group
%       them by reward type: 1) AX and BX trials, 2) AY and BY trials. Your
%       cond. grp are then 1 and 2 to refer to reward groups X and Y


close all
clear all


% Fill in with the folder containing your celllist and where you want the
% output data to go
cd('C:\Documents and Settings\Wallis Lab\LFP analysis 3b phase')


global celllist
load celllist


%% Initialize parameters

% Choose how many frequency bands to use:
    % 45 bands - how many Ryan Canolty used on Steve Kennerley's data
    load fractional_bandwidths; 
    load center_freqs;
    
    % Convert to single to conserve memory
    fractional_bandwidths = single(fractional_bandwidths);
    center_freqs = single(center_freqs);

    % Below code is commented out, because 6 bands yields uninterpretable
    % results. This is kept here, in case you want to debug code with less
    % bands, which takes less time to run
%     % Only 6 frequency bands: delta 0-4, theta 4-8, alpha 8-12, beta
%     % 12-30, low gamma 30-60, high gamma 60-240
%     center_freqs = [2 6 10 21 45 150];
%     fractional_bandwidths = [2 2 2 9 15 90];
 

srate = 1000; % LFP data is sampled at 1 kHz
alpha = 0.05;


% Window of analysis
    % Time (ms) before event code
    % Negative numbers mean after the event code
    windowbefore = -200; 

    % Time (ms) after event code
    % Negative numbers mean before the event code
    windowafter = 1000;
    
    % Occurrence of event code in trial:
    % 1 for first appearance of code within trial
    coderepetition = 1; 
    
    
% Sort conditions into groups
%   If your task has pictures A and B paired with rewards X and Y, you have
% 4 conditions AX, AY, BX, and BY indexed with 1-4, respectively. If you
% group them then by reward type, you get 2 groups: one for X, another for
% Y. It'd be written as defgroup = [1 3; 2 4];
defgroup = [1 3; 2 4];


% Select specific neurons to run this code on
neuron = {'H0041202' 'H0071301' 'H0111301' 'H0131501' 'H0181001'...
    'H0181301' 'H0201101' 'H0201201' 'H0201502' 'H0211501' 'J0031502' ...
    'J0051102' 'J0191101' 'J0261601'};


% Initialize file info and counter
fileinfo = []; 
ctr = 1;


%% Cycle through neurons. Find file and cluster info of neuron and LFP chs

for n = 1:length(neuron)
    
    [nfile nindex lfpindex celllistid] = locate_fileclus(neuron{n});

    % Find LFP channels
    [lfp lfpcelllistID] = find_neighbor(neuron, celllistid);
    lfpfile = zeros(size(lfp, 1), 1); 
    lfpclus = zeros(size(lfp, 1), 1);
    for i = 1:size(lfp, 1)
        [a b lfpclus(i) c] = locate_fileclus(lfpcelllistID);
    end

    
%% Create files

    for g = 1:size(defgroup, 1)
        for neighbors = 1:size(lfp, 1)
            filename = sprintf('phi_%d_%d_%d.txt', celllistid, ...
                lfpcelllistID(neighbors), g);
            dlmwrite(filename, '');
        end
    end

    
%% Get session behavioral data

    [SpikeInfo, SpikeFileHeader, SpikeVarHeader, SpikeData] ...
        = spk_read(['C:\CH\CH_SPK_Files\' neuron{n}(1:4) '.spk']);

    % Convert to milliseconds
    tstarts = round(1000 * SpikeInfo.TrialStartTimes); 
    
    [corrects rews] = get_correct_trials(SpikeInfo, code);

    % Group trials accordingly
    groups = group_conds(SpikeInfo.ConditionNumber, defgroup);
    groups = single(groups(corrects));

    % Get behavioral event code to which analysis window sync
    rewcode = 80; % reward onsets    
    [codetimes codefreq] = get_code_time_freq(corrects, SpikeInfo, code);
    
    % 1st column => reward in first outcome epoch; time in trial
    event_times = codetimes(:, coderepetition);     
    
    % Time in session
    event_times = event_times + SpikeInfo.TrialStartTimes(corrects) * 1000; 

    
%% Get neuronal data
    ndata = single(SpikeData{nindex});
    
    
%% Cycle through each neighboring LFP channel

    for neighbors = 1:size(lfp, 1)

        data = single(SpikeData{lfpclus(neighbors)});

        % If you have memory issues, shortened the data!
        % To start, truncate event codes to exclude those clearly after the
        % termination of 'data'
    %     data = data(1:500000);    


    %% Cycle through each frequency band

        for freqi = 1:length(center_freqs)

            % Get phases on that electrode
            single_channel_frequency(1, :) ...
                = gaussian_filter_signal('output_type', 'real_phase', ...
                'raw_signal', data, 'sampling_rate', srate, ...
                'center_frequency', center_freqs(freqi), ...
                'fractional_bandwidth', fractional_bandwidths(freqi));


    %% Cycle through condition groupings

            for g = 1:size(defgroup, 1)

                event_times_g = event_times(find(groups == g));

                % If you have memory issues, truncate event codes!
                % To start, exclude those clearly after the termination of
                % 'data'
    %             event_times_g = event_times_g(1:15);

                % Track file info, so opening files to graph phases is
                % easier
                fileinfo(ctr, :) = [celllistid lfpcelllistID(neighbors) g];
                ctr = ctr + 1;


    %% Get spikes, save spikes

                timestamps = round(1000 * ndata); % Convert to milliseconds

                phi = []; 
                startctr = 1;
                for epoch = 1:length(event_times_g)

                    % Window in which to seek out spikes
                    beginstamp = event_times_g(epoch) - windowbefore;
                    stopstamp = event_times_g(epoch) + windowafter;

                    spkidx_inepoch = find(timestamps >= beginstamp ...
                        & timestamps <= stopstamp);
                    stopctr = startctr + length(spkidx_inepoch) - 1;
                    phi(startctr:stopctr) ...
                        = single_channel_frequency(timestamps( ...
                        spkidx_inepoch));
                    startctr = stopctr + 1;

                end        

                % Save phases of the spikes
                filename = sprintf('phi_%d_%d_%d.txt', ...
                    celllistid, lfpcelllistID(neighbors), g);
                dlmwrite(filename,phi, '-append', 'delimiter', '\t', ...
                    'roffset', freqi);

            end % groupings

        end % freqi
        
    end % neighbors
    
end % neurons


%%%%%%%%%%%%%- Bottom part of script below: plots results -%%%%%%%%%%%%%%%%

%% Isolate results

stats = [];
fileinfo = unique(fileinfo, 'rows');
for i = 1:size(fileinfo, 1) % Go through each file

    filename = sprintf('phi_%d_%d_%d.txt', fileinfo(i, 1), ...
        fileinfo(i, 2), fileinfo(i, 3)); % neuron, lfp ch, grouping

    % Retrieve data
    data = dlmread(filename);
    
    % Data must be a column vector
    if size(data, 1) <= length(center_freqs)
        data = data';
    end
    
    mat = [];
    for freqi = 1:length(center_freqs)            
        % Rayleigh's test for nonuniformity - assumes data is from a 
        % von Mises distribution
        % H0 - uniform distribution around circle
        % HA - not uniform distribution around circle
        [pval, z] = circ_rtest(data(:, freqi));

        % Omnibus Hodges-Ajne test - detects deviations from uniformity.
        % Works well with unimodal, bimodal, and multimodal distributions
        [pval_o, z_o] = circ_otest(data(:, freqi));

        % Circular K-means clustering
%             [c_id, c_sorted, c_mu] = circ_clust(data(:,freqi), 2, 'true');

        % Mean phase, standard deviation, median phase
        mu = circ_rad2ang(circ_mean(data(:, freqi)));
        std = circ_rad2ang(circ_std(data(:, freqi)));
        med = circ_rad2ang(circ_median(data(:, freqi)));

        signif = [pval < alpha  pval_o < alpha];
        mat(freqi, :) = [center_freqs(freqi) mu med pval pval_o signif];
    end
    stats{i} = mat;
    
end


%% Graph 1) all phases and 2) significant mean phases

% 1) All phases
figure;
hold on;

x = -pi:.1:pi;
y = cos(x);
p = plot(x, y, 'LineWidth', 3);
set(gca,'XTick', -pi:pi/2:pi)
set(gca,'XTickLabel', {'-pi','-pi/2','0','pi/2','pi'})
xlabel('-\pi \leq \Theta \leq \pi')
ylabel('cos(\Theta)')
title('All phases plotted on cos(\Theta)')

for i = 1:length(stats)
    plot(circ_ang2rad(stats{i}(:,2)), ...
        cos(circ_ang2rad(stats{i}(:,2))), ...
        'g*', 'LineWidth', 3, 'MarkerSize', 5);
end
hold off;

% 2) Significant mean phases only
figure;
hold on;

x = -pi:.1:pi;
y = cos(x);
p = plot(x, y, 'LineWidth', 3);
set(gca, 'XTick', -pi:pi/2:pi)
set(gca, 'XTickLabel', {'-pi','-pi/2','0','pi/2','pi'})
xlabel('-\pi \leq \Theta \leq \pi')
ylabel('cos(\Theta)')
title('Just signif. phases plotted on cos(\Theta)')

for i = 1:length(stats)
    plot(circ_ang2rad(stats{i}(sum(stats{1}(:,6:7), 2) > 1, 2)), ...
        cos(circ_ang2rad(stats{i}(sum(stats{1}(:,6:7), 2) > 1, 2))), ...
        'g*', 'LineWidth', 3, 'MarkerSize', 5);
end
