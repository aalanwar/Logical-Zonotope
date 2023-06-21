function G = generators(Z)
% generators - Returns the generators of a zonotope 
%
% Syntax:  
%    G = generators(Z)
%
% Inputs:
%    Z - zonotope object
%
% Outputs:
%    G - cell of generators 
%
% Example: 
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
% See also: none

% Author:       Amr Alanwar
% Written:      16-October-2022 
% Last update:  ---
% Last revision:---

%------------- BEGIN CODE --------------

G = Z.GI;

%------------- END OF CODE --------------