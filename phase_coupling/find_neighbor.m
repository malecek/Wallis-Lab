function [lfp lfpcelllistID] = find_neighbor(varargin)

% find_neighbor
% 
%  Finds neighboring channels for a given channel. Assumes all channels
%  have cells on them.
%
% Used for LFP analysis 3b phase
%  Does the spiking of a given neuron fall in a particular LFP phase of a
% neighboring channel?
% During a given epoch in various frequency bands 
%
% Uses: celllist (global)
%
% Inputs: 
% varargin = [neuron] or [neuron, celllistid]
%   neuron - unit from which neighbors shall be found
%       Unit's name should be formatted as one of these options:
%       'H0100802' - H = subject, 010 = session, 08 = channel ID, 02 = unit
%       164 - index in celllist
%   celllistid - index in celllist of neuron, e.g., 164
% 
% Outputs: column vectors
%   lfp - neighboring neuron unit(s) from which LFP shall be taken, e.g., 
%         'h024' [1002]
%   lfpcelllistID - row in celllist containing neighbors, e.g., 165
%
% Format for channels in analyses:
% 'H0071201' - H = subject, 007 = session, 12 = channel ID, 01 = neuron


global celllist

if length(varargin) == 1
    % Only neuron has been supplied as input.
    [nfile nindex lfpindex celllistid] = locate_fileclus(varargin);
else
    % neuron and celllistid have been supplied.
    celllistid = cell2mat(varargin(2));
end

% Of the units recorded that session, find the ones in the same brain area
% and spaced 1 mm away (LM or AP direction)
area_lm_ap = cell2mat(celllist{1}(celllistid, 3:5));

samesession = strmatch(celllist{1}(celllistid, 1), celllist{1}(:, 1));
sublist = celllist{1}(samesession, :);

ctr = 1; lfpchs = []; lfpcelllistID = [];
for i = 1:length(samesession)
    
    if cell2mat(sublist(i, 3)) == area_lm_ap(1) % same brain area
        
        deltas = abs(area_lm_ap(2:3) - cell2mat(sublist(i, 4:5)));
        
        if sum(deltas) == 1 % 1 mm distance
            lfpchs(ctr, 1) = round(cell2mat(sublist(i, 2)) / 100) * 100;
            lfpcelllistID(ctr, 1) = samesession(i);
            ctr = ctr + 1;
        end
        
    end
    
end

if isempty(lfpchs)
    
    disp('No neighbors');
    lfp = [];
    
else
    
    % Remove redundant channels
    [lfps indices] = unique(lfpchs);
    
    % ID in celllist of neighboring LFP channels
    lfpcelllistID = lfpcelllistID(indices, 1); 
    
    % Neighboring neuron(s) from which LFP is taken
    lfp = celllist{1}(lfpcelllistID, 1:2); 
    
end