function l = calculateDistance(varargin)
% calculating the length of a vector or the distance between two points

switch nargin
    case 1
        % vector input
        p = varargin{1};
        l = sqrt(sum(p.^2));
    case 2
        % two point input
        p1 = varargin{1};
        p2 = varargin{2};
        l = sqrt(sum((p2-p1).^2));
    otherwise
        error('Wrong number of arguments');
end