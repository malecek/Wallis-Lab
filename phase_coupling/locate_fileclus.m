function [nfile nindex lfpindex celllistid] = locate_fileclus(neuron)

% locate_fileclus
% 
%  Finds the file index and cluster index for a given neuron. Indices given
%  in terms of celllist
%
% Used for LFP analysis 3b phase
%  Does the spiking of a given neuron fall in a particular LFP phase of a
% neighboring channel?
% During a given epoch in various frequency bands 
%
% Uses: celllist (global variable), spk_read_aowm (change to your version
% of spk_read)
%
% Inputs: 
%   neuron - unit with name format as one of these options:
%       'H0071202' - subj. session. channel. unit.
%       164 - index in celllist
% 
% Outputs: 
%   nfile - file index containing given neuron
%   nindex - cluster index of neuron given found after running spk_read
%   lfpindex - cluster index of lfp channel with given neuron found after
%   running spk_read
%   celllistid - index of neuron in celllist

global celllist

ischar = strmatch(class(neuron), 'char'); % 1 = yes, char, [] = no, not char

if ~isempty(ischar) % title includes character(s)
    item(:,1:4) = lower(char(celllist{1}(:,1)));
    item(:,5:8) = num2str(cell2mat(celllist{1}(:,2)));

    neuron = lower(neuron);
    celllistid = strmatch(neuron, item);
    nfile = strmatch(neuron(1:4), celllist{4});

    [SpikeInfo, SpikeFileHeader, SpikeVarHeader, SpikeData] = spk_read_aowm(['C:\CH\CH_SPK_Files\' neuron(1:4) '.spk']);
%     [SpikeInfo, SpikeFileHeader, SpikeVarHeader, SpikeData] = spk_read_aowm(['C:\Documents and Settings\Wallis Lab\My Documents\SPK_Files\' neuron(1:4) '.spk']);

    % Find index of neuron in SpikeData
    nindex = SpikeInfo.NeuronIndex(find(SpikeInfo.NeuronID == str2num(neuron(5:end)) ));

    % Find index of LFP
    lfp = floor(str2num(neuron(5:end))/100)*100;
    lfpindex = SpikeInfo.LFPIndex(find(SpikeInfo.LFPID == lfp ));
else
    celllistid = neuron;
    nfile = char(celllist{4}(strcmp(celllist{1}(celllistid,1),celllist{4})));
    
    [SpikeInfo, SpikeFileHeader, SpikeVarHeader, SpikeData] = spk_read_aowm(['C:\CH\CH_SPK_Files\' nfile '.spk']);
%     [SpikeInfo, SpikeFileHeader, SpikeVarHeader, SpikeData] = spk_read_aowm(['C:\Documents and Settings\Wallis Lab\My Documents\SPK_Files\' nfile '.spk']);

    nfile = strmatch(nfile, celllist{4});

    % Find index of neuron in SpikeData
    n = cell2mat(celllist{1}(neuron,2));
    nindex = SpikeInfo.NeuronIndex(find(SpikeInfo.NeuronID == n ));

    % Find index of LFP
    lfp = floor(n/100)*100;
    lfpindex = SpikeInfo.LFPIndex(find(SpikeInfo.LFPID == lfp ));
end

if isempty(lfpindex)
    lfpindex = NaN;
end

disp([num2str(nfile) ' - ' num2str(nindex) ' - ' num2str(lfpindex) ' - ' num2str(celllistid)]);
