function res = containsPoint(Z,p)
% containsPoint - determines if the point p is inside the logical poly zonotope Z1
%
% Syntax:
%    res = containsPoint(Z,p)
%
% Inputs:
%    Z - zonotope object
%    p - point specified as a vector
%
% Outputs:
%    res - boolean whether the point is inside the logical poly zonotope or not
%
%
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: ---

% Author:       Amr Alanwar
% Written:      7-Jan-2023
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

% parse input arguments
points = evaluate(Z);


points=unique(points','rows')';

if ismember(p',points','rows')
    res = true;
else
    res = false;
end

%------------- END OF CODE --------------
