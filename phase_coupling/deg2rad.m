function rads = deg2rad(degs, range)

% Convert angles from degrees to radians
% 
% Inputs:
% degs - angles in degrees
% range - optional string that describes the desired range of the angles:
%   = '-pitopi', range from -pi to pi radians
%   = '0to2pi',  range from 0 to 2pi radians
%   If omitted, the same range of the input angles is used for the output
%
% Outputs:
% rads - angles in radians in the range specified in input called range


% Function handle to convert phase from degrees to radians
rads = degs * pi / 180;

if nargin == 2
    
    if strmatch(range, '-pitopi', 'exact')
        change = find(rads > pi);
        rads(change) = rads(change) - 2 * pi;
    end
    
    if strmatch(range, '0to2pi', 'exact')
        change = find(rads < 0);
        rads(change) = 2 * pi + rads(change);
    end

end


